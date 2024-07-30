FROM chdotworld/dotworld:base-alpine

LABEL maintainer="Dotworld"

# Install necessary dependencies and clean up
RUN apk update && apk upgrade && \
    apk add --no-cache docker-cli \
    # Cleanup cache to reduce image size
    && rm -rf /var/cache/apk/*
    
# Set working directory
WORKDIR /var/www/html