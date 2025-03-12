#!/bin/bash

# Extract the temporarly URL from ngrok and assign it in .env
ngrok http http://localhost:8080

npm install

# Development
npm start

# Production
npm run build