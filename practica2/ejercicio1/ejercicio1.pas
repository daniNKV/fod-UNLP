// Una empresa posee un archivo con información de los ingresos percibidos por diferentes
// empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
// nombre y monto de la comisión. La información del archivo se encuentra ordenada por
// código de empleado y cada empleado puede aparecer más de una vez en el archivo de
// comisiones.
// Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
// consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
// única vez con el valor total de sus comisiones.
// NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
// recorrido una única vez

program ejercicio1;
const FIN_ARCHIVO = 9999;
type
    ingresos_empleados = record
        codigo: smallInt;
        nombre: string[12];
        monto: double;    
    end;
    archivo_empleados = file of ingresos_empleados;

procedure LeerIngreso(var ingreso: ingresos_empleados);
begin
    write('Ingrese codigo: ');
    readln(ingreso.codigo);
    if (ingreso.codigo <> -1) then begin
        write('Ingrese nombre: ');
        readln(ingreso.nombre);
        Write('Ingrese monto: ');
        readln(ingreso.monto);
    end;
end;

procedure LeerIngresos(var archivo: archivo_empleados);
var ingreso: ingresos_empleados;
begin
    LeerIngreso(ingreso);
    while (ingreso.codigo <> -1) do begin
        Write(archivo, ingreso);
		LeerIngreso(ingreso);
    end;
end;

procedure LeerEmpleado(var a: archivo_empleados; var e: ingresos_empleados);
begin
	if (not EOF(a)) then
		read(a, e)
	else 
		e.codigo := FIN_ARCHIVO;
end;

procedure CrearArchivo();
var
    nombre_archivo: string;
    archivo: archivo_empleados;
begin
    write('Ingrese nombre del archivo: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo + '.dat');
    rewrite(archivo);
	LeerIngresos(archivo);
	close(archivo);
end;
procedure Compactar();
var 
	nombre_archivo: string;
	empleado_leido: ingresos_empleados;
	nuevo_empleado: ingresos_empleados;
	archivo: archivo_empleados;
	nuevo_archivo: archivo_empleados;
begin
	Write('Ingrese nombre del archivo a compactar: ');
	Readln(nombre_archivo);

	assign(nuevo_archivo, nombre_archivo + '-compactado.dat');
	assign(archivo, nombre_archivo + '.dat');
	
	reset(archivo);
	rewrite(nuevo_archivo);

	LeerEmpleado(archivo, empleado_leido);

	while (empleado_leido.codigo <> FIN_ARCHIVO) do begin
		nuevo_empleado.codigo := empleado_leido.codigo;
		nuevo_empleado.nombre := empleado_leido.nombre;
		nuevo_empleado.monto := 0;
		while (nuevo_empleado.codigo = empleado_leido.codigo) do begin
			nuevo_empleado.monto := nuevo_empleado.monto + empleado_leido.monto;
			LeerEmpleado(archivo, empleado_leido);
		end;

		write(nuevo_archivo, nuevo_empleado);

	end;
	close(nuevo_archivo);
	close(archivo);

end;

procedure Imprimir();
var 
	archivo: archivo_empleados;
	empleado: ingresos_empleados;
begin
	assign(archivo, 'ventas-compactado.dat');
	reset(archivo);
	LeerEmpleado(archivo, empleado);
	while (empleado.codigo <> FIN_ARCHIVO) do begin
		Writeln('Cod: ' , empleado.codigo , ' Nom: ' , empleado.nombre , ' Monto: ' , empleado.monto:0:2);
		LeerEmpleado(archivo, empleado);
	end;

	close(archivo);
end;


var 
	opcion: char;
begin

	Writeln('#############################');
	WriteLn();
	WriteLn('A: Crear archivo');
	WriteLn('B: Compactar');
	WriteLn('C: Imprimir archivo');
	WriteLn();
	WriteLn('#############################');
	
	Write('Ingrese una opción: ');
	Readln(opcion);

	case opcion of
		'A', 'a': CrearArchivo();
		'B', 'b': Compactar();
		'C', 'c': Imprimir();
	end;

end.