#!/bin/bash

cmd="xdebug"
description="Install, enable or disable xdebug"
author="Thibaud WILLM"

PHP_XDEBUG_INI="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"

source $UTILS_DIR/functions.sh

# Function to install Xdebug
install_xdebug() {
    print_message "Installing Xdebug for FrankenPHP..."
    
    # Check if xdebug is already installed
    if php -m | grep -q xdebug; then
        print_message "Xdebug is already installed." "✅"
    else
        # Use install-php-extensions from FrankenPHP
        print_message "Installing Xdebug extension..." "📦"
        install-php-extensions xdebug
    fi
    
    update_php_ini
}

# Function to enable Xdebug
enable_xdebug() {
    print_message "Enabling Xdebug..."
    update_php_ini
    print_message "Xdebug has been enabled." "✅"
}

# Function to disable Xdebug
disable_xdebug() {
    print_message "Disabling Xdebug..."
    if [ -f "$PHP_XDEBUG_INI" ]; then
        rm "$PHP_XDEBUG_INI"
        print_message "Xdebug has been disabled." "✅"
    else
        print_message "Xdebug is not installed." "⚠️"
    fi
}

update_php_ini() {
  # Check if Xdebug is already configured
  if [ -f "$PHP_XDEBUG_INI" ] && grep -q "^xdebug.idekey=dotworld" "$PHP_XDEBUG_INI"; then
      print_message "Xdebug is already configured in $PHP_XDEBUG_INI" "✅"
  else
      # Create or overwrite Xdebug configuration
      cat > "$PHP_XDEBUG_INI" <<EOF
zend_extension=xdebug.so
xdebug.mode=develop,debug
xdebug.client_port=9003
xdebug.start_with_request=yes
xdebug.client_host=host.docker.internal
xdebug.idekey=dotworld
xdebug.log_level=0
EOF
      print_message "Xdebug configuration added to $PHP_XDEBUG_INI" "✅"
  fi
}


install_xdebug


exit 0

