FROM node:18-alpine

WORKDIR /app
COPY . .

RUN echo "Demo DevSecOps App"

CMD ["node", "server.js"]

