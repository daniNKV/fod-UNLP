// 3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
// año. De cada novela se registra: código, género, nombre, duración, director y precio.
// El programa debe presentar un menú con las siguientes opciones:
    // a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
    // utiliza la técnica de lista invertida para recuperar espacio libre en el
    // archivo. Para ello, durante la creación del archivo, en el primer registro del
    // mismo se debe almacenar la cabecera de la lista. Es decir un registro
    // ficticio, inicializando con el valor cero (0) el campo correspondiente al
    // código de novela, el cual indica que no hay espacio libre dentro del
    // archivo.
    // b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
    // inciso a., se utiliza lista invertida para recuperación de espacio. En
    // particular, para el campo de  ́enlace ́ de la lista, se debe especificar los
    // números de registro referenciados con signo negativo, (utilice el código de
    // novela como enlace).Una vez abierto el archivo, brindar operaciones para:
        // i. Dar de alta una novela leyendo la información desde teclado. Para
        // esta operación, en caso de ser posible, deberá recuperarse el
        // espacio libre. Es decir, si en el campo correspondiente al código de
        // novela del registro cabecera hay un valor negativo, por ejemplo -5,
        // se debe leer el registro en la posición 5, copiarlo en la posición 0
        // (actualizar la lista de espacio libre) y grabar el nuevo registro en la
        // posición 5. Con el valor 0 (cero) en el registro cabecera se indica
        // que no hay espacio libre.
        // ii. Modificar los datos de una novela leyendo la información desde
        // teclado. El código de novela no puede ser modificado.
        // iii. Eliminar una novela cuyo código es ingresado por teclado. Por
        // ejemplo, si se da de baja un registro en la posición 8, en el campo
        // código de novela del registro cabecera deberá figurar -8, y en el
        // registro en la posición 8 debe copiarse el antiguo registro cabecera.
    // c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
    // representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
// NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
// proporcionado por el usuario

program ejercicio3;
const
    FIN_ARCHIVO = 32767;
type
    cadena = string[40];
    tipo_novela = record
        codigo: integer;
        genero: cadena;
        nombre: cadena;
        duracion: double;
        director: cadena;
        precio: double;
    end;
    archivo_novelas = file of tipo_novela;


procedure LeerNovelaDeTeclado(var n: tipo_novela);
begin
    Write('Ingrese codigo: ');
    readln(n.codigo);
    if (n.codigo <> -1) then begin
        Write('Ingrese genero: ');
        readln(n.genero);
        Write('Ingrese nombre: ');
        readln(n.nombre);
        Write('Ingrese duracion: ');
        readln(n.duracion);
        Write('Ingrese director: ');
        readln(n.director);
        Write('Ingrese precio: ');
        readln(n.precio);
    end;
end;

procedure ReleerNovelaDeTeclado(var n: tipo_novela; codigo: integer);
begin
    n.codigo := codigo;
    Writeln('Leyendo datos de novela con código: ', codigo);
    Write('Ingrese genero: ');
    readln(n.genero);
    Write('Ingrese nombre: ');
    readln(n.nombre);
    Write('Ingrese duracion: ');
    readln(n.duracion);
    Write('Ingrese director: ');
    readln(n.director);
    Write('Ingrese precio: ');
    readln(n.precio);
end;

procedure LeerNovelaDeArchivo(var a: archivo_novelas; var n: tipo_novela);
begin
    if (not EOF(a)) then
        read(a, n)
    else
        n.codigo := FIN_ARCHIVO;
end;

function buscarIndiceNovela(var archivo: archivo_novelas; codigoBuscado: integer): Integer;
var 
	novela: tipo_novela;

begin
    reset(archivo);
    LeerNovelaDeArchivo(archivo, novela);
	while (novela.codigo <> FIN_ARCHIVO) and (novela.codigo <> codigoBuscado) do
        LeerNovelaDeArchivo(archivo, novela);
	if (novela.codigo = codigoBuscado) then
		buscarIndiceNovela := filePos(archivo) - 1
	else 
		buscarIndiceNovela := -1;
    
    seek(archivo, 0);
end;

procedure CrearArchivo();
var
    archivo: archivo_novelas;
    nombre_archivo: string;
    cabecera: tipo_novela;
    novela: tipo_novela;
