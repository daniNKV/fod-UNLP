// El encargado de ventas de un negocio de productos de limpieza desea administrar el
// stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
// los productos que comercializa. 
// De cada producto se maneja la siguiente información: código de producto, nombre comercial, 
// precio de venta, stock actual y stock mínimo.
// Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
// realizadas. 
// De cada venta se registran: código de producto y cantidad de unidades vendidas.
// Se pide realizar un programa con opciones para:
//      a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
//          ● Ambos archivos están ordenados por código de producto.
//          ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
//            archivo detalle.
//          ● El archivo detalle sólo contiene registros que están en el archivo maestro.
//      b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
//         stock actual esté por debajo del stock mínimo permitido

program ejercicio7;
const
  FIN_ARCHIVO = 32767;
type 
  cadena_corta = string[40];
  tipo_producto = record
    codigo: integer;
    nombre: cadena_corta;
    precio: double;
    stock_actual: integer;
    stock_minimo: integer;
  end;

  tipo_venta = record
    codigo: integer;
    cantidad: integer;
  end;

  archivo_maestro = file of tipo_producto;
  archivo_detalle = file of tipo_venta;


procedure LeerVenta(var a: archivo_detalle; var v: tipo_venta);
begin
  if (not EOF(a)) then
    Read(a, v)
  else v.codigo := FIN_ARCHIVO;
end;

procedure LeerProducto(var a: archivo_maestro; var p: tipo_producto);
begin
  if (not EOF(a)) then
    Read(a, p)
  else p.codigo := FIN_ARCHIVO;
end;

procedure Actualizar();
var
  maestro: archivo_maestro;
  detalle: archivo_detalle;
  venta: tipo_venta;
  venta_leida: tipo_venta;
  producto: tipo_producto;

begin
  Assign(maestro, 'maestro.dat');
  Assign(detalle, 'detalle.dat');
  Reset(maestro);
  Rewrite(detalle);

  LeerVenta(detalle, venta_leida);
  while (venta_leida.codigo <> FIN_ARCHIVO) do begin
    venta.codigo := venta_leida.codigo;
    venta.cantidad := 0;
    while (venta_leida.codigo <> FIN_ARCHIVO) and (venta.codigo <> venta_leida.codigo) do begin
      venta.cantidad := venta.cantidad + venta_leida.cantidad;
      LeerVenta(detalle, venta_leida);
    end;

    LeerProducto(maestro, producto);
    while (producto.codigo <> FIN_ARCHIVO) and (producto.codigo <> venta.codigo) do begin
      if (producto.codigo = venta.codigo) then
        producto.stock_actual := producto.stock_actual - venta.cantidad;
      LeerProducto(maestro, producto);
    end;
  end;
  
  close(maestro);
  close(detalle);

end;

procedure Exportar();
var
  archivo: archivo_maestro;
  nuevo_archivo: Text;
  producto: tipo_producto;
begin
  Assign(archivo, 'maestro.dat');
  Assign(nuevo_archivo, 'bajo-stock.txt');
  Reset(archivo);
  Rewrite(nuevo_archivo);

  LeerProducto(archivo, producto);
  with producto do begin
    while (producto.codigo <> FIN_ARCHIVO) do begin
      if (producto.stock_actual < producto.stock_minimo) then
        Writeln(nuevo_archivo, nombre);
        Writeln(nuevo_archivo, codigo, precio);
        Writeln(nuevo_archivo, stock_actual, stock_minimo);
    end;
  end;
end;

var
  opcion: char;
begin
  Writeln('##########################');
  Writeln();
  Writeln('A: Actualizar');
  WriteLn('B: Exportar');
  Writeln();

  Write('Ingrese una opción: ');
  Readln(opcion);

  case opcion of 
    'A', 'a': Actualizar();
    'B', 'b': Exportar();
  end;

end.