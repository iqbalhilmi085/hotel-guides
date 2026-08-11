# ==========================================================
# Stage 1 - Builder
# Membangun file static dari source code Ketik Hotel
# ==========================================================
FROM node:20-alpine AS builder

WORKDIR /app

# Salin dependensi terlebih dahulu agar memanfaatkan layer caching
COPY package.json package-lock.json ./
RUN npm ci

# Salin seluruh source code lalu build production (output ke dist/)
COPY . .
RUN npm run build

# ==========================================================
# Stage 2 - Web Server
# Menyajikan file static melalui NGINX (image ringan)
# ==========================================================
FROM nginx:alpine

# Salin hasil build dari stage builder ke direktori publik NGINX
COPY --from=builder /app/dist /usr/share/nginx/html

# Buka port 80 sebagai port standar web server
EXPOSE 80
