// Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
// incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
// archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
// se ingrese el número 30000, que no debe incorporarse al archivo
program ejercicio1y2;
type
    archivo_numeros = file of integer;
    archivo_nombre = string[12];


procedure CrearArchivoNumerosDesordenados();
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
        read(num)
    end;

    close(archivo);

end;


procedure recorrerArchivo();
var
    num: integer;
    menores1500: integer;
    total: integer;
    cantidad: integer;
    promedio: double;
    nombre: archivo_nombre;

begin
    total := 0;
    cantidad := 0;
    menores1500 := 0;

    write('Como se llama el archivo a analizar?');
    read(nombre);

    reset(nombre);

    while not eof(nombre) do begin
        read(nombre, num);
        total := total + num;
        cantidad := cantidad + 1;

        if (num < 1500) then
            menores1500 := menores1500 + 1;

        write(num);
    end;

    close(nombre);
    
    promedio := total / cantidad;


    Write('La cantidad de números menores a 1500 es: ');
    Write(menores1500);
    writeln();
    Write('El promedio de números ingresados es: ');
    write(promedio);

end;

begin
  CrearArchivoNumerosDesordenados();
  
end.