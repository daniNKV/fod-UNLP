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
const CANTIDAD_DELEGACIONES = 50;
type
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

    archivos_nacimientos = Array[1..CANTIDAD_DELEGACIONES] of tipo_nacimiento;
    archivos_fallecimientos = Array[1..CANTIDAD_DELEGACIONES] of tipo_fallecimiento;

    archivo_maestro = file of tipo_maestro;

// procedure LeerNacimiento()

// procedure CrearMaestro();
// var

// begin

// end;

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