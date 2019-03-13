require_relative 'game.rb'
require_relative 'checker.rb'

# EXECUTION STARTS
check = Checker.new
# plays the game if passed in arguments are valid, quits otherwise
if check.check_args(ARGV)
  g = Game.new ARGV
  g.play
else
  check.show_usage_and_exit
end
