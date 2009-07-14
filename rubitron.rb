require "rubygems"
require "rubygame"
require "lib/controller.rb"
require "lib/setup.rb"

include Rubygame

TTF.setup
setup = Setup.new()
setup.run()
