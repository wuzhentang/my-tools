#!/bin/bash
# https://www.jianshu.com/p/9020a13152eb
sudo sed -i 's/XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/g' /etc/default/keyboard
sudo dpkg-reconfigure keyboard-configuration
