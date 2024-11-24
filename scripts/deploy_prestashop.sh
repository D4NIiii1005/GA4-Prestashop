# Desplegar PrestaShop
set -x

source /home/ubuntu/scripts/.env

#Posicionarse en el directorio raíz de prestashop
cd $PS_DIR

#obtener la última versión
wget $PS_LATEST_VERSION 

#Descomprimir el archivo .zip y posicionarse  en el directorio que salga
unzip *.zip

cd Pr*

#Dar permisos sobre carpeta raiz
sudo chown -R www-data:www-data $PS_DIR
sudo chmod -R 755 $PS_DIR


# Crear la base de datos para PrestaShop. En mi caso ya la habia creado
#sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
#sudo mysql -u root -e "CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASS';"
#sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
#sudo mysql -u root -e "FLUSH PRIVILEGES;"

#Habilitar modulos necesarios
sudo a2enmod rewrite
sudo a2enmod headers 

#Instalar extensiones y gestor de dependencias Composer si no está instalado
if ! [ -x "$(command -v composer)" ]; then
    echo "Composer no encontrado. Instalando Composer..."
    sudo apt update
    sudo apt install -y curl php-cli php-mbstring php-intl 
    sudo curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
else
    echo "Composer ya está instalado."
fi

# Instalar dependencias de PrestaShop con Composer
sudo composer install --no-interaction

#Posicionarse en install-dev e instalar la aplicación con el interprete de php, pasándole ciertos valores

cd install-dev/

php index_cli.php --domain=$PS_DOMAIN --db_server=$DB_SERVER --db_name=$DB_NAME --db_user=$DB_USER --db_password=$DB_PASS --prefix=$PREFIX --email=$PS_MAIL --password=$PASSWD

#Reiniciar el servicio Apache
sudo systemctl restart apache2