begin
    write('Ingrese nombre del archivo a crearse: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    rewrite(archivo);
    cabecera.codigo := 0;
    write(archivo, cabecera);

    LeerNovelaDeTeclado(novela);

    while (novela.codigo <> -1) do begin
        write(archivo, novela);
        LeerNovelaDeTeclado(novela);
    end;

    close(archivo);
end;



procedure DarAlta(var a: archivo_novelas);
var
    novelaIngresada: tipo_novela;
    novelaLeida: tipo_novela;
begin
    LeerNovelaDeTeclado(novelaIngresada);
    LeerNovelaDeArchivo(a, novelaLeida);
    if (novelaLeida.codigo < 0) and (novelaLeida.codigo <> FIN_ARCHIVO) then begin
        seek(a, Abs(novelaLeida.codigo));
        read(a, novelaLeida);
        seek(a, filePos(a) - 1);
        write(a, novelaIngresada);
        seek(a, 0);
        write(a, novelaLeida);
    end
    else begin
        seek(a, FileSize(a));
        write(a, novelaIngresada);
    end;
end;

procedure Modificar(var novelas: archivo_novelas);
var
    novelaModificada: tipo_novela;
    indice: integer;
    codigo: integer;
begin
    Write('Ingrese codigo de la novela a modificar: ');
    readln(codigo);
    indice := buscarIndiceNovela(novelas, codigo);
    if (indice < 0) then 
        writeln('No existe novela con el código ingresado')
    else begin
        ReleerNovelaDeTeclado(novelaModificada, codigo);
        seek(novelas, indice);
        write(novelas, novelaModificada);
    end;
end;

procedure ClonarRegistro(var r1: tipo_novela; var r2: tipo_novela);
begin
    r1.codigo := r2.codigo;
    r1.genero := r2.genero;
    r1.nombre := r2.nombre;
    r1.duracion := r2.duracion;
    r1.director := r2.director;
    r1.precio := r2.precio;
end;

procedure Eliminar(var a: archivo_novelas);
var
    indice: integer;
    cabecera: tipo_novela;
    nuevaCabecera: tipo_novela;
    codigo: integer;
begin
    write('Ingrese código de Novela a eliminar: ');
    readln(codigo);
    indice := buscarIndiceNovela(a, codigo);

    if (indice < 0) then
        writeln('No existe novela con el código ingresado')
    else begin
        LeerNovelaDeArchivo(a, cabecera);
        ClonarRegistro(nuevaCabecera, cabecera);
        nuevaCabecera.codigo := indice * (-1);
        seek(a, 0);
        write(a, nuevaCabecera);
        seek(a, indice);
        write(a, cabecera);
    end; 

end;

procedure AbrirArchivo();
var
    archivo: archivo_novelas;
    nombre_archivo: string;
    opcion: char;
begin
    write('Ingrese nombre del archivo a modificar: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    reset(archivo);

    writeln('############### Menu Archivo #################');
    writeln('A: Dar de alta una novela');   
    writeln('B: Modificar novela');
    writeln('C: Eliminar una novela por código');
    writeln('##########################################');
    write('Teclee una opción: ');
    readln(opcion);

    case opcion of 
        'A', 'a': DarAlta(archivo);
        'B', 'b': Modificar(archivo);
        'C', 'c': Eliminar(archivo);
    end;

    close(archivo);
end;

procedure ExportarArchivo();
var 
    archivo: archivo_novelas;
    nuevo_archivo: Text;
    nombre_archivo: string;
    novela: tipo_novela;
begin
    write('Ingrese nombre del archivo a exportar: ');
    readln(nombre_archivo);
    assign(archivo, nombre_archivo);
    assign(nuevo_archivo, 'novelas.txt');
    reset(archivo);
    rewrite(nuevo_archivo);

    LeerNovelaDeArchivo(archivo, novela);
    while (novela.codigo <> FIN_ARCHIVO) do begin
        with novela do begin
            writeln(nuevo_archivo, codigo);
            writeln(nuevo_archivo, nombre);
            writeln(nuevo_archivo, genero);
            writeln(nuevo_archivo, director);
            WriteLn(nuevo_archivo, duracion, precio);
        end;

        LeerNovelaDeArchivo(archivo, novela);
    end;
    
    close(archivo);
    close(nuevo_archivo);
end;
var
    opcion: char;
begin
    writeln('############### Menu Principal #################');
    writeln('################## Novelas #####################');
    writeln('A: Crear');
    writeln('D: Abrir');
    writeln('E: Listar');
    writeln('################################################');
    write('Teclee una opción: ');
    readln(opcion);

    case opcion of 
        'A', 'a': CrearArchivo();
        'B', 'b': AbrirArchivo();
        'C', 'c': ExportarArchivo();
    end;
end.