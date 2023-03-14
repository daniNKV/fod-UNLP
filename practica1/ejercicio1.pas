// Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
// incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
// archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
// se ingrese el número 30000, que no debe incorporarse al archivo

program ejercicio1;

type
    archivo_numeros = file of integer;

var
    archivo: archivo_numeros;
    nombre: string[12];
    num: integer;

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

end.