# Base Image is latest Alpine
FROM alpine:latest

# Maintainer information and description
LABEL maintainer="Jorge Pabón <pianistapr@hotmail.com>" description="Alpine + Apache2 with my CV in a JavaScript web app."

# Setup Apache, also create the directory that will hold our application files /app
RUN apk --no-cache --update \
    add apache2 \
    apache2-ssl \
    && mkdir /app

# Copy our application to the /app directory
COPY ./App /app

# Expose our web ports
EXPOSE 80

# Add the entrypoint script
ADD entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

# Execute the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]