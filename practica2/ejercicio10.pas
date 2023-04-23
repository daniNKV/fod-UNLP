// Se tiene información en un archivo de las horas extras realizadas por los empleados de
// una empresa en un mes. Para cada empleado se tiene la siguiente información:
// departamento, división, número de empleado, categoría y cantidad de horas extras
// realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
// departamento, luego por división, y por último, por número de empleados. Presentar en
// pantalla un listado con el siguiente formato

// Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
// iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
// de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
// de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
// posición del valor coincidente con el número de categoría

program ejercicio10;
const
	FIN_ARCHIVO = 32767;
	CANTIDAD_CATEGORIAS = 15;
type
	rango_categoria = 1 .. CANTIDAD_CATEGORIAS;
	tipo_empleado = record
		departamento: integer;
		division: integer;
		numero_empleado: integer;
		categoria: integer;
		horas_extras: integer;
	end;

	valor_categoria = array[rango_categoria] of double; 
	archivo_horas_extras = file of tipo_empleado;

procedure LeerValoresPorCategoria(var archivo_valores: Text; var valores: valor_categoria);
var
	categoria: rango_categoria;
	i: integer;
begin
	for i := 1 to CANTIDAD_CATEGORIAS do
		ReadLn(archivo_valores, categoria, valores[i]);
	Close(archivo_valores);
end;

procedure AbrirValores(var valores: Text);
begin
	Assign(valores, 'valores-por-categoria.txt');	
	Reset(valores);
end;

procedure AbrirEmpleados(var empleados: archivo_horas_extras);
begin
	Assign(empleados, 'empleados-horas-extras.dat');	
	Reset(empleados);
end;

procedure LeerEmpleado(var a: archivo_horas_extras; var e: tipo_empleado);
begin
	if (not EOF(a)) then
		Read(a, e)
	else
		e.departamento := FIN_ARCHIVO;
		e.division := FIN_ARCHIVO;
		e.numero_empleado := FIN_ARCHIVO;
end;

function CalcularHorasExtras(var empleado: tipo_empleado; var valores: valor_categoria): double;
begin
	CalcularHorasExtras := empleado.horas_extras * valores[empleado.horas_extras];
end;

procedure ImprimirHorasExtras(var archivo: archivo_horas_extras; var valores: valor_categoria);
var
	empleado: tipo_empleado;
	departamento: integer;
	division: integer;
	horas_division: integer;
	horas_departamento: integer;
	monto_division: double;
	monto_departamento: double;
	monto_empleado: double;

begin
	LeerEmpleado(archivo, empleado);
	while (empleado.departamento <> FIN_ARCHIVO) do begin
		horas_departamento := 0;
		monto_departamento := 0;
		departamento := empleado.departamento;
		Writeln('Departamento: ', departamento);
		while (empleado.departamento <> FIN_ARCHIVO) and (empleado.departamento = departamento) do begin
			horas_division := 0;
			monto_division := 0;
			division := empleado.division; 
			Writeln('División: ', division);
			Writeln('Número de Empleado':30 , 'Total de hs':20 , 'Importe a cobrar':20);
			while (empleado.division = division) and (empleado.departamento = departamento) and (empleado.departamento <> FIN_ARCHIVO) do begin
				monto_empleado := CalcularHorasExtras(empleado, valores);
				horas_division := horas_division + empleado.horas_extras;
				monto_division := monto_division + monto_empleado;
				Writeln(empleado.numero_empleado:30, empleado.horas_extras:20, monto_empleado);
				LeerEmpleado(archivo, empleado);
			end;

			horas_departamento := horas_departamento + horas_division;
			monto_departamento := monto_departamento + monto_division;

			Writeln('Total de horas por división: ', horas_division);
			Writeln('Monto total por division: ', monto_division);
		end;

		Writeln('Total de horas departamento: ', horas_departamento);
		Writeln('Monto total departamento ', monto_departamento);
	end;
end;


var 
	valor_por_categoria: valor_categoria;
	archivo_empleados: archivo_horas_extras;
	archivo_valores: Text; 
begin
	AbrirValores(archivo_valores);
	AbrirEmpleados(archivo_empleados);
	LeerValoresPorCategoria(archivo_valores, valor_por_categoria);
	ImprimirHorasExtras(archivo_empleados, valor_por_categoria);
end.
