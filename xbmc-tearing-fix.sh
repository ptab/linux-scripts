#!/bin/bash

gconftool-2 -s '/apps/metacity/general/compositing_manager' --type bool false
xbmc
gconftool-2 -s '/apps/metacity/general/compositing_manager' --type bool true
