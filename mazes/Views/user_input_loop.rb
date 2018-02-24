require_relative "../Controllers/user_input_controller.rb"
require_relative "../Models/message.rb"

#class to loop and ask for user input
class UserInputLoop

  #sets valid inputs, adds a controller to interface between this and the maze.rb class
  def initialize
    @valid_inputs = ["help", "load", "save", "display", "solve", "trace", "redesign", "exit"]
    @controller = UserInputController.new
  end

  #accessor for testing purposes
  def get_controller
    @controller
  end

  #starts the loop
  def start
    end_loop = false
    #i use false as continue so that i can return puts statements (nil is equivalent to false) instead of having extra lines of return true after the puts in the controller
    while(!end_loop)
      print "\nmazes> "
      user_input = gets.chomp
      end_loop = self.parse user_input if !user_input.nil?
    end
  end

  #parses commands to make sure they are valid
  def parse user_input
    input_array = user_input.split(" ")
    input_command = input_array[0].downcase if !input_array[0].nil?
    if @valid_inputs.include? input_command
        input_params = input_array[1..-1]
        #sends the command with whatever inputs were given
        @controller.public_send(input_command, input_params)
    else
      return print Message.Unrecognized
    end
  end
end
