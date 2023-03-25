// 5)
//  Realizar un programa para una tienda de celulares, que presente un menú con
// opciones para:
//      a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
// ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
// correspondientes a los celulares, deben contener: código de celular, el nombre,
// descripción, marca, precio, stock mínimo y el stock disponible.
//      b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
// stock mínimo.
//      c. Listar en pantalla los celulares del archivo cuya descripción contenga una
// cadena de caracteres proporcionada por el usuario.
//      d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
// “celulares.txt”con todos los celulares del mismo. El archivo de texto generado
// podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
// debería respetar el formato dado para este tipo de archivos en la NOTA 2.

// NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
// NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
// tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
// marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
// nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
// “celulares.txt”.

// 6)
//  Agregar al menú del programa del ejercicio 5, opciones para:
//      a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
//       teclado.
//      b. Modificar el stock de un celular dado.
//      c. Exportar el contenido del archivo binario a un archivo de texto denominado:
//      ”SinStock.txt”,con aquellos celulares que tengan stock 0.

// NOTA: Las búsquedas deben realizarse por nombre de celular

program ejercicio5y6;
const fin_archivo = -1;
type
    texto_corto = string[20];
    texto_largo = string[100];
    
    tipo_celular = record
        codigo: integer;
        nombre: texto_corto;
        marca: texto_corto;
        descripcion: texto_largo;
        precio: Double;
        stock_minimo: integer;
        stock_disponible: integer;
    end;

    archivo_celulares = file of tipo_celular;

procedure pedirCelular(var c: tipo_celular);
begin
	writeln('Ingrese codigo (-1 para terminar): ');
	readln(c.codigo);
	if (c.codigo <> -1) then begin
		writeln('Ingrese nombre:');
		readln(c.nombre);
		writeln('Ingrese marca: ');
		readln(c.marca);
		writeln('Ingrese descripcion: ');
		readln(c.descripcion);
		writeln('Ingrese precio: ');
		readln(c.precio);
		writeln('Ingrese stock minimo: ');
		readln(c.stock_minimo);
		writeln('Ingrese stock disponible: ');
		readln(c.stock_disponible);
	end;
end;


procedure leerCelular(var archivo: archivo_celulares; var celular: tipo_celular);
begin
    if (not EOF(archivo)) then
        read(archivo, celular)
    else
        celular.codigo := fin_archivo;
end;

procedure imprimirCelular(celular: tipo_celular);
begin
    with celular do begin
        writeln('---------------------------------------------------------------------------------');
        writeln('Codigo: ', codigo, ', Modelo: ', nombre, ', Precio:  ', precio );
        writeln('Stock Minimo: ', stock_minimo, ', Stock Disponible: ', stock_disponible, ', Descripcion: ', descripcion);
        writeln('Marca: ', marca);
        writeln('---------------------------------------------------------------------------------');
    end
end;


procedure crearArchivo();
var
    celular: tipo_celular;
    archivo: archivo_celulares;
    nombre_archivo: texto_corto;
begin   
    write('Ingrese nombre del nuevo archivo: ');
    readln(nombre_archivo);

    assign(archivo, nombre_archivo);
    rewrite(archivo);

    pedirCelular(celular);
    
    while(celular.codigo <> fin_archivo) do begin
        write(archivo, celular);
        pedirCelular(celular);
    end;
    
    close(archivo);
end;

// Como hago para separar cada campo presente en una de las 3 lineas del .txt?
procedure crearDesdeArchivo();
var
    nombre_fuente: texto_corto;
    fuente: archivo_celulares;
    
    nuevo_nombre: texto_corto;
    nuevo_archivo: archivo_celulares;

    celular_leido: tipo_celular;
    
begin
    nombre_fuente := 'celulares.txt';

    write('Ingrese nombre del nuevo archivo: ');
    readln(nuevo_nombre);

    assign(nuevo_archivo, nuevo_nombre + '.dat');
    assign(fuente, nombre_fuente);

    reset(fuente);
    rewrite(nuevo_archivo);

    leerCelular(fuente, celular_leido);
    
    while (celular_leido.codigo <> fin_archivo) do begin
        write(nuevo_archivo, celular_leido);
        leerCelular(fuente, celular_leido);
    end;

    close(fuente);
    close(nuevo_archivo);
end;

procedure listarBajoStock();
var
    celular: tipo_celular;
    nombre_archivo: string;
    archivo: archivo_celulares;
