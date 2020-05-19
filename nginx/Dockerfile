FROM nginx:1.18.0-alpine

WORKDIR /proj-cont

RUN rm -f ~/etc/nginx/conf.d/* && mkdir -p tmp/sockets
COPY nginx.conf ~/etc/nginx/conf.d/proj-cont.conf

# The path to nginx.conf starts from "/etc/nginx/"
CMD ["nginx", "-c", "nginx.conf", "-g", "daemon off;"]
