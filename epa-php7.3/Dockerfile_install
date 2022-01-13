#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM debian:10.10-slim
LABEL autor="Wellington Luiz <https://github.com/wljtcc>"
LABEL version="php7.3.31"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

COPY install.sh /
COPY run.sh /etc/init.d/
RUN sh /install.sh
COPY php.ini /etc/php/7.3/apache2/
COPY apache2.conf /etc/apache2/

#------------------------------------------------------------------------------
# Expose ports, entrypoint and command:
#------------------------------------------------------------------------------

ENV EPA_PATH=/var/www/html/epa
WORKDIR /var/www/html
EXPOSE 80
ENTRYPOINT ["/etc/init.d/run.sh"]
