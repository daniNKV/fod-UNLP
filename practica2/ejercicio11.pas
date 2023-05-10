//  A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
// archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
// alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
// agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
// localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
// necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
// NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
// pueden venir 0, 1 ó más registros por cada provincia.

program ejercicio11;
const
	CANTIDAD_DETALLES = 2;
	FIN_ARCHIVO = 32767;
type
	tipo_maestro = record
		nombre_provincia: string;
		cantidad_alfabetizados: integer;
		total_encuestados: integer;
	end;

	tipo_detalle = record
		nombre_provincia: string;
		codigo_localidad: integer;
		cantidad_alfabetizados:integer;
		cantidad_encuestados: integer;
	end;

	archivo_maestro = file of tipo_maestro;
	archivo_detalle = file of tipo_detalle;

	tipo_detalles = Array[1 .. CANTIDAD_DETALLES] of archivo_detalle;

procedure AbrirDetalles(var detalles: tipo_detalle);
var 
	i: integer;
	i_s: string;
begin
  for i := 1 to CANTIDAD_DETALLES do begin
		i_s := IntToStr(i);
    Assign(detalles[i], 'detalle-' + i_s + '.dat');
		Reset(detalles[i]);
  end;
end;

procedure LeerDetalle(var a: archivo_detalle; var d: tipo_detalle);
begin
	if (not EOF(a)) then
		Read(a, d)
	else
		d.codigo_localidad := FIN_ARCHIVO;
end;


procedure EncontrarLocalidadMinima(var detalles: tipo_detalles; var detalle_minimo: tipo_detalle);
var
	i: integer;
	codigo_minimo: integer;
	detalle: tipo_detalle;
begin
	codigo_minimo := FIN_ARCHIVO;
	for i := 1 to CANTIDAD_DETALLES do begin
		LeerDetalle(detalles[i], detalle);
		if (detalle.codigo_localidad < codigo_minimo) then begin
			codigo_minimo := detalle.codigo_localidad;
			detalle_minimo := detalle;
		end
		else 
			Seek(detalles[i], FilePos(detalles[i]) - 1);
	end;
end;

procedure MergeDetalles(var detalles: tipo_detalle; var archivo: tipo_detalle);
var
	detalle: tipo_detalle;
	detalle_salida: tipo_detalle
begin
	AbrirDetalles(detalles);

	EncontrarLocalidadMinima(detalles, detalle);

	while (detalle.codigo_localidad <> FIN_ARCHIVO) do begin
	  	detalle_salida.codigo_localidad := detalle.codigo_localidad;
		detalle_salida.cantidad_alfabetizados := 0;
		detalle_salida.cantidad_encuestados := 0;
		while (detalle_salida.codigo_localidad = detalle.codigo_localidad) and (detalle.codigo_localidad <> FIN_ARCHIVO) do begin
			detalle_salida.cantidad_alfabetizados := detalle_salida.cantidad_alfabetizados + detalle.cantidad_alfabetizados;
			detalle_salida.cantidad_encuestados := detalle_salida.cantidad_encuestados + detalle.cantidad_encuestados;
			EncontrarLocalidadMinima(detalles, detalle);
	  	end;

		

	end;





end;

begin
  
 
end.