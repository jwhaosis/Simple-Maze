require_relative "maze_evaluator.rb"
require_relative "maze_generator.rb"
require_relative "maze_solver.rb"
require_relative "tile.rb"
require_relative "../Models/message.rb"

#main class for pa-mazes, contains the representation of the maze in a psuedo 2D array
class Maze

  attr_accessor :grid, :height, :width, :size

  #initialize method, width and height are set to 4 by default (the given map). The size of an unloaded map is -1.
  def initialize
    @width = -1
    @height = -1
    @grid = Array.new
    @size = -1
  end

  #load method to turn a string into a maze
  def load maze_string, width=4, height=4, overwrite = false
    @width = 1+width*2
    @height = 1+height*2
    maze_array = maze_string.chars
    return Message.MazeInvalid if maze_array.length != @width*@height
    @size = maze_string.count("0")
    #effectively a 2D array
    for y in 0...@height
      @grid[y] = Array.new
      for x in 0...@width
        @grid[y][x] = Tile.new maze_array[x+(y*@width)], x, y
      end
    end
    #ignores the check if I am trying to populate a maze full of walls from maze_generator
    if !overwrite
      @solver = MazeSolver.new self
      if !MazeEvaluator.validate_maze self, @solver
        @grid.clear
        @width = -1
        @height = -1
        @size = -1
        return Message.MazeInvalid
      end
    end
    Message.Loaded
  end

  #extra method to turn the maze into string form, opposite of load
  def save
    maze_string = ""
    for y in 0...@height
      for x in 0...@width
        maze_string += self.get_tile(x,y).type.to_s
      end
    end
    maze_string+="\n"
  end

  #displays the map, if given an array it fills in any tiles that are shared using a 0
  def display path_array = []
    display_string = ""
    for y in 0...@height
      for x in 0...@width
        if self.get_tile(x,y).is_floor
          if path_array.include? self.get_tile(x,y)
            display_string += "0"
          else
            display_string += " "
          end
        else
          display_string += "*"
        end
      end
      display_string += "\n"
    end
    display_string
  end

  #solves the maze given a beginning and ending tile
  def solve begTile, endTile
    if @solver.reachable? begTile, endTile
      "There is a valid path between #{begTile} and #{endTile}.\n"
    else
      "There is not a valid path between #{begTile} and #{endTile}.\n"
    end
  end

  #traces the path of a solved maze given a beginning and ending tile
  def trace begTile, endTile
    check_valid = self.solve begTile, endTile
    return check_valid if (check_valid.include? ("not"))
    path = (@solver.pathfind begTile, endTile).dup
    self.clear
    path
  end

  #redesigns the maze, keeps the size constant
  def redesign
    @generator = MazeGenerator.new self
    @generator.redesign
  end

  #method to get a tile at an x and y coordinate, prints out an error message if out of bounds
  def get_tile x, y
    if(x<0 || y<0 || x>=@width || y>=@height)
      print Message.TileInvalid
      return
    end
    @grid[y][x]
  end

  #method to get all adjacent tiles of a given tile
  def get_adjacent_tiles tile
    x = tile.x
    y = tile.y
    [self.get_tile(x,y+1), self.get_tile(x+1,y), self.get_tile(x,y-1), self.get_tile(x-1,y)]
  end

  #method to get all adjacent walls that are not bounds of a given tile
  def get_adjacent_walls tile
    adjacent_tiles = self.get_adjacent_tiles tile
    invalid_tiles = Array.new
    adjacent_tiles.each do |adj_tile|
      if (adj_tile.is_floor || adj_tile.x==0 || adj_tile.y==0 || adj_tile.x==@width-1 || adj_tile.y==@height-1)
        invalid_tiles.push adj_tile
      end
    end
    adjacent_tiles-invalid_tiles
  end

  #method to clear the paths of all tiles in the map
  def clear
    for x in 0...@width
      for y in 0...@height
        self.get_tile(x, y).clear_path
      end
    end
  end

  #method to check if the map is loaded or not
  def loaded?
    @size != -1
  end
end
