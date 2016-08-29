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

# Set correct directory in .plist and place it in LaunchAgents
sed s:{{HELLO_DIR}}:$DIR:g $DIR/$PLIST > ~/Library/LaunchAgents/$PLIST

# Load Hello agent
launchctl load ~/Library/LaunchAgents/$PLIST

echo "Hello is installed!"
