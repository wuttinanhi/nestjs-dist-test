FROM node:lts-alpine as build
RUN npm install -g pnpm @nestjs/cli
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN pnpm install --prod
RUN pnpm prune --prod
COPY . .
RUN pnpm build
RUN chown -R node /usr/src/app

FROM node:lts-alpine as production
ENV NODE_ENV=production
EXPOSE 3000
COPY --from=build /usr/src/app /app
RUN rm -rf /app/node_modules
WORKDIR /app/dist
USER node
CMD ["node", "main.js"]
