#!/bin/bash

# resize the terminal
printf "\033[8;3;50t"  # Resize to 3 lines tall
ssh bandit.labs.overthewire.org -p 2220 -l bandit26 -i ssh_bandit26.key 
