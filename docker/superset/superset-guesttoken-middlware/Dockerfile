FROM node:20
WORKDIR /app
COPY . .
# Install dependencies
RUN npm install
# Expose the application port
EXPOSE 8000
USER node
# Command to run the application
CMD ["npm" ,"run", "dev"]

