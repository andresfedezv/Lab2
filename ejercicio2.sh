#!/bin/bash 

# primero, se verifica si dieron el comando

if [ -z "$1" ]; then
	echo "error, se tiene que poner un progrma , ejemplo: ./ejercicio2.sh fierfox"
	exit 1

fi

# Archivo para guardar los datos 
log = "registro.log"

#ejecutar el programa y conseguir el ID

$1 &
pid =&!

echo "voy a vigilar el proceso$pid..."
echo "Tiempo CPU Memoria" >$log

# Medir mientras el proceso este activo
while true; do
	#ver si sigue activo 
	if ! ps -p $pid > /dev/null; then
		break
	fi

	#tener el tiempo actual
	tiempo= $(date +%s)

	#obtener uso de cpu y la memoria
	cpu=$(ps -p $pid -o %cpu | tail -1 | awk '{print $1}')
	mem=$(ps -p $pid -o %mem | tail -1 | awk '{print $1}')

	#para guardar el archivo 
	echo "$tiempo $cpu $mem" >> $log

	#esperar un segundo 
	sleep 1
done

echo "set terminal png
set output 'grafica.png'
set title 'uso de recursos'
set xlabel 'tiempo'
set ylabel 'porcentaje'
plot '$log' using 1:2 with lines title 'CPU', \
	'$log' using 1:3 with lines title ' Memoria'" | gnuplot
echo "listuki"


