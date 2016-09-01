#!/usr/bin/ruby

      #########.
     ########",#:
   #########',##".
  ##'##'## .##',##.
   ## ## ## # ##",#.
    ## ## ## ## ##'
     ## ## ## :##
      ## ## ##."

$__HELLO_DIR__ = File.dirname(
  File.symlink?(__FILE__) ?
    File.readlink(__FILE__) : __FILE__)

@command = ARGV.shift

case @command
when nil
  puts "Hello v0.0.1 alpha
Usage: hello <subcommand> ...

Subcommands:
    install <package>         Install a package from GitHub
    uninstall <package>       Remove package from session
    start                     Start Hello service
    stop                      Stop Hello service
    reload                    Reload Hello service"

when '--version'
  puts 'Hello v0.0.1 alpha'

when 'install'
  package = ARGV.shift
  repo = 'https://github.com/' + package
  install_dir = File.join($__HELLO_DIR__, 'packages', package.gsub(/[^a-zA-Z\-_0-9]/, '_'))
  `mkdir -p #{File.join($__HELLO_DIR__, 'packages')}`
  `git clone #{repo} #{install_dir}`

when 'uninstall'
  package = ARGV.shift
  repo = 'https://github.com/' + package
  install_dir = File.join($__HELLO_DIR__, 'packages', package.gsub(/[^a-zA-Z\-_0-9]/, '_'))
  `rm -rf install_dir`

when 'reload'
  `launchctl unload ~/Library/LaunchAgents/io.kube.hello.plist`
  `launchctl load ~/Library/LaunchAgents/io.kube.hello.plist`

when 'start'
  `launchctl load ~/Library/LaunchAgents/io.kube.hello.plist`

when 'stop'
  `launchctl unload ~/Library/LaunchAgents/io.kube.hello.plist`

else
  puts 'Unknown command'
end
