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

# Create bin directory
mkdir -p $DIR/bin
ln -sf $DIR/cli.rb $DIR/bin/hello

# Modify .zprofile to source launchd PATH
cat > $HOME/.zprofile <<EOL

# Source PATH from launchd
export PATH=\$PATH:\`launchctl getenv PATH\`

EOL

echo "Hello is installed!"
