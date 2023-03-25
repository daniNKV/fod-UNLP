// Realizar un programa que permita:
// a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
// El nombre del archivo de texto es: “novelas.txt”
// b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
// una novela y modificar una existente. Las búsquedas se realizan por código de novela.
// NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
// género y precio de diferentes novelas argentinas. De cada novela se almacena la
// información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
// información: código novela, precio, y género, y la segunda línea almacenará el nombre
// de la novela

program ejercicio7;

type
    texto_corto = string[20];
    tipo_novela = record
        codigo: integer;
        precio: real;
        genero: texto_corto;
        nombre: texto_corto;
    end;

    archivo_novelas = file of tipo_novela;


procedure crearArchivo();
var
    archivo: archivo_novelas;
    entrada: Text;
    nombre_archivo: texto_corto;
    novela: tipo_novela;
begin
    write('Ingrese nombre del archivo a crearse: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo + '.dat');
    assign(entrada, 'novelas.txt');
    reset(entrada);
    rewrite(archivo);

    while (not EOF(entrada)) do begin
        with novela do begin
            readln(entrada, codigo, precio, genero);
            readln(entrada, nombre);

            write(archivo, novela);
        end;
    end;
    
    close(entrada);
    close(archivo);
end;

function buscarIndiceNovela(var archivo: archivo_novelas; codigo_buscado: integer): integer;
var
    novela: tipo_novela;
begin
    while (not EOF(archivo)) do begin
        read(archivo, novela);
        
        if (codigo_buscado = novela.codigo) then
            buscarIndiceNovela := FilePos(archivo)
        else
            buscarIndiceNovela := -1;
    end;
end;

procedure leerNovela(var n: tipo_novela);
begin
    write('Ingrese código de la novela: ');
    readln(n.codigo);
    write('Ingrese nombre de la novela: ');
    readln(n.nombre);
    write('Ingrese precio de la novela: ');
    readln(n.precio);
    write('Ingrese género de la novela: ');
    readln(n.genero); 
end;

procedure modificarArchivo();
var
    archivo: archivo_novelas;
    nombre_archivo: texto_corto;
    indice: integer;
    novela: tipo_novela;
begin
    write('Ingrese nombre del archivo a modificar: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    reset(archivo);

    leerNovela(novela);
    with novela do begin
        while (codigo <> -1) do begin
            indice := buscarIndiceNovela(archivo, codigo);

            if (indice = -1) then
                seek(archivo, FileSize(archivo))
            else 
                seek(archivo, indice);            

            write(archivo, novela);

            leerNovela(novela);
        end;
    end;
    
    close(archivo);
end;

var
    opcion: char;

begin
    writeln('######### NOVELAS #########');
    writeln('---------------------------');
    writeln('A: Crear archivo a partir de novelas.txt');
    writeln('B: Modificar archivo');
    writeln('---------------------------');
    write('Ingrese una opción ');
    readln(opcion);

    case opcion of 
        'a', 'A': crearArchivo();
        // 'b', 'B': modificarArchivo();
    end;
  
end.