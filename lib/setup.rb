include Rubygame::EventHandler::HasEventHandler

class Setup

    def initialize
	  @screen = Screen.new([320,480],0,[Rubygame::HWSURFACE,Rubygame::DOUBLEBUF])
	  @queue = Rubygame::EventQueue.new()
      @queue.enable_new_style_events()
	  @control = Controller.new(@screen)
	  @background = Surface.load("graphics/intro_screen.png")
	end
	
    def quit
      Rubygame.quit()
      exit
    end
	
	def hook_quit
		quit_hooks = {
			:escape => :quit,
			Rubygame::Events::QuitRequested => :quit,
		}
		make_magic_hooks(quit_hooks)
	end

	def run
		hook_run()
		hook_quit()
		loop do
			@queue.each do |event|
				handle(event)
			end
		@background.blit(@screen,[0,0])
		@screen.flip()
		end
	end
	
	def hook_run
		run_hook = {
			:return => :execute
		}
		make_magic_hooks(run_hook)
	end
	
	def execute
		@control.run()
	end
end
