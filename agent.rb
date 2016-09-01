#!/usr/bin/ruby

      #########.
     ########",#:
   #########',##".
  ##'##'## .##',##.
   ## ## ## # ##",#.
    ## ## ## ## ##'
     ## ## ## :##
      ## ## ##."

require 'yaml'

$__HELLO_DIR__ = File.dirname(
  File.symlink?(__FILE__) ?
    File.readlink(__FILE__) : __FILE__)

@background_tasks = []

# Get packages sorted by priority
def packages
  Dir[File.join($__HELLO_DIR__, 'packages/*/*.yml')]
    .map do |yml|
      info = YAML.load File.read yml
      info['dir'] = File.dirname yml if info
      info
    end
    .select {|p| p }
    .sort_by {|p| p['priority'] || 10 }
end

# Load initial PATH from shell
def set_initial_path
  `echo $PATH`.split(':').each do |path|
    add_env_path path
  end
end

# Add path to env PATH without duplication
def add_env_path path
  paths = `/bin/launchctl getenv PATH`.chomp.split(':').unshift(path).uniq * ':'
  `/bin/launchctl setenv PATH #{paths}`

  ENV['PATH'] = ENV['PATH'].chomp.split(':').unshift(path).uniq * ':'
end

def start_background_task package
  pid = Process.spawn File.join(package['dir'], package['background'])
  @background_tasks << pid
end

def kill_background_tasks
  @background_tasks.each do |pid|
    Process.kill('INT', pid)
  end
end

def login_hook
  # Load initial PATH from shell
  set_initial_path

  # Set PATH before launching other scripts
  # /usr/local/bin is where Homebrew stores binaries
  add_env_path '/usr/local/bin'

  # Add hello/bin to PATH
  add_env_path File.expand_path File.join($__HELLO_DIR__, 'bin/')

  # Load packages on_login hooks and background tasks
  packages.each do |package|
    system package['on_login'] if package['on_login']
    start_background_task package if package['background']
  end
end

def logout_hook
  kill_background_tasks

  packages.each do |p|
    system p['on_logout'] if p['on_logout']
  end

  exit
end

def tick_hook
end


login_hook
['INT', 'HUP', 'TERM'].each do |s|
  Signal.trap(s, :logout_hook)
end


loop do
  tick_hook
  sleep 1
end
