// Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
// los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
// cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
// mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
// cliente.
// Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
// empresa.
// El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
// mes, día y monto de la venta.
// El orden del archivo está dado por: cod cliente, año y mes.
// Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
// compras

program ejercicio8;
const
    CANTIDAD_MESES = 12;
    FIN_ARCHIVO = 32767;
type
    cadena_corta = string[40];
    tipo_cliente = record
        codigo: integer;
        nombre: cadena_corta;
        apellido: cadena_corta;
    end;

    tipo_fecha = record
        anio: integer;
        mes: integer;
        dia: integer;
    end;

    tipo_maestro = record
        cliente: tipo_cliente;
        fecha: tipo_fecha;
        monto: double;
    end;

    tipo_totales = record
        mensual: array[1 .. CANTIDAD_MESES] of double;
        anual: double;
    end;

    tipo_reporte = record
        cliente: tipo_cliente;
        total: tipo_totales;
    end;

    archivo_ventas = file of tipo_maestro;
    archivo_reporte = file of tipo_reporte; 


procedure LeerVenta(var a: archivo_ventas; var v: tipo_maestro);
begin
    if (not EOF(a)) then
        Read(a, v)
    else
        v.cliente.codigo := FIN_ARCHIVO;
end;

procedure GenerarReporte();
var
    ventas: archivo_ventas;
    arch_reporte: archivo_reporte;
    venta: tipo_maestro;
    reporte: tipo_reporte;
    anio_actual: integer;
    mes_actual: integer;
    total_anual: double;
    total_mensual: double;
begin
    Assign(ventas, 'maestro.dat');
    Reset(ventas);
    Assign(arch_reporte, 'reporte.dat');
    Rewrite(arch_reporte);

    LeerVenta(ventas, venta);
    while (venta.cliente.codigo <> FIN_ARCHIVO) do begin
        reporte.cliente := venta.cliente;
        total_anual := 0;
        anio_actual := venta.fecha.anio;
        while (venta.cliente.codigo <> FIN_ARCHIVO) and (venta.fecha.anio = anio_actual) do begin
            total_mensual := 0;
            mes_actual := venta.fecha.mes;
            while (venta.cliente.codigo <> FIN_ARCHIVO) and (venta.fecha.anio = anio_actual) and (venta.fecha.mes = mes_actual) do begin
                total_mensual := total_mensual + venta.monto;

                LeerVenta(ventas, venta);
            end;

            reporte.total.mensual[mes_actual] := total_mensual;
            total_anual := total_anual + total_mensual;
        end;

        reporte.total.anual := total_anual;

        Write(arch_reporte, reporte);
    end;
end;

begin

end.