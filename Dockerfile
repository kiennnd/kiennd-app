# Stage 1: Build Stage
FROM node:20-slim as builder

# Set a working directory
WORKDIR /app

# Copy package.json và yarn.lock để tối ưu caching
COPY package.json yarn.lock ./

# Cài đặt dependencies
RUN yarn install --frozen-lockfile

# Copy toàn bộ source code
COPY . .

# Build ứng dụng Vue.js
RUN yarn build

# Stage 2: Run Stage
FROM node:20-slim

# Set a working directory
WORKDIR /app

# Install a lightweight static server (serve)
RUN yarn global add serve

# Copy các tệp đã build từ stage 1
COPY --from=builder /app/dist /app/dist

# Expose port 3000
EXPOSE 3000

# Command để chạy server
CMD ["serve", "-s", "dist", "-l", "3000"]