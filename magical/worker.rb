#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/config/environment'
Rails.logger('Loaded the environment')

# Callback called when you run `supervisorctl stop'
def sigterm_handler
    warn "Program ending"
    exit
end


def main
  Rails.logger('About to start the worker')  
  Delayed::Worker.new.start
  # The code below can help with debuggin
  # while true do
  #     # warn "Tick"
  #     puts "Tick"
  #     sleep 1
  # end
end

# Bind our callback to the SIGTERM signal
Signal.trap("TERM") { sigterm_handler }

# and run the daemon:
main