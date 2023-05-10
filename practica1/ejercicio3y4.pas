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
const 
	FIN_ARCHIVO = 32767;

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


// Si abro un archivo acá con reset, y despues llamo a la funcion, ¿lo tengo que abrir de nuevo?
// ¿La idea es agregarlos con la metodolodía maestro-detalle?


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

function buscarIndiceEmpleado(var archivo: archivo_empleados; codigoBuscado: integer): Integer;
var 
	emp: empleado;

begin
	seek(archivo, 0);
	writeln(filePos(archivo));
	read(archivo, emp);
	while ((emp.codigo <> codigoBuscado) and not EOF(archivo)) do begin
		writeln(filePos(archivo));
		read(archivo, emp);
	end;

	if (emp.codigo = codigoBuscado) then
		buscarIndiceEmpleado := filePos(archivo) - 1
	else 
		buscarIndiceEmpleado := -1;
end;


procedure modificarEdades();
var
	nombreArchivo: string;
	emp: empleado;
	archivo: archivo_empleados;
	codigoBuscado: integer;
	nuevaEdad: SmallInt;
	indice: integer;

begin
	writeln('¿Cómo es el nombre del archivo?');
	readln(nombreArchivo);
	assign(archivo, nombreArchivo);
	reset(archivo);

	writeln('Ingrese el código del empleado buscado o -1 para terminar');
	readln(codigoBuscado);

	while(codigoBuscado <> -1) do begin
		indice := buscarIndiceEmpleado(archivo, codigoBuscado);

		seek(archivo, indice);
		read(archivo, emp);
		seek(archivo, indice);

		write('Ingrese nueva edad: ');
		read(nuevaEdad);

		emp.edad := nuevaEdad;

		write(archivo, emp);

		writeln('Ingrese el código del empleado buscado o -1 para terminar');
		readln(codigoBuscado);

	end;	

	close(archivo);

end;

procedure exportarTodo();
var
	emp: empleado;
	archivo: archivo_empleados;
	nuevoArchivo: archivo_empleados;
	nombreArchivo: string;
	nombreIngresado: string;
	nuevoNombre: string;
begin
	write('Ingrese nombre del archivo a exportar: ');
	readln(nombreArchivo);
	assign(archivo, nombreArchivo);
	reset(archivo);

	write('Ingrese nombre del nuevo archivo: ');
	readln(nombreIngresado);
	nuevoNombre := nombreIngresado + '.txt';
	assign(nuevoArchivo,  nuevoNombre);
	rewrite(nuevoArchivo);

	read(archivo, emp);
	while (not EOF(archivo)) do begin
		write(nuevoArchivo, emp);
		read(archivo, emp);
	end;

	close(archivo);
	close(nuevoArchivo);


end;

procedure exportarSinDNI();
var
	emp: empleado;
	archivo: archivo_empleados;
	nuevoArchivo: archivo_empleados;
	nombreArchivo: string;
begin
	write('Ingrese nombre del archivo a analizar y exportar: ');
	readln(nombreArchivo);
	assign(archivo, nombreArchivo);
	reset(archivo);

	assign(nuevoArchivo, 'faltaDNIEmpleado.txt');
	rewrite(nuevoArchivo);

	read(archivo, emp);

	while(not EOF(archivo)) do begin
		if (emp.DNI = '00') then
			write(nuevoArchivo, emp);

		read(archivo, emp);
	end;

	close(archivo);
	close(nuevoArchivo);
end;

procedure LeerEmpleadoDeArchivo(var a: archivo_empleados; var e: empleado);
begin
	if (not EOF(a)) then
		read(a, e)
	else
		e.codigo := FIN_ARCHIVO;
end;

procedure eliminarEmpleado();
var
	archivo: archivo_empleados;
	nombreArchivo: string;
	codigoBuscado: integer;
	ultimoEmpleado: empleado;
	indice: integer;
begin
	write('¿Cómo es el nombre del archivo?: ');
	readln(nombreArchivo);
	assign(archivo, nombreArchivo);
	reset(archivo);
	write('Ingrese código del empleado a eliminar:  ');
	readln(codigoBuscado);

	indice := buscarIndiceEmpleado(archivo, codigoBuscado);

	if indice <> -1 then begin
		seek(archivo, fileSize(archivo));
		LeerEmpleadoDeArchivo(archivo, ultimoEmpleado);
		seek(archivo, indice);
		write(archivo, ultimoEmpleado);
		seek(archivo, fileSize(archivo));
		write(EOF);
	end;

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
	writeln('E: Añadir empleado/s');
	writeln('F: Modificar edad a uno o más empleados');
	writeln('G: Exportar en .txt');
	writeln('H: Exportar empleados con DNI faltante en .txt');
	writeln('I: Eliminar empleado');
	
	readln(opcion);

	case opcion of 
		'A', 'a': crearArchivo(archivo, nombreArchivo);
		'B', 'b': buscarEmpleado();
		'C', 'c': listarEmpleados();
		'D', 'd': listarEmpleadosMayores();
		'E', 'e': agregarEmpleados();
		'F', 'f': modificarEdades();
		'G', 'g': exportarTodo();
		'H', 'h': exportarSinDNI();
		'I', 'i': eliminarEmpleado();
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