
#helper class to standardize message outputs
class Message
  def self.Params expected, given
    "Error: Wrong number of parameters given (Expected #{expected}, given #{given})."
  end

  def self.Unrecognized
    "Error: Command not recognized.\n"
  end

  def self.Mazeless
    "Error: No maze has been loaded yet.\n"
  end

  def self.MazeInvalid
    "Error: The given maze is invalid.\n"
  end

  def self.TileInvalid
    "Error: The given tile is out of range.\n"
  end

  def self.Exit
    "Exiting the maze shell.\n"
  end

  def self.Overwrite
    "A maze is currently loaded, would you like to overwrite it? (Y/N) "
  end

  def self.Loaded
    "Your maze has been successfully loaded.\n"
  end
end
