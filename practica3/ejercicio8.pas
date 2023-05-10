// 8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
// existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
// versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
// distribuciones no puede repetirse.
// Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
// reutilización de espacio libre llamada lista invertida.
// Escriba la definición de las estructuras de datos necesarias y los siguientes
// procedimientos:
// ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
// la distribución existe en el archivo o falso en caso contrario.
// AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
// agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
// unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
// se quiere agregar ya exista se debe informar “ya existe la distribución”.
// BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
// lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
// cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
// que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
// existir se debe informar “Distribución no existente”.

program ejercicio8;

begin
  
end.