#!/bin/bash

cmd="Serve"
description="Lanch Air"
author="Okeanos"

source $UTILS_DIR/functions.sh

print_message "Launching Air" "📦"

/root/go/bin/air -c /workspaces/session-keeper/.air.toml
