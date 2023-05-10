// 2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
// información de asistentes a un congreso a partir de la información obtenida por
// teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
// nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
// archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
// asistente inferior a 1000.
// Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
// String a su elección. Ejemplo: ‘@Saldaño

program ejercicio2;
const
    FIN_ARCHIVO = 32727;
    MARCA_ELIMINADO = '@';
type
    tipo_asistente = record
        nro: integer;
        apellido: string;
        nombre: string;
        email: string;
        telefono: string;
        dni: string;
    end;

    archivo_asistentes = file of tipo_asistente;

procedure LeerAsistente(var a: tipo_asistente);
begin
    write('Ingrese número de asistente: ');
    readln(a.nro);

    if (a.nro <> -1) then begin
        write('Ingrese apellido: ');
        readln(a.apellido);
        write('Ingrese nombre: ');
        readln(a.nombre);
        write('Ingrese email: ');
        readln(a.email);
        write('Ingrese telefono: ');
        readln(a.telefono);
        write('Ingrese dni: ');
        readln(a.dni);
    end;
end;

procedure GenerarArchivo(var archivo: archivo_asistentes);
var
    asistente: tipo_asistente;
begin
    reset(archivo);

    LeerAsistente(asistente);

    while (asistente.nro <> -1) do begin
        write(archivo, asistente);
        LeerAsistente(asistente);
    end;

    close(archivo);

end;

procedure LeerAsistenteDeArchivo(var a: archivo_asistentes; var asis: tipo_asistente);
begin
    if (not EOF(a)) then
        read(a, asis)
    else
        asis.nro := FIN_ARCHIVO;
end;

procedure EliminarMenoresA(var archivo: archivo_asistentes; numero: integer);
var 
    asistente: tipo_asistente;
    marca: string;
begin
    reset(archivo);

    LeerAsistenteDeArchivo(archivo, asistente);

    while (asistente.nro <> FIN_ARCHIVO) do begin
        if (asistente.nro < numero) then begin
            marca := MARCA_ELIMINADO + asistente.apellido;
            asistente.apellido := marca;
            seek(archivo, FilePos(archivo) - 1);
            write(archivo, asistente);
        end;

        LeerAsistenteDeArchivo(archivo, asistente);
    end;

    close(archivo);
end;

procedure ImprimirAsistente(a: tipo_asistente);
begin
    Writeln('################################');
    Write('Numero: ':-10); Writeln(a.nro);
    Write('Apellido: ':-10); Writeln(a.apellido);
    Write('Nombre: ':-10); Writeln(a.nombre);
    Write('Email: ':-10); Writeln(a.email);
    Write('Telefono: ':-10); Writeln(a.telefono);
    Write('DNI: ':-10); Writeln(a.dni);
end;

procedure ListarAsistentes(var a: archivo_asistentes);
var
    asistente: tipo_asistente;
begin
    reset(a);

    LeerAsistenteDeArchivo(a, asistente);

    while (asistente.nro <> FIN_ARCHIVO) do begin
        ImprimirAsistente(asistente);
        LeerAsistenteDeArchivo(a, asistente);
    end;

    close(a);


end;

var 
    archivo: archivo_asistentes;
    nombre_archivo: string;
    numero: integer;
begin
    numero := 1000;

    Write('Ingrese nombre de archivo a crearse: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    rewrite(archivo);
    
    GenerarArchivo(archivo);
    EliminarMenoresA(archivo, numero);
    ListarAsistentes(archivo);
end.

