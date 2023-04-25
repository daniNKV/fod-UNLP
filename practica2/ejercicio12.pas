// La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
// la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
// realizan al sitio.
// La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
// tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
// siguientes criterios: año, mes, dia e idUsuario.
// Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
// el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
// mostrado a continuación:
// Se deberá tener en cuenta las siguientes aclaraciones:
// - El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
// - El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
// no encontrado”.
// - Debe definir las estructuras de datos necesarias.
// - El recorrido del archivo debe realizarse una única vez procesando sólo la información
// necesaria.

program ejercicio12;
const
    FIN_ARCHIVO = 32767;
    CANTIDAD_MESES = 12;
    DIAS_EN_MES = 31;
type
    tipo_acceso = record
        anio: integer;
        mes: integer;
        dia: integer;
        idUsuario: integer;
        tiempoAcceso: integer;
    end;

    archivo_accesos = file of tipo_acceso;
    
    total_diario = array[1 .. DIAS_EN_MES] of integer;
    total_mensual = array[1..CANTIDAD_MESES] of total_diario;

procedure IniciarContadores(var mensual: total_mensual);
var i, j: integer;
begin
    for i := 1 to CANTIDAD_MESES do 
        for j := 1 to DIAS_EN_MES do
            mensual[i][j] := 0;
end;

procedure ImprimirInformeAccesos(var a: archivo_accesos; var accesos: total_mensual; var accesoLeido: tipo_acceso);
var 
    accesoProcesado: tipo_acceso;
    tiempo_usuario: integer;
    anioProcesado: integer;
    i: integer;
    tiempo_mensual: integer;
    tiempo_anual: integer;
begin
    anioProcesado := accesoLeido.anio;
    Write('Año: '); Writeln(accesoLeido.anio);    
    
    while (accesoLeido.anio <> FIN_ARCHIVO) and (accesoLeido.anio < anioProcesado) do 
    begin
       
        accesoProcesado := accesoLeido;
        Write('Mes: '); Writeln(accesoProcesado.mes);

        while (accesoLeido.mes = accesoProcesado.mes) and (accesoLeido.anio <> FIN_ARCHIVO) and (accesoLeido.anio < anioProcesado) do 
        begin

            Write('Dia: '); Writeln(accesoProcesado.dia);

            while (accesoLeido.dia = accesoProcesado.dia) and (accesoLeido.mes = accesoProcesado.mes) and (accesoLeido.anio <> FIN_ARCHIVO) and (accesoLeido.anio < anioProcesado) do 
            begin
                tiempo_usuario := 0;
                Write('idUsuario '); Write(accesoLeido.idUsuario);
             
                while (accesoLeido.idUsuario = accesoProcesado.idUsuario) and (accesoLeido.dia = accesoProcesado.dia) and (accesoLeido.mes = accesoProcesado.mes) and (accesoLeido.anio <> FIN_ARCHIVO) and (accesoLeido.anio < anioProcesado) do begin
                    tiempo_usuario := tiempo_usuario + accesoLeido.tiempoAcceso;
                end;
                
                with accesoProcesado do 
                begin
                    accesos[mes][dia] := accesos [mes][dia] + tiempo_usuario;
                    Write('Tiempo Total de acceso en el dia ', dia, 'mes', mes, ': ' );
                    Write(tiempo_usuario);
                end;
            end;
            with accesoProcesado do begin
                Write('Tiempo Total acceso en el día ', dia, ' mes ', mes, ' ');
                Write(accesos[mes][dia]);
            end;
        end;

        with accesoProcesado do begin
            Write('Tiempo Total acceso en el mes ', mes, ' ');
            tiempo_mensual := 0;
            for i := 1 to DIAS_EN_MES do
                 tiempo_mensual := tiempo_mensual + accesos[mes][i];
            Write(tiempo_mensual);
        end;
    
    end;

    with accesoProcesado do begin
        Write('Tiempo Total acceso en el año ', anio, ' ');
        tiempo_anual := 0;
        for i := 1 to DIAS_EN_MES do
                tiempo_anual := tiempo_anual + accesos[mes][i];
        Write(tiempo_anual);
    end;
end;

procedure GenerarInformeAccesos(var a: archivo_accesos);
var
    accesos: total_mensual;
    accesoLeido: tipo_acceso;
    tiempo_usuario: integer;
    anioPedido: integer;
    anioEncontrado: boolean;
begin
    anioEncontrado := false;
    Write('Ingrese año del cual generar reporte: ');
    Readln(anioPedido);
    Reset(a);
    
    IniciarContadores(accesos);
    LeerAcceso(accesoLeido);

    while (accesoLeido.anio <> FIN_ARCHIVO) and (not anioEncontrado) do begin
        if (accesoLeido.anio = anioPedido) then begin
            anioEncontrado := true;
            Seek(a, FilePos(a) - 1);
        end
        else 
            LeerAcceso(accesos);
    end;

    if anioEncontrado then
        ImprimirInformeAccesos(a, accesos, accesoLeido);
    else
        WriteLn('El año ingresado no ha sido encontrado');

end;
    
end.