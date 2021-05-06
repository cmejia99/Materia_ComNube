#!/usr/bin/env bash   

apt-get update 

apt-get install net-tools 
apt-get install vim 

apt-get install git -y
echo "Instalando Servidor Apache"
apt-get install apache2 -y

echo "Instalando python"
apt-get install python3-pip -y

echo "Instalando Servicio jupiter"
pip3 install jupyter

echo "Configuración variable de entorno:"
export PATH="$HOME/.local/bin:$PATH"

mkdir /home/vagrant/Servicios


mkdir /home/vagrant/Servicios/Servidor_jupyter
touch /home/vagrant/Servicios/Servidor_jupyter/bienvenido.txt

echo "Insertando mensaje de bienvenida" 
cat <<TEST > /home/vagrant/Servicios/Servidor_jupyter/bienvenido.txt
Bienvenido a este servidor Jupyter
TEST


touch /home/vagrant/Servicios/init.sh

echo "Se genera información de inicialización del servicio jupiter" 
cat <<TEST > /home/vagrant/Servicios/init.sh
#!/usr/bin/env bash
echo "Estoy iniciando el servicio"
jupyter notebook --ip=0.0.0.0
TEST

sudo chmod 777 /home/vagrant/Servicios/init.sh

echo "Se crea enlace simbolico para poder llamarlo al momento de iniciar el servicio"
sudo ln -s /home/vagrant/Servicios/init.sh /home/vagrant/Servicios/init_jucm   

echo "Se crear el archivo de servicio"
sudo touch /lib/systemd/system/cm_jupiter.service

echo "Se genera información del archivo de servicio" 
cat <<TEST > /lib/systemd/system/cm_jupiter.service
[Unit]
Description=Servicio de jupyter generado por carlos mejia
After=network.target

[Service]
User=vagrant
WorkingDirectory=/home/vagrant/Servicios/
Type=simple
ExecStart=/home/vagrant/Servicios/init_jucm
GuessMainPID=no

[Install]
WantedBy=multi-user.target
TEST

sudo systemctl daemon-reload
sudo systemctl enable cm_jupiter.service
sudo systemctl start cm_jupiter.service

