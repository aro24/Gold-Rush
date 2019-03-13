require_relative 'prospector.rb'
require_relative 'node.rb'

# the actual gold rush logic and visuals
class Game
  # initializes the map of the game
  def initmap
    local = {}
    local['Sutter Creek'] = Node.new 'Sutter Creek', 0, 2
    local['Angels Camp'] = Node.new 'Angels Camp', 0, 4
    local['Nevada City'] = Node.new 'Nevada City', 0, 5
    local['Coloma'] = Node.new 'Coloma', 0, 3
    local['Virginia City'] = Node.new 'Virginia City', 3, 3
    local['Midas'] = Node.new 'Midas', 5, 0
    local['El Dorado'] = Node.new 'El Dorado', 10, 0

    # Hard coding neighbors into each node's neighbors array
    local['Sutter Creek'].add_neighbors ['Angels Camp', 'Coloma']
    local['Angels Camp'].add_neighbors ['Nevada City', 'Virginia City']
    local['Nevada City'].add_neighbors ['Angels Camp']
    local['Coloma'].add_neighbors ['Virginia City', 'Sutter Creek']
    local['Virginia City'].add_neighbors ['Angels Camp', 'Coloma', 'Midas', 'El Dorado']
    local['Midas'].add_neighbors ['Virginia City', 'El Dorado']
    local['El Dorado'].add_neighbors ['Virginia City', 'Midas']
    local
  end

  def initialize(args)
    @seed = args[0].to_i
    @rando = Random.new(@seed)
    @prospectors = Array.new(args[1].to_i)
    (0...args[1].to_i).each do |i|
      @prospectors[i] = Prospector.new
    end
    @locations = initmap
  end

  # prints the start of a new prospector round
  def print_start(prospectornum)
    puts "\nProspector " + (prospectornum + 1).to_s + ' starting in Sutter Creek.'
  end

  # prints information of the days
  def print_round(gold, silver, location)
    strloc = ' in ' + location + '.'
    results = ''
    if gold == 1
      results = "\tFound " + gold.to_s + ' ounce of gold'
      if silver == 1
        results = results + ' and ' + silver.to_s + ' ounce of silver'
      elsif silver > 1
        results = results + ' and ' + silver.to_s + ' ounces of silver'
      end
    elsif gold > 1
      results = "\tFound " + gold.to_s + ' ounces of gold'
      if silver == 1
        results = results + ' and ' + silver.to_s + ' ounce of silver'
      elsif silver > 1
        results = results + ' and ' + silver.to_s + ' ounces of silver'
      end
    elsif gold.zero? && silver == 1
      results = "\tFound " + silver.to_s + ' ounce of silver'
    elsif gold.zero? && silver > 1
      results = "\tFound " + silver.to_s + ' ounces of silver'
    else
      results = "\tNo precious metals found"

    end
    str = results + strloc
    puts str
    str
  end

  # prints the message when a prospector moves
  def print_move(gold, silver, curloc, nextloc)
    move = 'Heading from ' + curloc + ' to ' + nextloc + ', holding '
    goldhaul = ''
    silverhaul = ''
    goldhaul = if gold == 1
                 goldhaul + gold.to_s + ' ounce of gold and '
               else
                 goldhaul + gold.to_s + ' ounces of gold and '
               end

    silverhaul = if silver == 1
                   silverhaul + silver.to_s + ' ounce of silver.'
                 else
                   silverhaul + silver.to_s + ' ounces of silver.'
                 end
    str = move + goldhaul + silverhaul
    puts str
    str
  end

  # prints the final total the prospector has
  def print_final(days, prospectornum, prospector, gold, silver)
    puts 'After ' + days.to_s + ' days, Prospector #' + prospectornum.to_s + ' returned to San Francisco with:'
    finalstr = 'After ' + days.to_s + ' days, Prospector #' + prospectornum.to_s + " returned to San Francisco with:\n"
    if gold == 1
      finalstr = finalstr + "\t" + gold.to_s + " ounce of gold.\n"
      puts "\t" + gold.to_s + ' ounce of gold.'
    else
      finalstr = finalstr + "\t" + gold.to_s + " ounces of gold.\n"
      puts "\t" + gold.to_s + ' ounces of gold.'
    end

    if silver == 1
      finalstr = finalstr + "\t" + silver.to_s + " ounce of silver.\n"
      puts "\t" + silver.to_s + ' ounce of silver.'
    else
      finalstr = finalstr + "\t" + silver.to_s + " ounces of silver.\n"
      puts "\t" + silver.to_s + ' ounces of silver.'
    end
    finalstr = finalstr + "\tHeading home with $" + prospector.haul.to_s
    puts "\tHeading home with $" + prospector.haul.round(2).to_s
    finalstr
  end

  # generates a random number based on a location's max values
  def rand(random, max)
    # where max is the max amount you can find for the curLocation
    random.rand(0..max)
  end

  # increments a prospector's gold and silver counters
  def addmetals(prospector, gold, silver)
    prospector.add_gold(gold)
    prospector.add_silver(silver)
  end

  # the main logic of the game
  def play
    # repeat this loop (# of Prospectors) times
    (0...@prospectors.count).each do |i|
      find = true
      count = 1
      days = 0
      curlocation = 'Sutter Creek'
      print_start i
      # while find is true, Prospector is still finding gold/silver and will stay at curLocation
      # (for first three locations)
      while count < 6

        # access rand num 0 and location.maxgold
        goldrand = rand(@rando, @locations[curlocation].max_gold)

        # access rand num 0 and location.maxsilver
        silverrand = rand(@rando, @locations[curlocation].max_silver)
        addmetals(@prospectors[i], goldrand, silverrand)

        # prospecting for the day is complete
        days += 1

        # print day's results
        print_round(goldrand, silverrand, @locations[curlocation].id)

        # if prospector doesn't find loot, move on to next location
        if goldrand.zero? && silverrand.zero? && find == true
          # if 3 locations have already been visited set find to false, directing to elsif next iterations
          find = false if count == 3
          count += 1
          # generate next location
          nextlocation = @locations[@locations[curlocation].next_location @rando]

          print_move(@prospectors[i].gold, @prospectors[i].silver, curlocation, nextlocation.id)
          # accesses next_location method in Node
          curlocation = nextlocation.id

        elsif find == false && goldrand < 2 && silverrand < 3
          count += 1
          # generate next location
          nextlocation = @locations[@locations[curlocation].next_location @rando]

          print_move(@prospectors[i].gold, @prospectors[i].silver, curlocation, nextlocation.id) unless count == 6
          # accesses next_location method in Node
          curlocation = nextlocation.id
        end
      end

      # print final results with prospector[i]
      print_final(days, i + 1, @prospectors[i], @prospectors[i].gold, @prospectors[i].silver)
      # for-loop end
    end
    # this is the end of play
  end
end
