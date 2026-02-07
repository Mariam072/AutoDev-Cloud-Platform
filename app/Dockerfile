# Use a slim Node.js image
FROM node:20-alpine AS base

WORKDIR /app

# Copy package files first → better caching
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY src/ ./src/

# Expose port (can be overridden)
EXPOSE 3000

# Run the app
CMD ["npm", "start"]
