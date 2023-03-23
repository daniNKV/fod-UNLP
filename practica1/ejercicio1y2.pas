// Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
// incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
// archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
// se ingrese el número 30000, que no debe incorporarse al archivo

// 2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
// creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
// promedio de los números ingresados. El nombre del archivo a procesar debe ser
// proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
// contenido del archivo en pantalla.

program ejercicio1y2;
type
    archivo_numeros = file of integer;
    archivo_nombre = string[12];

procedure recorrerArchivo(var path: archivo_numeros);
var
    num: integer;
    menores1500: integer;
    total: integer;
    cantidad: integer;
    promedio: double;

begin
    total := 0;
    cantidad := 0;
    menores1500 := 0;

    reset(path);

    while not eof(path) do begin
        read(path, num);
        total := total + num;
        cantidad := cantidad + 1;

        if (num < 1500) then
            menores1500 := menores1500 + 1;

        writeln(num);
    end;

    close(path);
    
    promedio := total / cantidad;


    Write('La cantidad de números menores a 1500 es: ');
    Write(menores1500);
    writeln();
    Write('El promedio de números ingresados es: ');
    write(promedio);

end;

var
    archivo: archivo_numeros;
    num: integer;
    nombre: archivo_nombre;

begin
    write('Ingrese nombre del archivo a generarse: ');
    read(nombre);

    assign(archivo, nombre);
    rewrite(archivo);

    write('Ingrese un número: ');
    read(num);

    while num <> 3000 do begin
        write('Ingrese un número: ');
        write(archivo, num);
        read(num);
    end;

    close(archivo); 

    recorrerArchivo(archivo);
end.