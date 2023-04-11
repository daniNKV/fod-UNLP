// Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
// fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
// máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
// archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
// cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
// cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
// detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
// tiempo_total_de_sesiones_abiertas.
// Notas:
// - Cada archivo detalle está ordenado por cod_usuario y fecha.
// - Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
// máquinas.
// - El archivo maestro debe crearse en la siguiente ubicación física: /var/log.


program ejercicio5;
Uses sysutils;

const
    UBICACION_MAESTRO = '/var/log';
    FIN_ARCHIVO = 32767;
    MAXIMO_CODIGO = 32767;
    DIAS_MES = 31;
    CANTIDAD_MAQUINAS = 5;
type
    mes_tipo = 1 .. 31;
    tipo_sesion = record
        codigo_usuario: integer;
        fecha: mes_tipo;
        tiempo_sesion: double;
    end;

    tipo_sesiones = record
        codigo_usuario: integer;
        fecha: integer;
        tiempo_total_de_sesiones_abiertas: double
    end;

    archivo_detalles = file of tipo_sesion; 
    archivo_maestro = file of tipo_sesiones;

    archivos_array = Array[1..CANTIDAD_MAQUINAS] of archivo_detalles;

procedure LeerDetalle(var a: archivo_detalles; var r: tipo_sesion);
begin
    if (not EOF(a)) then
        Read(a, r)
    else
        r.codigo_usuario := FIN_ARCHIVO;
end;

procedure buscarMinimo(var a: archivos_array; var sesion: tipo_sesion);
var 
    i: integer;
    sesion_procesada: tipo_sesion;
begin
    sesion.codigo_usuario := MAXIMO_CODIGO;
    sesion.fecha := DIAS_MES;
    for i := 1 to CANTIDAD_MAQUINAS do begin
        LeerDetalle(a[i], sesion_procesada);
        if (sesion_procesada.codigo_usuario < sesion.codigo_usuario) then
            sesion := sesion_procesada
        else if (sesion_procesada.codigo_usuario = sesion.codigo_usuario) and (sesion_procesada.fecha <= sesion.fecha) then
            sesion := sesion_procesada
        else
            Seek(a[i], FilePos(a[i]) - 1);
    end;
end;

procedure Merge();
var
    sesion: tipo_sesion;
    sesiones: tipo_sesiones;
    nuevo_archivo: archivo_maestro;
    archivos_detalle: archivos_array;
    codigo: integer;
    fecha: integer;
    tiempo_acumulado: double;
    i, numero_maquina: integer;
    numero_maquina_string: string;
    nombre_archivo: string;
begin
    Assign(nuevo_archivo, UBICACION_MAESTRO);
    Rewrite(nuevo_archivo);

    for i := 1 to CANTIDAD_MAQUINAS do begin
        numero_maquina := i;
        numero_maquina_string := IntToStr(i);
        nombre_archivo := '/var/detalle-' + numero_maquina_string + '.dat';
        Assign(archivos_detalle[numero_maquina], nombre_archivo);
        Reset(archivos_detalle[numero_maquina]);
    end;

    buscarMinimo(archivos_detalle, sesion);
    while (sesion.codigo_usuario <> FIN_ARCHIVO) do begin
        codigo := sesion.codigo_usuario;
       
        while (codigo <> FIN_ARCHIVO) and (codigo = sesion.codigo_usuario) do begin
            fecha := sesion.fecha;
            tiempo_acumulado := 0;
       
            while (codigo <> FIN_ARCHIVO) and (codigo = sesion.codigo_usuario) and (fecha = sesion.fecha) do begin
                tiempo_acumulado := tiempo_acumulado + sesion.tiempo_sesion;
                buscarMinimo(archivos_detalle, sesion);
            end;

            sesiones.codigo_usuario := codigo;
            sesiones.fecha := fecha;
            sesiones.tiempo_total_de_sesiones_abiertas := tiempo_acumulado;

            Write(nuevo_archivo, sesiones);
        end; 

        buscarMinimo(archivos_detalle, sesion);       
    end;

    close(nuevo_archivo);

    for i := 0 to CANTIDAD_MAQUINAS do
        close(archivos_detalle[i])
end;
begin
    Merge();
end.