# Base de Node.js para ejecutar la aplicación
FROM node:24-alpine

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar los archivos de dependencias
COPY package*.json ./

# Instalar dependencias de forma reproducible
RUN npm ci

# Copiar el código fuente de la aplicación
COPY . .

# Compilar los estilos de Tailwind CSS
RUN npm run build:css

# Documentar el puerto de la aplicación
EXPOSE 3000

# Iniciar el servidor Express
CMD ["npm", "start"]