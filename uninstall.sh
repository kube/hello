#!/bin/sh

      #########.
     ########",#:
   #########',##".
  ##'##'## .##',##.
   ## ## ## # ##",#.
    ## ## ## ## ##'
     ## ## ## :##
      ## ## ##."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLIST=io.kube.hello.plist

# Unload Hello agent
launchctl unload ~/Library/LaunchAgents/$PLIST

# Remove .plist and Hello directory
rm -f ~/Library/LaunchAgents/$PLIST
rm -f $DIR

echo "Uninstalled Hello."
