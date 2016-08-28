#!/usr/bin/ruby

      #########.
     ########",#:
   #########',##".
  ##'##'## .##',##.
   ## ## ## # ##",#.
    ## ## ## ## ##'
     ## ## ## :##
      ## ## ##."

def login_hook
  # Login
  `echo Hello >> $HOME/Desktop/hello`
end

def logout_hook
  # Logout
  `echo Goodbye >> $HOME/Desktop/goodbye`
  exit
end

def tick_hook
  # Tick
end


login_hook
%w{ INT HUP TERM }.each do |s| Signal.trap(s, :logout_hook) end

loop do
  tick_hook
  sleep 1
end
