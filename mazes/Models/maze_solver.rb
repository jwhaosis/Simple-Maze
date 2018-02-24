require_relative "maze.rb"
require_relative "tile.rb"

#helper class that contains methods needed to solve a maze
class MazeSolver

  #initializes with a maze
  def initialize maze
    @maze = maze
    @tiles = Array.new
  end

  #the body of the solve method from maze.rb, checks if a tile is reachable
  def reachable? begTile, endTile
    x = begTile.x
    y = begTile.y
    self.move_one begTile if @tiles.empty?
    return @tiles.include? endTile
  end

  #moves a single tile from the given tile, if it is a floor adds it to the tiles array
  def move_one begTile
    @maze.get_adjacent_tiles(begTile).each do |tile|
      if (tile.is_floor) && (!@tiles.include? tile)
        @tiles.push tile
        self.move_one tile
      end
    end
  end

  #accessor for all reachable tiles
  def reachable_tiles
    @tiles
  end

  #the body of the trace method from maze.rb, checks for the shortest path
  def pathfind begTile, endTile
    @traveled_tiles = [begTile]
    @current_tiles = [begTile]
    @next_tiles = Array.new
    #iterate through the maze one movement at a time, hard stop when all tiles have been exhausted
    while (!@current_tiles.include? endTile) && @traveled_tiles.length < @maze.size
      @current_tiles.each do |tile|
        (get_adjacent_floors tile).each do |next_tile|
          #makes sure no tiles are double counted, the first to hit will always be the shortest
          if (next_tile.is_floor) && (!@next_tiles.include? next_tile) && (!@traveled_tiles.include? next_tile)
            @next_tiles.push next_tile
            next_tile.previous_tile tile
          end
        end
      end
      @traveled_tiles.concat @next_tiles
      @current_tiles = @next_tiles.dup
      @next_tiles.clear
    end
    endTile.get_path
  end

  #method to get all adjacent floor tiles to a given tile
  def get_adjacent_floors tile
    floors = Array.new
    @maze.get_adjacent_tiles(tile).each do |tile|
      floors.push tile if tile.is_floor
    end
    floors
  end

end
