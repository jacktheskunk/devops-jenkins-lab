FROM node:18-alpine

WORKDIR /app
COPY . .

RUN echo "Demo DevSecOps App"

CMD ["node", "-e", "console.log('App running')"]

