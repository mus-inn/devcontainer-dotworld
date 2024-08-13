#!/bin/bash

cmd="xdebug"
description="Install, enable or disable xdebug"
author="Okeanos"

PHP_XDEBUG_INI="/etc/php/8.2/cli/conf.d/20-xdebug.ini"

# Function to install Xdebug
install_xdebug() {
    print_message "Installing Xdebug..."
    apt-get update && apt-get install -y php8.2-xdebug
    update_php_ini
}

# Function to enable Xdebug
enable_xdebug() {
    print_message "Enabling Xdebug..."
    print_message "Xdebug has been enabled."
}

# Function to disable Xdebug
disable_xdebug() {
    print_message "Disabling Xdebug..."
    print_message "Xdebug has been disabled."
}

update_php_ini() {
  # Check if Xdebug is already configured
  if grep -q "^xdebug.idekey=dotworld" "$PHP_XDEBUG_INI"; then
      print_message "Xdebug is already configured in $PHP_XDEBUG_INI"
  else
      # Append Xdebug configuration to php.ini
      {
          echo "zend_extension=xdebug.so"
          echo "xdebug.mode=develop,debug"
          echo "xdebug.client_port=9003"
          echo "xdebug.start_with_request=yes"
          echo "xdebug.client_host=host.docker.internal"
          echo "xdebug.idekey=dotworld"
          echo "xdebug.log_level=0"
      } >> "$PHP_XDEBUG_INI"
      print_message "Xdebug configuration added to $PHP_XDEBUG_INI"
  fi
}


install_xdebug


exit 0