begin
    write('Ingrese el nombre del archivo: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    reset(archivo);

    leerCelular(archivo, celular);
    with celular do begin 
        while(codigo <> fin_archivo) do begin
            if (stock_disponible < stock_minimo) then
                imprimirCelular(celular);
        end;
    end;

    close(archivo);
end;

procedure buscarPorDescripcion();
var
    descripcion_buscada: texto_largo;
    archivo: archivo_celulares;
    celular: tipo_celular;
    nombre_archivo: texto_corto;
begin
    write('Ingrese nombre del archivo a analizar: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    reset(archivo);

    write('Ingrese cadena de texto a buscar: ');
    readln(descripcion_buscada);

    leerCelular(archivo, celular);
    with celular do begin
        while codigo <> -1 do begin
            if (descripcion = descripcion_buscada) then begin
                imprimirCelular(celular);
            end;

            leerCelular(archivo, celular)
        end;
    end;

    close(archivo);
end;

function buscarIndiceCelular(var archivo: archivo_celulares; codigo_buscado: integer): integer;
var
    celular: tipo_celular;
begin
    seek(archivo, 0);
    leerCelular(archivo, celular);

    with celular do begin
        while (codigo <> -1) and (codigo <> codigo_buscado) do
            leerCelular(archivo, celular);

        if (codigo = codigo_buscado) then
            buscarIndiceCelular := FilePos(archivo) - 1
        else 
            buscarIndiceCelular := -1;
    end;
end;

procedure agregarCelulares();
var
    archivo: archivo_celulares;
    nombre_archivo: texto_corto;
    celular: tipo_celular;
    indice_existente: integer;
begin
    write('Ingrese nombre del archivo: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    reset(archivo);

    pedirCelular(celular);

    with celular do begin
        while(codigo <> -1) do begin
            indice_existente := buscarIndiceCelular(archivo, codigo);
            if (indice_existente = -1) then
                write('El celular con código ', codigo,' ya se encuentra registrado, modifique el stock')
            else begin
                seek(archivo, fileSize(archivo));
                write(archivo, celular);
            end;

            pedirCelular(celular)
        end; 
    end;  

    close(archivo);

end;




procedure modificarStock();
var
    archivo: archivo_celulares;
    nombre_archivo: texto_corto;
    codigo_buscado: integer;
    celular: tipo_celular;
    nuevo_stock_minimo: integer;
    nuevo_stock: integer;

begin
    write('Ingrese nombre del archivo a modificar: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    reset(archivo);
    write('Ingrese codigo del celular a modificar: ');
    readln(codigo_buscado);


    with celular do begin
        leerCelular(archivo, celular);
        while (codigo <> fin_archivo) do begin
            if (codigo = codigo_buscado) then begin
                writeln('Ingrese nuevo stock minimo (-1 para mantener)');
                write('Nuevo valor: ');
                readln(nuevo_stock_minimo);
                writeln('Ingrese nuevo stock disponible (-1 para mantener)');
                write('Nuevo valor: ');
                readln(nuevo_stock);

                if (nuevo_stock_minimo <> -1) then
                    stock_minimo := nuevo_stock_minimo
                else if (stock_minimo <> -1) then
                    stock_disponible := nuevo_stock;
                
                seek(archivo, FilePos(archivo) - 1);

                write(archivo, celular);

            end;

            leerCelular(archivo, celular);

        end;
    end;

    close(archivo);
end;


var
    opcion_elegida: char;

    
begin
    writeln('-----------------------------------');
    writeln('############ CELULARES ############');
    writeln('-----------------------------------');
    writeln('Z: Crear Archivo');
    writeln('A: Crear archivo de celulares"');
    writeln('B: Listar productos con stock menor al mínimo');
    writeln('C: Buscar por descripción');
    writeln('D: Exportar en .txt');
    writeln('E: Añadir celulares');
    writeln('F: Modificar stock de un celular');
    writeln('G: Exportar productos sin stock');
    writeln('-----------------------------------');

    write('Ingrese una opción: ');
    readln(opcion_elegida);

    case opcion_elegida of 
        'Z', 'z': crearArchivo();
        'A', 'a': crearDesdeArchivo();
        'B', 'b': listarBajoStock();
        'C', 'c': buscarPorDescripcion();
        // 'D', 'd': exportarTodo(); // DUDA
        'E', 'e': agregarCelulares();
        'F', 'f': modificarStock();
        // 'G', 'g': exportarSinStock(); 
    end;

end.