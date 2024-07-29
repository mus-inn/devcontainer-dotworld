FROM mcr.microsoft.com/devcontainers/base:ubuntu

LABEL maintainer="Taylor Otwell"

ARG WWWGROUP
ARG NODE_VERSION=18
ARG POSTGRES_VERSION=15

WORKDIR /var/www/html


ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Mise à jour initiale et installation des outils nécessaires
RUN apt-get update && apt-get install -y \
    gnupg curl ca-certificates zip \
    unzip wget nano zsh \
    && rm -rf /var/lib/apt/lists/*

# Add depot list
RUN  curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /etc/apt/keyrings/ppa_ondrej_php.gpg > /dev/null \
     && echo "deb [signed-by=/etc/apt/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \

     && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /etc/apt/keyrings/yarn.gpg >/dev/null \
     && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \

     && curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/keyrings/pgdg.gpg >/dev/null \
     && echo "deb [signed-by=/etc/apt/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list \

     && curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/keyrings/docker.gpg >/dev/null \
     && echo "deb [signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  jammy stable" > /etc/apt/sources.list.d/docker.list \
      
     && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
         

RUN apt-get update \
     && apt-get install -y fswatch gnupg gosu curl ca-certificates zip unzip git \ 
        supervisor sqlite3 libcap2-bin libpng-dev python2 dnsutils librsvg2-bin \
        php8.1-cli php8.1-dev php8.1-pgsql php8.1-sqlite3 \
        php8.1-gd php8.1-imagick php8.1-curl \
        php8.1-imap php8.1-mysql php8.1-mbstring \
        php8.1-xml php8.1-zip php8.1-bcmath php8.1-soap \
        php8.1-intl php8.1-readline php8.1-ldap \
        php8.1-msgpack php8.1-igbinary php8.1-redis php8.1-swoole \
        php8.1-memcached php8.1-pcov php8.1-xdebug \
        mysql-client postgresql-client-$POSTGRES_VERSION \
        docker-ce docker-ce-cli containerd.io \
     && curl -sLS https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
     && apt-get install -y nodejs \
     && npm install -g npm yarn\
     && apt-get -y autoremove \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*  /tmp/* /var/tmp/*

#install composer 
RUN  curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.1

RUN groupadd --force -g $WWWGROUP vscode
RUN useradd -ms /bin/zsh --no-user-group -g $WWWGROUP -u 1337 vscode
RUN usermod -aG docker vscode

RUN ln -f /bin/zsh /bin/sh

USER vscode
WORKDIR /home/vscode
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

USER root

COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php/8.1/cli/conf.d/99-vscode.ini
COPY xdebug.ini /etc/php/8.1/cli/conf.d/20-xdebug.ini

RUN chmod +x /usr/local/bin/start-container

EXPOSE 8000

ENTRYPOINT ["start-container"]