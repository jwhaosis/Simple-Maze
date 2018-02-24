require 'minitest/autorun'
require "../Models/message.rb"
require "../Views/user_input_loop.rb"

describe "User Input Tests" do

  before do
    @loop = UserInputLoop.new
    @controller = @loop.get_controller
  end

  it "recognizes invalid commands" do
    assert_output Message.Unrecognized do
      @loop.parse("Invalid Command")
    end
  end

  it "does not allow load to have no inputs" do
    assert_output Message.Params "1 or 3", "0" do
      @loop.parse("load")
    end
  end

  it "does not allow load to have the wrong number of inputs" do
    assert_output Message.Params "1 or 3", "2" do
      @loop.parse("load not right")
    end
  end

  it "does load 4x4 mazes without parameters" do
    assert_output Message.Loaded do
      @loop.parse("load 111111111100010001111010101100010101101110101100000101111011101100000101111111111")
    end
  end

  it "does load mazes with width and height" do
    assert_output Message.Loaded do
      @loop.parse("load 111111111100010001111010101100010101101110101100000101111011101100000101111111111 4 4")
    end
  end

  it "does not load mazes with wrong width and/or height" do
    assert_output Message.MazeInvalid do
      @loop.parse("load 111111111100010001111010101100010101101110101100000101111011101100000101111111111 1 2")
    end
  end

  it "does not load invalid mazes" do
    assert_output Message.MazeInvalid do
      @loop.parse("load 111111111100110001111010101100010101101110101100000101111011101100000101111111111")
    end
  end

  it "does save mazes" do
    @controller.get_maze.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
    assert_output @controller.get_maze.save do
      @loop.parse("save")
    end
  end

  it "does not save unloaded mazes" do
    assert_output Message.Mazeless do
      @loop.parse("save")
    end
  end

  it "does display mazes" do
    @controller.get_maze.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
    assert_output @controller.get_maze.display do
      @loop.parse("display")
    end
  end

  it "does not display unloaded mazes" do
    assert_output Message.Mazeless do
      @loop.parse("display")
    end
  end

  it "does solve mazes with valid paths" do
    @controller.get_maze.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
    assert_output @controller.get_maze.solve(@controller.get_maze.get_tile(1,1), @controller.get_maze.get_tile(7,7)) do
      @loop.parse("solve 1 1 7 7")
    end
  end

  #it "does recognize mazes with invalid paths" do
  #  @controller.get_maze.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
  #  assert_output @controller.get_maze.solve(@controller.get_maze.get_tile(1,1), @controller.get_maze.get_tile(0,0)) do
  #    @loop.parse("solve 1 1 0 0")
  #  end
  #end

  it "does not solve unloaded mazes" do
    assert_output Message.Mazeless do
      @loop.parse("solve 1 1 7 7")
    end
  end

  it "does trace mazes with valid paths" do
    @controller.get_maze.load "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
    assert_output @controller.get_maze.display(@controller.get_maze.trace(@controller.get_maze.get_tile(1,1), @controller.get_maze.get_tile(7,7))) do
      @loop.parse("trace 1 1 7 7")
    end
  end

  it "does not trace unloaded mazes" do
    assert_output Message.Mazeless do
      @loop.parse("trace 1 1 7 7")
    end
  end

  it "does exit" do
    assert_output Message.Exit do
      @loop.parse("exit")
    end
  end


end
