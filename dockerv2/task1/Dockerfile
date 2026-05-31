FROM nginx:1.29.0

WORKDIR /usr/share/nginx/html

COPY index.html  .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]