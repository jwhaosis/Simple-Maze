require_relative "../Models/message.rb"

class MazeGenerator

  #initializes with a maze
  def initialize maze
    @old_maze = maze
    @size = @old_maze.size
    @old_string = @old_maze.save.gsub /0/, "1"
    @old_string.strip!
    @maze = Maze.new
    @maze.load @old_string, (@old_maze.width-1)/2, (@old_maze.height-1)/2, true
    @rooms = Array.new
  end

  #method to return a redesigned maze
  def redesign
    new_maze = Maze.new
    #continues until it gets a valid maze
    while !new_maze.loaded?
      new_maze = self.create_minimum
      string = new_maze.save
      string.strip!
      #tries to load the maze
      new_maze.load string, (@old_maze.width-1)/2, (@old_maze.height-1)/2
      #resets the maze full of walls if it is needed again
      @maze = Maze.new
      @maze.load @old_string, (@old_maze.width-1)/2, (@old_maze.height-1)/2, true
    end
    new_maze
  end

  #method to create the minimum number of floors in a maze (smallest size)
  def create_minimum
    for y in 0...@maze.height
      for x in 0...@maze.width
        tile = @maze.get_tile(x,y)
        if tile.is_room
          @rooms.push tile
          tile.type = 0
          @maze.size+=1
          self.create_connection tile
        end
      end
    end

    #populates the maze until it reaches the given maze's size
    while @maze.size<@size
      self.create_connection @rooms.sample
    end

    #if it somehow goes over the given maze size just redesign it again, I don't think this gets hit but it's here incase my algorithm is screwy
    if @maze.size>@size
      @maze = Maze.new
      @maze.load @old_string, (@old_maze.width-1)/2, (@old_maze.height-1)/2, true
    end

    @maze
  end

  #creates a connection between two rooms
  def create_connection tile
    walls = @maze.get_adjacent_walls tile
    if walls.length>0
      @maze.size+=1
      walls.sample.type = 0
    end
  end

end
