# ==========================================
# Tahap 1: Builder
# ==========================================
FROM node:20-alpine AS builder

# Set working directory ke /app
WORKDIR /app

# Copy file dependency lalu jalankan instalasi
COPY package.json package-lock.json ./
RUN npm ci

# Copy sisa source code
COPY . .

# Jalankan perintah build untuk menghasilkan file statik di dist/
RUN npm run build:prod

# ==========================================
# Tahap 2: Web Server
# ==========================================
FROM nginx:alpine

# Pindahkan hasil build dari tahap 1 ke folder publik NGINX
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 agar bisa diakses dari luar container
EXPOSE 80
