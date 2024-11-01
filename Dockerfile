# Stage 1: Build
FROM node:16 AS builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

RUN yarn build

# Stage 2: Create the runtime image
FROM node:16 AS production

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./

# Install only production dependencies
RUN yarn install --production

# Expose the port your application runs on (e.g., 3000)
EXPOSE 3000

# Command to run the application
CMD ["yarn", "start"]
