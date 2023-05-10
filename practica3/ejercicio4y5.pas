// 4. Dada la siguiente estructura:
    // type
    // reg_flor = record
    // nombre: String[45];
    // codigo:integer;
    // tArchFlores = file of reg_flor;
// Las bajas se realizan apilando registros borrados y las altas reutilizando registros
// borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
// número 0 en el campo código implica que no hay registros borrados y -N indica que el
// próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
    // a. Implemente el siguiente módulo:
        // {Abre el archivo y agrega una flor, recibida como parámetro
        // manteniendo la política descripta anteriormente}
        // procedure agregarFlor (var a: tArchFlores ; nombre: string;
        // codigo:integer);
    // b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
    // considere necesario para obtener el listado

program ejercicio4y5;
const 
    FIN_ARCHIVO = 32767;
type
    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;
    tArchFlores = file of reg_flor;


procedure LeerFlorDeArchivo(var a: tArchFlores; var f: reg_flor);
begin
    if (not EOF(a)) then
        read(a, f)
    else
        f.codigo := FIN_ARCHIVO;
end;

{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente}
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
    cabecera: reg_flor;
    indice: integer;
    flor: reg_flor;
    florLeida: reg_flor;
begin
    reset(a);
    indice := 0;

    flor.codigo := codigo;
    flor.nombre := nombre;

    LeerFlorDeArchivo(a, cabecera);
    if (cabecera.codigo < 0) then begin
        indice := cabecera.codigo * (-1);
        seek(a, indice);
        LeerFlorDeArchivo(a, florLeida);
        cabecera.codigo := florLeida.codigo;
        seek(a, indice);
        write(a, flor);
        seek(a, 0);
        write(a, cabecera);
    end
    else begin
        seek(a, FileSize(a) - 1);
        write(a, flor);
    end;

    close(a);
end;

procedure ImprimirListado(var a: tArchFlores);
var
    flor: reg_flor;
begin
    reset(a);
    LeerFlorDeArchivo(a, flor);

    while (flor.codigo <> FIN_ARCHIVO) do begin
        if (flor.codigo > 0) then begin
            write('Codigo: ', flor.codigo); 
            write('Nombre: ', flor.nombre);
        end;

        LeerFlorDeArchivo(a, flor);
    end;
end;
var
    archivo: tArchFlores;
    cabecera: reg_flor;
begin
    assign(archivo, 'flores.dat');
    rewrite(archivo);
    cabecera.codigo := 0;
    Write(archivo, cabecera);

end.