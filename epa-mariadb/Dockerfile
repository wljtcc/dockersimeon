#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM mariadb:10.4.1
LABEL MAINTAINER="Wellington Luiz <https://github.com/wljtcc>"
LABEL VERSION="MariaDB-10.4.1"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

RUN mv /etc/mysql/my.cnf /etc/mysql/my.cnf.old
# ADD ./my.cnf /etc/mysql/my.cnf
RUN apt update -y \
    && apt-get upgrade -y \
    && apt-get upgrade -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# RUN chmod 0644 /etc/mysql/my.cnf
