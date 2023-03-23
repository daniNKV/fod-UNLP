// Realizar un programa que presente un menú con opciones para:
// a. Crear un archivo de registros no ordenados de empleados y completarlo con
// datos ingresados desde teclado. De cada empleado se registra: número de
// empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
// DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
// b. Abrir el archivo anteriormente generado y
// i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
// determinado.
// ii. Listar en pantalla los empleados de a uno por línea.
// iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
// NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.

program ejercicio3;

type
    tipoNombre = string[40];

    empleado = record 
        codigo: integer;
        apellido: tipoNombre;
        nombre: tipoNombre;
        edad: smallInt;
        DNI: string[10];
    end;

    archivo_empleados = file of empleado;

procedure leerEmpleado(var e: empleado);
begin
    writeln('Ingrese apellido: ');
    readln(e.apellido);
    if (e.apellido <> 'fin') then begin
        writeln('Ingrese nombre:');
        readln(e.nombre);
        writeln('Ingrese codigo: ');
        readln(e.codigo);
        writeln('Ingrese edad: ');
        readln(e.edad);
        writeln('Ingrese DNI: ');
        readln(e.DNI);
    end;
end;

procedure crearArchivo(var archivo: archivo_empleados; var nombreArchivo: string);
var emp: empleado;
begin
    writeln('Ingrese nombre del archivo a crearse: ');
    readln(nombreArchivo);
    assign(archivo, nombreArchivo);
    rewrite(archivo);

    leerEmpleado(emp);
    while(emp.apellido <> 'fin') do begin
        write(archivo, emp);
        leerEmpleado(emp);
    end;

    close(archivo);

end;

procedure imprimirEmpleado(emp: empleado; var empleadoString: string);
begin
    writeln ('Nombre: ', emp.nombre, ', Apellido: ', emp.apellido, ', Codigo: ', emp.codigo, ' DNI: ', emp.DNI, ' Edad: ', emp.edad);
end;

procedure buscarEmpleado();
var 
    archivo: archivo_empleados;
    nombreArchivo: string;
    cadena: tipoNombre;
    stringEmpleado: string;
    empleadoActual: empleado;
    encontrado: boolean;
    acc: integer;

begin
    acc := 0;

    writeln('¿Cómo se llama el archivo?');
    readln(nombreArchivo);
    assign(archivo, nombreArchivo);

    reset(archivo);

    writeln('Ingrese el nombre o apellido a buscar: ');
    readln(cadena);

    while (not EOF(archivo)) do begin
        read(archivo, empleadoActual);
        encontrado := ((empleadoActual.nombre = cadena) or (empleadoActual.apellido = cadena));

        if (encontrado) then
            acc := acc + 1;
            imprimirEmpleado(empleadoActual, stringEmpleado);
    end;

    if (acc = 0) then
        writeln('No existen usuarios con ', cadena, ' de nombre o apellido');


    close(archivo);
end;

procedure listarEmpleados();
var 
    archivo: archivo_empleados;
    nombreArchivo: string;
    emp: empleado;
    texto: string;

begin
    writeln('¿Cómo se llama el archivo?');
    readln(nombreArchivo);
    assign(archivo, nombreArchivo);
    reset(archivo);

    while (not EOF(archivo)) do begin
        read(archivo, emp);
        imprimirEmpleado(emp, texto);
    end;

    close(archivo);
end;

procedure listarEmpleadosMayores();
var
    archivo: archivo_empleados;
    nombreArchivo: string;
    emp: empleado;
    texto: string;
    acc: integer;

begin
    acc := 0;

    writeln('¿Cómo se llama el archivo?');
    readln(nombreArchivo);

    assign(archivo, nombreArchivo);
    reset(archivo);

    while (not EOF(archivo)) do begin
        read(archivo, emp);

        if(emp.edad > 70) then
            acc := acc + 1;
            imprimirEmpleado(emp, texto);
    end;

    if (acc = 0) then
        writeln('No existen usuarios mayores a 70 años');

    close(archivo);
end;


var
    archivo: archivo_empleados;
    nombreArchivo: string;
    opcion: char;

begin
    writeln('Ingrese una opcion');
    writeln('A: Crear y completar archivo de empleados');
    writeln('B: Buscar empleado por nombre o apellido');
    writeln('C: Listar todos los empleados');
    writeln('D: Listar empleados mayores a 70 años');
    
    readln(opcion);

    case opcion of 
        'A', 'a': crearArchivo(archivo, nombreArchivo);
        'B', 'b': buscarEmpleado();
        'C', 'c': listarEmpleados();
        'D', 'd': listarEmpleadosMayores();
    end;

end.