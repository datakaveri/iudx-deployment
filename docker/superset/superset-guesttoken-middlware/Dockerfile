FROM node:20

WORKDIR /app

COPY package.json package-lock.json 
# Install dependencies
COPY . .
RUN npm install
# Expose the application port
EXPOSE 8000
USER node
# Command to run the application
CMD ["npm" ,"run", "dev"]

