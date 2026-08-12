# Dockerfile buat web Ketik Hotel
# alurnya: source dibuild pake node dulu, hasilnya disajiin pake nginx
# jadi image finalnya kecil, gak bawa node_modules

# stage 1: build file statis
FROM node:20-alpine AS builder

WORKDIR /app

# copy package.json dulu sebelum source biar layer cache-nya kepake
COPY package.json package-lock.json ./
RUN npm ci

# baru copy semua source lalu build
COPY . .
RUN npm run build

# stage 2: web server
FROM nginx:alpine

# hasil build dari stage 1 dipindah ke folder html punya nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# port standar nginx
EXPOSE 80
