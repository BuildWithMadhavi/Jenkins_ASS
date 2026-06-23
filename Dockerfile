FROM node:18-alpine
WORKDIR /usr/src/app

# install deps
COPY package.json package-lock.json* ./
RUN npm ci --only=production || npm install --only=production

# copy app
COPY . .

EXPOSE 3000
CMD ["node", "app/server.js"]
