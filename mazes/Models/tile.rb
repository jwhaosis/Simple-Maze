
#representation of tiles in the maze, stores path information
class Tile

  attr_accessor :x, :y, :type

  #tiles have a location, a type, and a path to reach
  def initialize type, x, y
    @type = type.to_i
    @x = x
    @y = y
    @path = [self]
  end

  #checks to see if a tile is a floor or not
  def is_floor
    @type == 0
  end

  #checks to see if a tile is a room or not
  def is_room
    @x%2!=0 && @y%2!=0
  end

  #for printouts
  def to_s
    "(#{x}, #{y})"
  end

  #returns path
  def get_path
    @path
  end

  #sets the previous tile of this tile and the path it took to get there
  def previous_tile tile
    @path.concat tile.get_path
  end

  #clears the path once trace is done
  def clear_path
    @path = [self]
  end
end
