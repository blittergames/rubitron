class Player
	include Rubygame::EventHandler::HasEventHandler
	def initialize screen
		@screen = screen
		@queue = Rubygame::EventQueue.new()
		@queue.enable_new_style_events()
		#@player_1_img = Surface.load("graphics/player_1.png")
	end
	
	def draw
		#@player_1_img.blit(@screen,[250,400])
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
		hook_quit()
		loop do
			@queue.each do |event|
				puts "This is the controller."
				handle(event)
			end
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
