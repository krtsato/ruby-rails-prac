FROM postgres:12.2-alpine

# default values can be checked in EC2 (Amazon Linux 2)
ARG GID=1001
ARG UID=1001

RUN addgroup -g $GID db-cont-gp \
&& adduser -u $UID -G db-cont-gp -D db-cont-usr \
&& echo "db-cont-usr ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER db-cont-usr
