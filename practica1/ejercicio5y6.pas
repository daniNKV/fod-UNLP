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
type
    texto_corto = string[20];
    texto_largo = string[100];
    
    celular = record
        codigo: integer;
        nombre: texto_corto;
        marca: texto_corto;
        descripcion: texto_largo;
        precio: Double;
        stock_minimo: integer;
        stock_disponible: integer;
    end;

    archivo_celulares = file of celular;


var
    opcion_elegida: char;

    
begin
    writeln('-----------------------------------');
    writeln('############ CELULARES ############');
    writeln('-----------------------------------');
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
        'A', 'a': crearArchivo();
        'B', 'b': listarBajoStock();
        'C', 'c': buscarPorDescripcion();
        'D', 'd': exportarTodo();
        'E', 'e': agregarCelulares();
        'F', 'f': modificarStock();
        'G', 'g': exportarSinStock(); 
    end;

end.