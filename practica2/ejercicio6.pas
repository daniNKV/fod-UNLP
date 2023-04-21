// 6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
// covid para el ministerio de salud de la provincia de buenos aires.
// Diariamente se reciben archivos provenientes de los distintos municipios, la información
// contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
// activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
// fallecidos.
// El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
// nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
// nuevos, cantidad recuperados y cantidad de fallecidos.
// Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
// recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
// localidad y código de cepa. 
// Para la actualización se debe proceder de la siguiente manera: 
// 1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
// 2. Idem anterior para los recuperados.
// 3. Los casos activos se actualizan con el valor recibido en el detalle.
// 4. Idem anterior para los casos nuevos hallados.
// Realice las declaraciones necesarias, el programa principal y los procedimientos que
// requiera para la actualización solicitada e informe cantidad de localidades con más de 50
// casos activos (las localidades pueden o no haber sido actualizadas).

program ejercicio6;
uses sysutils;
const
    FIN_ARCHIVO = 32767;
    CODIGO_MINIMO = 32767;
    CANTIDAD_MUNICIPIOS = 10;
type
    cadena_corta = string[40];
    tipo_casos = record
        activos, nuevos , recuperados, fallecidos: integer;
    end;
    tipo_cepa = record
        codigo: integer;
        nombre: cadena_corta;
    end;
    casos_municipio = record
        id_localidad: integer;
        id_cepa: integer;
        casos: tipo_casos;
    end;
    casos_pais = record
        id_localidad: integer;
        nombre_localidad: cadena_corta;
        cepa: tipo_cepa;
        casos: tipo_casos;
    end;
    
    archivo_maestro = file of casos_pais;
    archivo_detalle = file of casos_municipio;
    tipo_detalles = Array[1 .. CANTIDAD_MUNICIPIOS] of archivo_detalle;


procedure AbrirMaestro(var maestro: archivo_maestro);
begin
    Assign(maestro, 'maestro.dat');
    Reset(maestro);
end;

procedure AbrirDetalles(var detalles: tipo_detalles);
var
    i: integer;
    numero_municipio: string;
    archivo_municipio: cadena_corta;
begin
    for i := 1 to CANTIDAD_MUNICIPIOS do begin
        numero_municipio := IntToStr(i);
        archivo_municipio := 'detalle-' + numero_municipio + '.dat';
        Assign(detalles[i], archivo_municipio);
        Reset(detalles[i]);
    end;
end;

procedure CerrarDetalles(var detalles: tipo_detalles);
var i: integer;
begin
    for i := 1 to CANTIDAD_MUNICIPIOS do
        Close(detalles[i]);
end;

procedure LeerCasoMunicipio(var a: archivo_detalle; c: casos_municipio);
begin
    if (not EOF(a)) then
        Read(a, c)
    else
        c.id_localidad := FIN_ARCHIVO;
end;

procedure LeerCasoPais(var a: archivo_maestro; c: casos_pais);
begin
    if (not EOF(a)) then
        Read(a, c)
    else
        c.id_localidad := FIN_ARCHIVO;
end;

procedure BuscarLocalidadMinima(var detalles: tipo_detalles; var municipio: casos_municipio);
var
    leido: casos_municipio;
    i: integer;
begin
    municipio.id_localidad := CODIGO_MINIMO;
    municipio.id_cepa := CODIGO_MINIMO;
    for i := 1 to CANTIDAD_MUNICIPIOS do begin
        LeerCasoMunicipio(detalles[i], leido);

        if (leido.id_localidad <> FIN_ARCHIVO) then
            if (leido.id_localidad <= municipio.id_localidad) and (leido.id_cepa <= municipio.id_cepa) then
                municipio := leido;

    end;
end;

procedure BuscarDetalleEnMaestro(var archivo: archivo_maestro; var maestro: casos_pais; var detalle: casos_municipio);
begin
    LeerCasoPais(archivo, maestro);
    while (maestro.id_localidad <> FIN_ARCHIVO) and (maestro.id_localidad <> detalle.id_localidad) and (maestro.cepa.codigo <> detalle.id_cepa) do
        LeerCasoPais(archivo, maestro);

    Seek(archivo, FilePos(archivo) - 1);

end;

procedure ActualizarRegistro(var maestro: casos_pais; var detalle: casos_municipio);
begin
    with maestro do begin
        casos.fallecidos := casos.fallecidos + detalle.casos.fallecidos;
        casos.recuperados := casos.recuperados + detalle.casos.recuperados;
        casos.activos := detalle.casos.activos;
        casos.nuevos := detalle.casos.nuevos;
    end;
end;

procedure Actualizar();
var
    maestro: archivo_maestro;
    detalles: tipo_detalles;
    municipio: casos_municipio;
    pais: casos_pais;
begin
    AbrirMaestro(maestro);
    AbrirDetalles(detalles);
    BuscarLocalidadMinima(detalles, municipio);
    while (municipio.id_localidad <> FIN_ARCHIVO) do begin
        BuscarDetalleEnMaestro(maestro, pais, municipio);
        ActualizarRegistro(pais, municipio);
        BuscarLocalidadMinima(detalles, municipio);
    end;
    
    Close(maestro);
    CerrarDetalles(detalles);
end;

begin

end.