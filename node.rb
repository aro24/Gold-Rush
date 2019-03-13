# Class contains all location data required for locations
class Node
  attr_reader :neighbors

  attr_reader :id

  attr_reader :max_silver

  attr_reader :max_gold

  # returns the neighbor at index num
  def neighbor(num)
    @neighbors[num]
  end

  def num_neighbors
    @neighbors.count
  end

  # returns true if node has no neighbors; false otherwise
  def alone?
    @neighbors.count.zero?
  end

  # returns true if the node has neighbors; false otherwise
  def connected?
    @neighbors.count.nonzero?
  end

  # sets @neigbors to neighbors_arr
  def add_neighbors(neighbors_arr)
    @neighbors = neighbors_arr
  end

  def initialize(id, max_silver, max_gold)
    @id = id
    @max_silver = max_silver
    @max_gold = max_gold
    @neighbors = []
  end

  # returns a random neighbor based on the random object passed in
  def next_location(rando)
    random = Random.new(rando.seed)
    @neighbors[random.rand(0...@neighbors.count)]
  end
end
