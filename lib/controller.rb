class Player
	include Rubygame::EventHandler::HasEventHandler
	attr_reader :queue, :screen, :x, :y
	attr_accessor :queue, :screen, :x, :y
	def initialize screen
		@screen = screen
		@queue = Rubygame::EventQueue.new()
		@queue.enable_new_style_events()
		@player_1_img = Surface.load("graphics/player_ship.png")
	    @x = 150
		@y = 400
		@font = TTF.new("data/Welbut__.ttf",18)
		@text_str = "Player: " + "#{@x}" + ", " + "#{@y}"
		@text = @font.render(@text_str,false,[214,214,214])
	end
	
	def right
	    @x += 5
	end
	
	def left
		puts 'left key hit!'
		@x -= 5
	end
	
	def move		
		@queue.each do |event|
		    handle(event)
		end
	end
		
	def movement_hook
		movement_hooks = {
		:left => :left,
		:right => :right,
		}
		make_magic_hooks(movement_hooks)
	end	
		
	def draw
		@player_1_img.blit(@screen,[@x,@y])
		@text.blit(@screen, [10,10])
		@screen.flip()
	end
end
		
class Controller
    include Rubygame::EventHandler::HasEventHandler
    def initialize screen
		@screen = screen
		@queue = Rubygame::EventQueue.new()
		@queue.enable_new_style_events()
		@clock = Rubygame::Clock.new()
		@clock.target_framerate = 30
		@background = Surface.load("graphics/level_1_bg.png")
		@p1 = Player.new(@screen)
	end
  
	def hook_quit
		quit_hooks = {
		:escape => :quit,
		Rubygame::Events::QuitRequested => :quit
		}
		make_magic_hooks(quit_hooks)
	end
  
    def fps_update()
        @screen.title = "FPS: #{@clock.framerate()}" 
    end
  
	def run
		@p1.movement_hook()
		hook_quit()
		loop do
			@queue.each do |event|
				#puts "This is the controller."
				handle(event)
			end
			@p1.move()
			fps_update()
			@background.blit(@screen,[0,0])
			@p1.draw()
			@screen.flip()
			@clock.tick()
		end
	end
  
	def quit
		Rubygame.quit()
		exit
	end
end
