require 'minitest/autorun'
require "../Models/message.rb"
require "../Views/user_input_loop.rb"

describe "Maze Tests" do

  before do
    @loop = UserInputLoop.new
    @controller = @loop.get_controller
    @maze = @controller.get_maze
    @maze.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
  end

  it "does not retreive invalid tiles" do
    assert_output Message.TileInvalid do
      @maze.get_tile(-1,-1)
    end
  end

  it "does not solve mazes with invalid paths" do
    assert_output @maze.solve(@maze.get_tile(1,1), @maze.get_tile(0,0)) do
      @loop.parse("solve 1 1 0 0")
    end
  end

  it "does not trace mazes with invalid paths" do
    assert_output @maze.trace(@maze.get_tile(1,1), @maze.get_tile(0,0)) do
      @loop.parse("trace 1 1 0 0")
    end
  end


end
