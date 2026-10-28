# ==========================================
# ETAPA 1: Compilación (Build Stage)
# ==========================================
# Usamos Node para ejecutar npm install y npm run build
FROM node:20-alpine AS builder

WORKDIR /app

# 1. Copiamos los archivos de paquetes
COPY package.json ./

# 2. Copiamos el código fuente
COPY src/ ./src/

# 3. Ejecutamos el build (genera la carpeta /app/dist)
RUN npm run build


# ==========================================
# ETAPA 2: Producción (Runtime Stage)
# ==========================================
# Descartamos Node por completo. Usamos Nginx Alpine (~23MB)
FROM nginx:alpine-slim

# Copiamos ÚNICAMENTE la carpeta dist producida en la Etapa 1
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponemos el puerto estándar web
EXPOSE 80

# Nginx inicia en primer plano
CMD ["nginx", "-g", "daemon off;"]
