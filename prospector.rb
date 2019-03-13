# Zoinks!
class Prospector
  GOLDVAL = 20.67
  SILVERVAL = 1.31
  def initialize
    @goldcounter = 0
    @silvercounter = 0
    @totalhaul = 0
  end

  # adds gold to goldcounter and returns the new value
  def add_gold(gold)
    @goldcounter += gold
    @goldcounter
  end

  def gold
    @goldcounter
  end

  # adds silver to the silvercounter and returns the new value
  def add_silver(silver)
    @silvercounter += silver
    @silvercounter
  end

  def silver
    @silvercounter
  end

  # calulates the total haul in dollars and returns the value
  def haul
    @totalhaul = @silvercounter * SILVERVAL + @goldcounter * GOLDVAL
    @totalhaul
  end
end
