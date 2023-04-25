// Suponga que usted es administrador de un servidor de correo electrónico. En los logs
// del mismo (información guardada acerca de los movimientos que ocurren en el server) que
// se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
// nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
// servidor de correo genera un archivo con la siguiente información: nro_usuario,
// cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
// usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
// sabe que un usuario puede enviar cero, uno o más mails por día.
// a- Realice el procedimiento necesario para actualizar la información del log en
// un día particular. Defina las estructuras de datos que utilice su procedimiento.
// b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
// detalle de un día determinado:
// nro_usuarioX..............cantidadMensajesEnviados
// .............
// nro_usuarioX+n...........cantidadMensajesEnviados
// Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
// existen en el sistema

program ejercicio13;
const
    FIN_ARCHIVO = 32767;
type
    tipo_log = record
        nroUsuario: integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        cantidadMailEnviados: integer;
    end;
    tipo_enviado = record
        nroUsuario: integer;
        cuentaDestino: string;
        cuerpoMensaje: string;
    end;
    tipo_logs = file of tipo_log;
    tipo_enviados = file of tipo_enviado;

procedure LeerLogs(var a: tipo_logs; var l: tipo_log);
begin

end;

procedure LeerEnviados(var a: tipo_enviados; var e: tipo_enviado);
begin

end;

procedure ActualizarLogs(var logs: tipo_logs; var detalles: tipo_enviados);
var
    log: tipo_log;
    enviado: tipo_enviado;
    cantidadEnviados: integer;
    usuario: integer;
begin
    LeerEnviados(detalles, enviado);
    while (log.nroUsuario <> FIN_ARCHIVO) do begin
        usuario := enviado.nroUsuario;
        cantidadEnviados := 0;
        while enviado.nroUsuario = usuario do begin
            cantidadEnviados := cantidadEnviados + 1;
        end;

        LeerLogs(logs, log);
        while (log.nroUsuario <> FIN_ARCHIVO) and (log.nroUsuario <> usuario) do begin
            if (log.nroUsuario = usuario) then
                log.cantidadMailEnviados := log.cantidadMailEnviados + cantidadEnviados;
                Seek(logs, FilePos(logs) - 1);
                Write(logs, log);
            LeerLogs(logs, log);
        end;

        LeerEnviados(detalles, enviado);
    end;
end;

procedure GenerarInforme(var logs: tipo_logs);
var
    nuevo_archivo: Text;
    log: tipo_log;
begin
    Assign(nuevo_archivo, 'envios-por-usuario.txt');
    Rewrite(nuevo_archivo);

    LeerLogs(logs, log);
    
    while (log.nroUsuario <> FIN_ARCHIVO) do begin
        WriteLn(nuevo_archivo, log.nroUsuario, log.cantidadMailEnviados);
        LeerLogs(logs, log);
    end;

end;

var 
    logs: tipo_logs;
    enviados: tipo_enviados;
begin
    Assign(logs, '/var/log/logmail.dat');
    Reset(logs);
    Assign(enviados,'/var/log/enviados.dat');
    Reset(enviados);
end.