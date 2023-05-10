// 7. Se cuenta con un archivo que almacena información sobre especies de aves en
// vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
// descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
// un programa que elimine especies de aves, para ello se recibe por teclado las especies a
// eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
// procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
// implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
// otro procedimiento que compacte el archivo, quitando los registros marcados. Para
// quitar los registros se deberá copiar el último registro del archivo en la posición del registro
// a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
// duplicados.
// Nota: Las bajas deben finalizar al recibir el código 500000

program ejercicio7;
const FIN_LECTURAS = 32767;
FIN_ARCHIVO = 32767;
MARCA_ELIMINADO = '@';
type
    tipo_codigo = integer;
    tipo_ave = record
        codigo: tipo_codigo;
        nombre: string;
        familia: string;
        descripcion: string;
        zona: string;
    end;

    archivo_aves = file of tipo_ave;

procedure LeerAveDeArchivo(var a: archivo_aves; var av: tipo_ave);
begin
    if (not EOF(a)) then
        read(a, av)
    else
        av.codigo := FIN_ARCHIVO;
end;
procedure MarcarEliminaciones(var a: archivo_aves);
var
    ave: tipo_ave;
    fin: boolean;
    codigo: tipo_codigo;
begin
    reset(a);
    fin := false;

    while not fin do begin
        write('Ingrese codigo de especie a eliminar (500000 para terminar): ');
        readln(codigo);

        if codigo = FIN_LECTURAS then
            fin := true
        else begin
            seek(a, 0);
            LeerAveDeArchivo(a, ave);
            while (ave.codigo <> FIN_ARCHIVO) and (ave.codigo <> codigo) do
                LeerAveDeArchivo(a, ave);
            
            if ave.codigo = codigo then begin
                ave.zona := MARCA_ELIMINADO;
                seek(a, FilePos(a) - 1);
                write(a, ave);
            end
            else 
                writeln('No existe ave con el código ingresado');
            
        end;
    end;

    close(a);
end;

procedure Compactar(var a: archivo_aves);
var
    indiceEliminado: integer;
    ultimoIndice: integer;
    aveLeida: tipo_ave;
    ultimaAve: tipo_ave;

begin
    reset(a);
    LeerAveDeArchivo(a, aveLeida);
    while (aveLeida.codigo <> FIN_ARCHIVO) do begin
        if (aveLeida.zona = MARCA_ELIMINADO) then begin
            indiceEliminado := FilePos(a) - 1;
            ultimoIndice := FileSize(a) - 1; 
            Seek(a, ultimoIndice);
            LeerAveDeArchivo(a, ultimaAve);
            Seek(a, indiceEliminado);
            Write(a, ultimaAve);
            Seek(a, ultimoIndice);
            Truncate(a);
        end;

        LeerAveDeArchivo(a, aveLeida);
    end;
end;
begin
  
end.