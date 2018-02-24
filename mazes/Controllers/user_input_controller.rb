require_relative "../Models/maze.rb"
require_relative "../Models/message.rb"

class UserInputController
  #creates a new maze once instantiated
  def initialize
    @maze = Maze.new
  end

  #accessor for testing purposes
  def get_maze
    @maze
  end

  #prints out commands
  def help input_params=[]
    return print Message.Params "0", input_params.length if input_params.length != 0
    puts "
    Load: This command must be run before using any other commands. (load mazestring [width] [length])
    Save: Prints out the maze string of a currently loaded maze. (save)
    Display: Displays the currently loaded maze. (display)
    Solve: Checks to see if an ending coordinate is reachable from a given starting coordinate. (solve begX begY endX endY)
    Trace: Traces the path to get from a beginning coordinate to an ending coordinate. (trace begX begY endX endY)
    Exit: Exits the maze shell. (exit)"
    false
  end

  #loads a string into a maze
  def load input_params=[]
    return print Message.Params "1 or 3", input_params.length if input_params.length != 1 && input_params.length != 3
    if @maze.loaded?
      print Message.Overwrite
      user_input = gets.chomp
      if user_input.downcase == "y"
        @maze = Maze.new
      else
        return false
      end
    end
    if input_params.length == 3
      print @maze.load input_params[0], input_params[1].to_i, input_params[2].to_i
    else
      print @maze.load input_params[0]
    end
    false
  end

  #saves the maze as a text string
  def save input_params=[]
    return print Message.Mazeless if !@maze.loaded?
    return print Message.Params "0", input_params.length if input_params.length != 0
    print @maze.save
    false
  end

  #displays the maze
  def display input_params=[]
    return print Message.Mazeless if !@maze.loaded?
    return print Message.Params "0", input_params.length if input_params.length != 0
    print @maze.display
    false
  end

  #solves the maze
  def solve input_params=[]
    return print Message.Mazeless if !@maze.loaded?
    return print Message.Params "4", input_params.length if input_params.length != 4
    print @maze.solve @maze.get_tile(input_params[0].to_i, input_params[1].to_i), @maze.get_tile(input_params[2].to_i, input_params[3].to_i)
    false
  end

  #traces the maze
  def trace input_params=[]
    return print Message.Mazeless if !@maze.loaded?
    return print Message.Params "4", input_params.length if input_params.length != 4
    path = @maze.trace @maze.get_tile(input_params[0].to_i, input_params[1].to_i), @maze.get_tile(input_params[2].to_i, input_params[3].to_i)
    if path.class == "string".class
      print path
    else
      print @maze.display path
    end
    false
  end

  #redesigns the maze
  def redesign input_params=[]
    return print Message.Mazeless if !@maze.loaded?
    return print Message.Params "0", input_params.length if input_params.length != 0
    @maze = @maze.redesign
    false
  end
  #exits the loop
  def exit input_params=[]
    print Message.Exit
    true
  end
end
