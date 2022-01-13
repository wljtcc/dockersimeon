#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM dockersimeon/epa:php7.3.31
LABEL autor="Wellington Luiz <https://github.com/wljtcc>"
LABEL version="php7.3.32"

#------------------------------------------------------------------------------
# Install:
#------------------------------------------------------------------------------

COPY update.sh /
RUN sh /update.sh

#------------------------------------------------------------------------------
# Expose ports, entrypoint and command:
#------------------------------------------------------------------------------

ENV EPA_PATH=/var/www/html/epa
WORKDIR /var/www/html
EXPOSE 80
ENTRYPOINT ["/etc/init.d/run.sh"]
