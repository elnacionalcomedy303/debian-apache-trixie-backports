# Práctica de aula: Docker y Apache

## Pasos realizados

### 1. Preparación del entorno y descarga de la imagen
Se descargó la imagen oficial de Debian desde el Hub de Docker:
```bash
docker pull debian:latest
```

### 2. Creación e inicio del contenedor
Se arrancó un contenedor interactivo (`-i`), con terminal (`-t`), en segundo plano (`-d`), exponiendo el puerto 8080:
```bash
docker run -it -d --name miprimer-debian -p 8080:80 debian:latest
```

### 3. Configuración interna del servidor Apache
Se accedió a la shell del contenedor:
```bash
docker exec -it miprimer-debian bash
```
Dentro del contenedor, se instalaron Apache2 y el navegador en modo texto `elinks`:
```bash
apt update && apt install -y apache2 elinks
service apache2 start
```

### 4. Creación de la página web personalizada
Se creó el archivo `mario.html` dentro del directorio web del servidor:
```bash
echo "<h1>Hola soy Mario</h1>" > /var/www/html/mario.html
```
Se comprobó el acceso desde la línea de comandos con `elinks http://localhost/mario.html` y desde el navegador web en `http://localhost:8080/mario.html`.

### 5. Automatización mediante Dockerfile
Se creó un fichero `Dockerfile` para empaquetar la configuración e instalar las dependencias automáticamente:
```dockerfile
FROM debian:latest
RUN apt update && apt install -y apache2 elinks
ADD mario.html /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
```
Se construyó la imagen personalizada:
```bash
docker build -t midebian:1.0 .
```

### 6. Copia de archivos locales al contenedor
Comando utilizado para copiar archivos locales hacia un contenedor existente:
```bash
docker cp mario.html miprimer-debian:/var/www/html/
```

### 7. Orquestación y volúmenes con Docker Compose
Se configuró el archivo `docker-compose.yml` mapeando la carpeta local `./html` hacia la ruta interna de Apache:
```yaml
version: "3.9"

services:
  apache:
    image: midebian:1.0
    container_name: misegundo-debian
    ports:
      - "8081:80"
    volumes:
      - ./html:/var/www/html
```
Se inició el servicio desplegando el volumen:
```bash
docker compose up -d
```
Se verificó el correcto funcionamiento accediendo desde el navegador a `http://localhost:8081/mario.html`.