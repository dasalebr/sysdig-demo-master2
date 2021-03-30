FROM node:15-alpine

RUN mkdir /app
COPY index.js /app
WORKDIR /app
RUN npm install express
EXPOSE 4444
CMD ["node", "index.js"]
