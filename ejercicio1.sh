#1/bin/bash 

#verificamos que el usuario sea root o no 
if [ $EUID -ne 0 ]; then
	echo "este script es ejecutado pro el usuario root"
	exit 1
fi

# verificar argumentos 
if [ $# -ne 3]; then
	echo "Error: Debes prporcionar 3 agrumentos (usuario, grupo, archivo)."
	exit 1
fi
usuario=$1
grupo=$2
archivo=$3

#verificar si el archivo existe 

if [ ! -f "$archivo" ]; then 
	echo "El archivo $archivo no existe"
	exit 1
fi

#verificar si el grupo existe y si no existe, se crea
if ! getnet group "$group" > /dev/null; then
	groupadd "$grupo"
else
	echo "El grupo $grupo ya existe."
fi

#verificar si el usuario existe, si no tambien se crea
if ! id - u "$usuario" > /dev/null; then
	useradd "$usuario"
else
	echo "El usuario $usuario ya existe"
fi

# Agregar el usuario al grupo
usermod -aG "$grupo" "$usuario"

# modificar la propiedad del archivo
echo " Cambiando propiedad del archivo "$archivo" a "$usuario":$grupo..."
chown "$usuario:$grupo" "$archivo"

#modificar permisos del archivo
echo"configurando permisos del archivo $archivo..." 
chmod u=rwx,g=r,o= "$archivo"

echo "script ejecutado correctamente."



