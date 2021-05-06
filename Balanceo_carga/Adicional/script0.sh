#!/usr/bin/env bash   

echo "##############################SE REALIZA INSTALACION DE LAS DEPENDENCIAS INICIALES##############"
sudo apt-get update -y
sudo apt upgrade -y

sudo apt-get install net-tools 
echo "Instalando Vim"
sudo apt-get install vim -y

echo "Instalando haproxy"
sudo apt install haproxy -y


systemctl enable haproxy 

echo "Configurando archivos haproxy.cfg"
cat <<TEST >  /etc/haproxy/haproxy.cfg
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats

   server web1 192.168.100.11:80 check   
   server web2 192.168.100.12:80 check      

frontend http
  bind *:80
  default_backend web-backend


TEST

echo "Iniciando el servicio de haproxy"
systemctl start haproxy 
echo "Reiniciando el servicio de haproxy"
systemctl restart haproxy 
echo "Estado el servicio de haproxy"
systemctl status haproxy 