// Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
// De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
// stock mínimo y precio del producto.
// Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
// debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
// maestro. La información que se recibe en los detalles es: código de producto y cantidad
// vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
// descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
// debajo del stock mínimo.
// Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
// puede venir 0 o N registros de un determinado producto.


program ejercicio3;

Uses sysutils;

const 
    FIN_ARCHIVO = -1;
    CANTIDAD_SUCURSALES = 30;
    INICIO_ARCHIVO = 1;
type
    cadena_corta = string[20];
    cadena_larga = string[100];
    tipo_producto = record
        codigo: integer;
        nombre: cadena_corta;
        descripcion: cadena_larga;
        stock_disponible: integer;
        stock_minimo: integer;
        precio: double;
    end;

    tipo_detalle = record
        codigo: integer;
        ventas: integer;
    end;

    archivo_productos = file of tipo_producto;
    archivo_detalle = file of tipo_detalle;

procedure LeerProducto(var a: archivo_productos; var p: tipo_producto);
begin
    if (not EOF(a)) then
        read(a, p)
    else
        p.codigo := FIN_ARCHIVO;
end;

procedure LeerDetalle(var a: archivo_detalle; var d: tipo_detalle);
begin
    if (not EOF(a)) then
        read(a, d)
    else
        d.codigo := FIN_ARCHIVO;
end;

procedure Actualizar();
var
    archivo: archivo_productos;
    arch_detalle: archivo_detalle;
    detalle: tipo_detalle;
    producto: tipo_producto;
    i: integer;
    codigo_procesado: integer;
    nombre_detalle: string;
    nro_sucursal: string;
    ventas_total: integer;
begin
    assign(archivo, 'productos.dat');
    reset(archivo);

    for i := 1 to CANTIDAD_SUCURSALES do begin
        nro_sucursal := IntToStr(i);
        nombre_detalle := 'detalle-' + nro_sucursal + '.dat';
        assign(arch_detalle, nombre_detalle);
        reset(arch_detalle);
        
        LeerDetalle(arch_detalle, detalle);
        codigo_procesado := detalle.codigo;
        while (codigo_procesado <> FIN_ARCHIVO) do begin
            ventas_total := 0;

            while (codigo_procesado = detalle.codigo) and (codigo_procesado <> FIN_ARCHIVO) do begin
                ventas_total := ventas_total + detalle.ventas;

                LeerDetalle(arch_detalle, detalle);
            end;

            LeerProducto(archivo, producto);
            while (codigo_procesado <> producto.codigo) do
                LeerProducto(archivo, producto);
            
            producto.stock_disponible := producto.stock_disponible - ventas_total;
            
            write(archivo, producto);

            seek(archivo, INICIO_ARCHIVO);

            // Procesar siguiente codigo (En detalle quedó el primer registro con codigo distinto al procesado)
            codigo_procesado := detalle.codigo;
        end;

        close(arch_detalle);
    end;

    close(archivo);
end;

procedure ExportarBajoStock();
var
    archivo: archivo_productos;
    salida: Text;
    producto: tipo_producto;

begin
    assign(archivo, 'productos.dat');
    assign(salida, 'bajo-stock.txt');
    reset(archivo);
    rewrite(salida);

    LeerProducto(archivo, producto);
    while (producto.codigo <> FIN_ARCHIVO) do begin
        with producto do begin
            if (stock_disponible < stock_minimo) then
                WriteLn(salida, nombre);
                Writeln(salida, descripcion);
                Writeln(salida, precio, stock_disponible);
        end;

        LeerProducto(archivo, producto);
    end;

    close(archivo);
    close(salida);

    
end;


begin
    write('hola');

    
end.