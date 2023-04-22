// 5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
// toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
// información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
// en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
// reuniendo dicha información.
// Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
// nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
// del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
// padre.
// En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
// apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
// lugar.
// Realizar un programa que cree el archivo maestro a partir de toda la información de los
// archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
// apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
// apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
// además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
// deberá, además, listar en un archivo de texto la información recolectada de cada persona

program ejercicio5;
// uses sysutils;
const 
    CANTIDAD_DELEGACIONES = 50;
    FIN_ARCHIVO = 32767;
type
    delegaciones_rango = 1 .. CANTIDAD_DELEGACIONES;
    tipo_nombre = record
        nombre: string;
        apellido: string;
    end;
    
    tipo_persona = record
        datos: tipo_nombre;
        dni: integer;
    end;
    
    tipo_familiar = record
        madre: tipo_persona;
        padre: tipo_persona;
    end;

    tipo_direccion = record
        calle: string;
        numero: integer;
        piso: integer;
        depto: char;
        ciudad: string;
    end;
    
    tipo_deceso = record
        matricula: integer;
        fecha: string;
        hora: integer;
        lugar: string;
    end;

    tipo_nacimiento = record
        partida: integer;
        datos: tipo_nombre;
        matricula: integer;
        direccion: tipo_direccion;
        familiares: tipo_familiar;
    end; 

    tipo_fallecimiento = record
        partida_nacimiento: integer;
        fallecido: tipo_persona;
        deceso: tipo_deceso;
    end;

    tipo_maestro = record
        partida_nacimiento: integer;
        matricula: integer;
        datos: tipo_nombre;
        direccion: tipo_direccion;
        familiares: tipo_familiar;
        deceso: tipo_deceso;
    end;

    nacimientos_delegacion = file of tipo_nacimiento;
    fallecimientos_delegacion =  file of tipo_fallecimiento;

    archivos_nacimientos = Array[1..CANTIDAD_DELEGACIONES] of nacimientos_delegacion;
    archivos_fallecimientos = Array[1..CANTIDAD_DELEGACIONES] of fallecimientos_delegacion;

    archivo_maestro = file of tipo_maestro;

procedure LeerNacimiento(var a: nacimientos_delegacion; var n: tipo_nacimiento);
begin
    if (not EOF(a)) then
        Read(a, n)
    else
        n.partida := FIN_ARCHIVO;    
end;

procedure LeerFallecimiento(var a: fallecimientos_delegacion; var f: tipo_fallecimiento);
begin
    if (not EOF(a)) then
        Read(a, f)
    else
        f.partida_nacimiento := FIN_ARCHIVO;
end;

procedure IniciarDetalles(var nacimientos: archivos_nacimientos; var fallecimientos: archivos_fallecimientos);
var 
    i: integer;
    numero_delegacion: string;
begin
    for i := 1 to CANTIDAD_DELEGACIONES do begin
        numero_delegacion := IntToStr(i);
        Assign(nacimientos[i], 'var/sucursal-' + numero_delegacion + '/detalle-nacimientos.dat');
        Assign(fallecimientos[i], 'var/sucursal-' + numero_delegacion + '/detalle-fallecimientos.dat');
        Reset(nacimientos[i]);
        Reset(fallecimientos[i]);
    end;

end;

procedure AgregarNacimiento(var maestro: tipo_maestro; var nacimiento: tipo_nacimiento);
begin
    maestro.partida_nacimiento := nacimiento.partida;
    maestro.matricula := nacimiento.matricula;   
    maestro.datos := nacimiento.datos;
    maestro.direccion := nacimiento.direccion;
    maestro.familiares := nacimiento.familiares;
end;

procedure BuscarFallecido(var fallecidos: archivos_fallecimientos; buscado: integer; var fallecido: tipo_fallecimiento; var fallecio: boolean );
var 
    j: integer;
    fallecido_procesado: tipo_fallecimiento;
begin
    j := 1;
    LeerFallecimiento(fallecidos[j], fallecido_procesado);
    while (j < CANTIDAD_DELEGACIONES) and (buscado <> fallecido_procesado.partida_nacimiento) and (fallecido_procesado.partida_nacimiento <> FIN_ARCHIVO) do begin
        while (buscado <> fallecido_procesado.partida_nacimiento) and (fallecido_procesado.partida_nacimiento <> FIN_ARCHIVO) do
            LeerFallecimiento(fallecidos[j], fallecido_procesado);
        if not fallecido.partida_nacimiento = FIN_ARCHIVO then begin
            fallecio := true;
            fallecido := fallecido_procesado;
        end
        else
            fallecio := false;
        j := j + 1;
    end;   
end;
procedure CrearMaestro();
var
    nacimientos: archivos_nacimientos;
    fallecimientos: archivos_fallecimientos;
    nacimiento: tipo_nacimiento;
    fallecimiento: tipo_fallecimiento;
    fallecio: boolean;
    maestro: tipo_maestro;
    i: delegaciones_rango;
    j: integer;
    nuevo_archivo: archivo_maestro;
begin
    Assign(nuevo_archivo, '/var/maestro.dat');
    Rewrite(nuevo_archivo);
    
    IniciarDetalles(nacimientos, fallecimientos);

    for i := 1 to CANTIDAD_DELEGACIONES do begin
        LeerNacimiento(nacimientos[i], nacimiento);
        while (nacimiento.partida <> FIN_ARCHIVO) do begin
            AgregarNacimiento(maestro, nacimiento);
            BuscarFallecido(fallecimientos,nacimiento.partida, fallecimiento, fallecio);
            if (fallecio) then
                maestro.deceso := fallecimiento.deceso
            else
                maestro.deceso := nil;
            LeerNacimiento(nacimientos[i], nacimiento);
        end;
    end;
end;

procedure ExportarMaestro();
var
    nuevo_archivo: Text;
    maestro: archivo_maestro;
    registro: tipo_maestro;
begin
    Assign(nuevo_archivo, 'maestro-exportado.txt');
    Assign(maestro, 'maestro.dat');
    Reset(maestro);
    Rewrite(nuevo_archivo);

    LeerMaestro(maestro, registro);
    while (maestro.partida <> FIN_ARCHIVO) do begin
        with registro do begin
            Writeln(nuevo_archivo, partida_nacimiento, matricula);
            Writeln(nuevo_archivo, datos.nombre, datos.apellido);
            Writeln(nuevo_archivo, direccion.calle, direccion.piso, direccion.depto, direccion.ciudad);
            Writeln(nuevo_archivo, familiares.madre.nombre, familiares.madre.apellido);
            Writeln(nuevo_archivo, familiares.padre.nombre, familiares.padre.apellido);
            Writeln(nuevo_archivo, deceso.fecha, deceso.hora, deceso.matricula);

        end;
    end;
end;

var
    opcion: char;
begin
    Writeln('############### Opciones ###############');
    Writeln('----------------------------------------');
    Writeln('Opcion A: Crear archivo maestro');
    Writeln('Opcion B: Exportar archivo maestro ');
    Writeln('----------------------------------------');
    Write('Ingrese una opción: ');
    Readln(opcion);

    // case opcion of 
    //     'A', 'a': CrearMaestro();
    //     'B', 'b': ExportarMaestro();
    // end;    
end.