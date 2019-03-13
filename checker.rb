# checks to see if given input is valid
class Checker
  def initialize; end

  # checks arguments to ensure that 2 integers are passed
  def check_args(args)
    args.count == 2 && args[0].to_i > 0 && args[1].to_i > 0
  rescue StandardError
    false
  end

  # prints out instructions to properly run gold_rush.rb
  def show_usage_and_exit
    puts 'Usage:'
    puts 'ruby gold_rush.rb'
    puts 'Arguments should be two valid integers'
    exit 1
  end
end
