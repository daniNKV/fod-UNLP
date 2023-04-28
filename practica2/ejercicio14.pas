// Una compañía aérea dispone de un archivo maestro donde guarda información sobre
// sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
// y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
// para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
// y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
// más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
// uno del maestro. Se pide realizar los módulos necesarios para:
// c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
// sin asiento disponible.
// d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
// tengan menos de una cantidad específica de asientos disponibles. La misma debe
// ser ingresada por teclado.
// NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez

program ejercicio14;
const 
    FIN_ARCHIVO = 32767;
    CANTIDAD_DETALLES = 2;
type
    tipo_vuelo = record
        destino: integer;
        fecha: integer;
        hora: integer;
        asientos: integer;
    end;

    tipo_detalle = record
        destino: string;
        fecha: string;
        hora: string;
        comprados: integer;
    end;

    archivo_vuelos = file of tipo_vuelo;
    tipo_detalles = array[1 .. CANTIDAD_DETALLES] of tipo_detalle;



procedure EncontrarPrimerVuelo(var detalles: tipo_detalles; var vuelo: tipo_detalle);
var i: integer;
leido: tipo_detalle;
begin
    vuelo.destino := FIN_ARCHIVO
    for i := 1 to CANTIDAD_DETALLES do begin
        LeerDetalle(detalles, leido);
        if 
end;
procedure Actualizar(var a: archivo_vuelos; var detalles: tipo_detalles);

begin

end;

var
    vuelos: archivo_vuelos;
    detalles: tipo_detalle;
    i_s: string;
begin
    Assign(vuelos, 'vuelos.dat');
    for i := 1 to CANTIDAD_DETALLES do begin
        i_s := IntToStr(i);
        Assign(detalles[i], 'detalle-' ,i_s , '.dat');
        Reset(detalles[i]);
    end;
end.