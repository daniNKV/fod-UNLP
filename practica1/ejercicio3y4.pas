// 3) 
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

// 4)
// Agregar al menú del programa del ejercicio 3, opciones para:
// a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
// teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
// un número de empleado ya registrado (control de unicidad).
// b. Modificar edad a uno o más empleados.
// c. Exportar el contenido del archivo a un archivo de texto llamado
// “todos_empleados.txt”.
// d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
// que no tengan cargado el DNI (DNI en 00).
// NOTA: Las búsquedas deben realizarse por número de empleado

program ejercicio3y4;

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


function existeEmpleado(var archivo: archivo_empleados; codigo: integer): Boolean;
var
	emp: empleado;
begin
	seek(archivo, 0);

	read(archivo, emp);

	while((emp.codigo <> codigo) and not EOF(archivo)) do
		read(archivo, emp);

	if (emp.codigo = codigo) then
		existeEmpleado := true
	else
		existeEmpleado := false;

end;


procedure agregarEmpleados();
var
	archivo: archivo_empleados;
	nombreArchivo: string;
	emp: empleado;
	existe: boolean;

begin
	writeln('¿A qué archivo desea agregar empleado/s?');
	readln(nombreArchivo);
	
	assign(archivo, nombreArchivo);
	reset(archivo);
	
	writeln('Ingrese "fin" como apellido para dejar de agregar empleados');
	leerEmpleado(emp);

	while (emp.apellido <> 'fin') do begin
		existe := existeEmpleado(archivo, emp.codigo);

		if (existe) then 
			writeln('El empleado con código ', emp.codigo, ' ya existe, intente nuevamente')
		else begin
			seek(archivo, fileSize(archivo));
			write(archivo, emp);
			writeln('Agregado con éxito');
		end;

		leerEmpleado(emp);
	end;

	close(archivo);


end;

// Si abro un archivo acá con reset, y despues llamo a la funcion, ¿lo tengo que abrir de nuevo?
// ¿La idea es agregarlos con la metodolodía maestro-detalle?


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
	writeln('F: Añadir empleado');
	writeln('H: Modificar edad a uno o más empleados');
	writeln('I: Exportar en .txt');
	writeln('J: Exportar empleados con DNI faltante en .txt');
	
	readln(opcion);

	case opcion of 
		'A', 'a': crearArchivo(archivo, nombreArchivo);
		'B', 'b': buscarEmpleado();
		'C', 'c': listarEmpleados();
		'D', 'd': listarEmpleadosMayores();
		'F', 'f': agregarEmpleados();
		// 'G', 'g': modificarEdades();
		// 'H', 'h': exportarTodo();
		// 'I', 'i': exportarSinDNI();
	end;

end.
// a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
// teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
// un número de empleado ya registrado (control de unicidad).
// b. Modificar edad a uno o más empleados.
// c. Exportar el contenido del archivo a un archivo de texto llamado
// “todos_empleados.txt”.
// d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
// que no tengan cargado el DNI (DNI en 00).
// NOTA: Las búsquedas deben realizarse por número de empleado