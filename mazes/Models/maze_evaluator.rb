require_relative "maze.rb"
require_relative "tile.rb"

#helper class to evaluate if a maze is valid
class MazeEvaluator

  #method to validate a maze, able to be called without instantiation
  def self.validate_maze maze, solver
    valid_tiles = Array.new
    for y in 1...maze.height
      for x in 1...maze.width
        tile = maze.get_tile(x,y)
        if tile.is_room
          return false if tile.type!=0
        end
        if tile.is_floor
          return false if !self.tile_valid? tile, maze
          valid_tiles.push tile
        end
      end
    end
    #populate the list of reachable tiles
    solver.reachable? valid_tiles[0], valid_tiles[0]
    solver.reachable_tiles.length == valid_tiles.length
  end

  #checks to see if a tile is valid based on the given criteria
  def self.tile_valid? tile, maze
    counter = 0
    adjacent_tiles = maze.get_adjacent_tiles tile
    adjacent_tiles.each do |tile|
      counter+=1 if !tile.is_floor
    end
    counter != 0 && counter != 4
  end
end
