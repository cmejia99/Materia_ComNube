#!/usr/bin/env bash   

echo "##############################SE REALIZA INSTALACION DE LAS DEPENDENCIAS INICIALES##############"
sudo apt-get update -y
sudo apt upgrade -y

sudo apt-get install net-tools 
echo "Instalando Vim"
sudo apt-get install vim -y

echo "Instalando apache2"
sudo apt install apache2 -y

systemctl enable apache2 

echo "Configurando paginas personalizadas"
cat <<TEST >  /var/www/html/index.html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2016-11-16
    See: https://launchpad.net/bugs/1288690
  -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Se encuentra en el servidor web1</title>
    <style type="text/css" media="screen">
  * {
    margin: 0px 0px 0px 0px;
    padding: 0px 0px 0px 0px;
  }

  body, html {
    padding: 3px 3px 3px 3px;

    background-color: #D8DBE2;

    font-family: Verdana, sans-serif;
    font-size: 11pt;
    text-align: center;
  }

  div.main_page {
    position: relative;
    display: table;

    width: 800px;

    margin-bottom: 3px;
    margin-left: auto;
    margin-right: auto;
    padding: 0px 0px 0px 0px;

    border-width: 2px;
    border-color: #212738;
    border-style: solid;

    background-color: #FFFFFF;

    text-align: center;
  }

  div.page_header {
    height: 99px;
    width: 100%;

    background-color: #F5F6F7;
  }

  div.page_header span {
    margin: 15px 0px 0px 50px;

    font-size: 180%;
    font-weight: bold;
  }
    </style>
  </head>
  <body>
    <div class="main_page">
      <div class="page_header floating_element">
        <span class="floating_element">
          ! Hemos ingresado al punto adicional por el web1 !
        </span>
      </div>
  </body>
</html>
TEST
echo "Reiniciando el servicio de apache"
systemctl restart apache2
echo "Estado el servicio de apache"
systemctl status apache2

