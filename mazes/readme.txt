My implementation for PA-Mazes is organized into 3 major folders (plus a tests folder).


The lone file mazes.rb is there to create the object that manages the loop and make my program executable from the command line without extra pathing.


The folder titled "Views" contains a single class, user_input_loop.rb which manages the looping and parsing for user commands. 
	This is almost the exact same as the implementation in PA-IMS with some reduced error checking due to the nature of these inputs.
	I have opted to not check the parameter input types (char,string,int,ect.) this time around because we already did it last PA and I feel like it is a waste of time to do such detailed user input checking.
	The parse function sends the command to the class housed in user_input_controller.rb.
	
	
The folder titled "Controllers" also contains a single class, the aformentioned user_input_controller.rb which takes the string and formats the input so that the class in mazes.rb can use it.
	This is again a very similar implementation to the one in PA-IMS. I have cleaned up some of the error checking.
	All output prints occur in this class.
	Returns false to continue the loop or true to end the loop in user_input_loop.rb.
	Also contains an extra command "help" which prints out the formats for each command and what they do.
	
	
The folder titled "Models" has many files which I will go through one by one here, the majority of my implementation specific to this assignment is in here.
	The simplest file is messages.rb, it is a class that I use to manage my message printouts throughout my program.
	
	The main file in this folder is maze.rb which contains my implementation of the Maze class, it represents the maze as a 2D array of tile objects (found in tile.rb).
		It defaults the map size to 4x4 (the one given in the example)
		The 2D array is actually twice each dimension+1 to represent the walls as well
		I have added an extra method "save" which turns the map to a string. This is here for the mazes created by redesign.
		Instead of using x and y coordinates as inputs for solve and trace I use my tile class, functionality is the same and the inputs are converted in the user_input_controller.rb class.
		I have added a few helper methods at the bottom to take care of some extra things I needed to in my other functions.
		
	The supporting file as mentioned many times is tile.rb, it is an object that contains a type (0/floor or 1/wall), x and y coordinates, and a path which is used for the trace function
		The way trace works is that each tile contains an array (@path) with all the other tiles that came before it, including the starting tile. This way once I hit the end tile I can just return its @path.
		
	The three helper classes I have are maze_evaluator.rb, maze_generator.rb, and maze_solver.rb
		maze_evaluator is a very simple class that has only class methods, all it does is check if a maze is valid.
			It checks 2 things per tile, first if it is a room it must be a floor, and second if it is a floor it must not be surrounded by all floors or walls.
			
		maze_generator generates a maze with the same number of open tiles given an already loaded maze.
			The generation algorithm is to populate each room with a floor tile and then create 1 non-overlapping connection per room.
			This will give us the least possible number of floors (highest number of walls). We will then keep making connections until we have the right number of rooms.
			
		maze_solver manages the heavy lifting of solve and trace in the maze class.
			solve creates an array of all floor tiles and keeps it as a variable. Whenever it is called it checks if both tiles are contained in the array, if so then there must be a path.
			trace is slightly more complicated, it uses the idea of dijkstra's algorithm and checks all tiles at distance 1, then distance 2, and so on and so forth, ignoring any that have already been hit.
