// 6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
// con la información correspondiente a las prendas que se encuentran a la venta. De
// cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
// precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
// a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
// quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
// y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
// correspondiente a valor negativo.
// Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
// compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
// el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
// que no fueron borradas, una vez realizadas todas las bajas físicas

program ejercicio6;

const
    FIN_ARCHIVO = 32767;
    MARCA_ELIMINADO = -1;

type
    cadena_corta = string[45];
    cadena_larga = string[90];
    tipo_codigo = integer;
    tipo_prenda = record
        codigo: tipo_codigo;
        descripcion: cadena_larga;
        colores: cadena_larga;
        tipo: cadena_corta;
        stock: integer;
        precio: double;
    end;
    archivo_prendas = file of tipo_prenda;
    archivo_detalle = file of tipo_codigo;

procedure LeerPrendaDeArchivo(var a: archivo_prendas; var p: tipo_prenda);
begin
    if (not EOF(a)) then
        read(a, p)
    else
        p.codigo := FIN_ARCHIVO;
end;

procedure LeerCodigoDeArchivo(var a: archivo_detalle; var c: tipo_codigo);
begin
    if (not EOF(a)) then
        read(a, c)
    else
        c := FIN_ARCHIVO;
end;

procedure Actualizar(var maestro: archivo_prendas; var detalle: archivo_detalle);
var
    prenda: tipo_prenda;
    codigo: tipo_codigo;
begin
    reset(maestro);
    reset(detalle);

    LeerCodigoDeArchivo(detalle, codigo);
    LeerPrendaDeArchivo(maestro, prenda);
    while (codigo <> FIN_ARCHIVO) do begin
        while (prenda.codigo <> FIN_ARCHIVO) and (prenda.codigo <> codigo) do
            LeerPrendaDeArchivo(maestro, prenda);
        if (prenda.codigo = codigo) then begin
            prenda.stock := MARCA_ELIMINADO;
            seek(maestro, FilePos(maestro) - 1);
            write(maestro, prenda);
        end;
        seek(maestro, 0);
        LeerCodigoDeArchivo(detalle, codigo);
    end;

    close(maestro);
    close(detalle);
end;


begin
  
end.