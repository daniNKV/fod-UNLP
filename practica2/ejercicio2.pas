// Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
// cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
// (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
// un archivo detalle con el código de alumno e información correspondiente a una materia
// (esta información indica si aprobó la cursada o aprobó el final).
// Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
// haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
// programa con opciones para:
// a. Actualizar el archivo maestro de la siguiente manera:
// i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
// ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
// final.
// b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
// con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
// NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.

program ejercicio2;
const 
    FIN_ARCHIVO = 9999;
    CURSADA_APROBADA = 1;
    FINAL_APROBADO = 2;
type
    cadena_corta = string[20];

    tipo_alumno = record
        codigo: smallInt;
        apellido: cadena_corta;
        nombre: cadena_corta;
        cursadas: byte;
        finales: byte;
    end;

    tipo_detalle = record
        codigo: smallInt;
        aprobo: byte; // 0 desaprobado, 1 cursada, 2 final
    end;

    archivo_alumnos = file of tipo_alumno;
    archivo_detalle = file of tipo_detalle;

procedure LeerAlumno(var a: archivo_alumnos; var al: tipo_alumno);
begin
    if (not EOF(a)) then
        read(a, al)
    else
        al.codigo := FIN_ARCHIVO;
end;

procedure LeerDetalleAlumno(var a: archivo_detalle; var al: tipo_detalle);
begin
    if (not EOF(a)) then
        read(a, al)
    else
        al.codigo := FIN_ARCHIVO;
end;

procedure Actualizar();
var
    detalle: archivo_detalle;
    maestro: archivo_alumnos;
    alumno: tipo_alumno;
    detalle_alumno: tipo_detalle;
begin

    assign(maestro, 'alumnos-maestro.dat'); // Se dispone
    assign(detalle, 'alumnos-detalle.dat'); // Se dispone

    reset(maestro);
    reset(detalle);

    LeerAlumno(maestro, alumno);

    while (alumno.codigo <> FIN_ARCHIVO) do begin
        LeerDetalleAlumno(detalle, detalle_alumno);
       
        while (detalle_alumno.codigo = alumno.codigo) and (detalle_alumno.codigo <> FIN_ARCHIVO) do begin
            if (detalle_alumno.aprobo = CURSADA_APROBADA) then
                alumno.cursadas := alumno.cursadas + 1
            else if (detalle_alumno.aprobo = FINAL_APROBADO) then
                alumno.finales := alumno.finales + 1;
        
            LeerDetalleAlumno(detalle, detalle_alumno);
        end;

        LeerAlumno(maestro, alumno);
    end;

    Close(maestro);
    Close(detalle);
end;

procedure ListarTextoCuatroSinFinal();
var
    archivo: archivo_alumnos;
    nuevo_txt: Text;
    alumno: tipo_alumno;

begin
    assign(archivo, 'alumnos.dat');
    assign(nuevo_txt, 'alumnosSinFinal.txt');

    reset(archivo);
    rewrite(nuevo_txt);

    LeerAlumno(archivo, alumno);
    while (alumno.codigo <> FIN_ARCHIVO) do begin
        with alumno do begin
            if (cursadas > 4) and (finales = 0) then
                Writeln(nuevo_txt, codigo, nombre, apellido, cursadas, finales);
        end;

        LeerAlumno(archivo, alumno);
    end;

    close(archivo);
    close(nuevo_txt);
    
end;

begin 
    write('hola');
end.