// Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
// provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
// provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
// Presentar en pantalla un listado como se muestra a continuación

program ejercicio9;
const FIN_ARCHIVO = 32767;
ANCHO_COLUMNA = 30;
type
    tipo_mesa = record
        codigo_provincia: integer;
        codigo_localidad: integer;
        numero_mesa: integer;
        cantidad_votos: integer;
    end;

    archivo_electoral = file of tipo_mesa;

procedure LeerMesa(var a: archivo_electoral; var m: tipo_mesa);
begin
    if (not EOF(a)) then
        Read(a, m)
    else
        m.codigo_provincia := FIN_ARCHIVO;
end;

procedure Contabilizar();
var
    archivo: archivo_electoral;
    mesa_leida: tipo_mesa;
    total_localidad: integer;
    total_provincia: integer;
    total_general: integer;
    provincia_procesada: integer;
    localidad_procesada: integer;
begin
    Assign(archivo, 'mesas-electorales.dat');
    Reset(archivo);

    total_general := 0;
    LeerMesa(archivo, mesa_leida);
    while (mesa_leida.codigo_provincia <> FIN_ARCHIVO) do begin
        total_provincia := 0;
        provincia_procesada := mesa_leida.codigo_provincia;

        Write('Código de Provincia: ');
        Writeln(provincia_procesada);
        Writeln('Código de Localidad':ANCHO_COLUMNA, 'Total de Votos':ANCHO_COLUMNA);

        while (mesa_leida.codigo_provincia <> FIN_ARCHIVO) and (mesa_leida.codigo_provincia = provincia_procesada) do begin
            total_localidad := 0;
            localidad_procesada := mesa_leida.codigo_localidad;

            while (mesa_leida.codigo_provincia <> FIN_ARCHIVO) and (mesa_leida.codigo_provincia = provincia_procesada) and (mesa_leida.codigo_localidad = localidad_procesada) do begin

                total_localidad := total_localidad + mesa_leida.cantidad_votos;

                LeerMesa(archivo, mesa_leida);
            end;

            Write(localidad_procesada:ANCHO_COLUMNA, total_localidad:ANCHO_COLUMNA);
        
            total_provincia := total_provincia + total_localidad;
        end;

        Write('Total de Votos Provincia: ');
        Writeln(total_provincia);
        
        total_general := total_general + total_provincia;
    end;

    Writeln('------------------------------------------------------------------------');
    Write('Total General de Votos: ');
    Writeln(total_general);

    Close(archivo);
end;

begin


end.
