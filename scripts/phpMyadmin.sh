#!/bin/bash

echo "Comenzando la instalación de phpMyadmin"
echo "Actualizando repositorios..."
sudo apt update -y && apt upgrade -y

echo "Instalando phpMyAdmin..."
sudo apt install phpmyadmin -y

echo "Configurando permisos y seguridad..."
sudo chown -R www-data:www-data /usr/share/phpmyadmin

echo "Reiniciando el servicio Apache..."
sudo systemctl restart apache2
