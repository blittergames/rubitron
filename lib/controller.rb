class Bullet
	attr_accessor :bullet_img, :x, :y
	def initialize screen_name
		@screen_name = screen_name
		@bullet_img = Surface.load("graphics/bullet.png")
		@x = 150
		@y = 400
	end
	
	def update
		@y -= 50
		@bullet_img.blit(@screen_name,[@x,@y])
	end
end

class Bullets
	attr_accessor :bullet_shots
	def initialize screen_name
	@bullet_shots = []
	end
	
	def create_bullet(screen_name)
		b = Bullet.new(screen_name)
		@bullet_shots << b
	end

	def update_bullets()
		@bullet_shots.each do |b|
			b.update()
		end
	end
end

class Player
	include Rubygame::EventHandler::HasEventHandler
	attr_accessor :queue, :screen, :x, :y, :p_bullets
	def initialize screen
		@screen = screen
		@queue = Rubygame::EventQueue.new()
		@queue.enable_new_style_events()
		@player_1_img = Surface.load("graphics/player_ship.png")
	    @x = 150
		@y = 400
		@font = TTF.new("data/Welbut__.ttf",12)
		@text_str = "Player: " + "#{@x}" + ", " + "#{@y}"
		@text = @font.render(@text_str,false,[242,0,255])
		@p_bullets = Bullets.new(@screen)
	end
	
	def right
	    @x += 10
	end
	
	def left
		puts 'left key hit!'
		@x -= 10
	end
	
	def shoot
		@p_bullets.create_bullet(@screen)
	end
	
	def movement_hook
		movement_hooks = {
		:up => :shoot,
		:left => :left,
		:right => :right,
		}
		make_magic_hooks(movement_hooks)
	end	
	
	def move    
		@queue.each do |event|
		handle(event)
		end
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
		
		hook = {
			:owner => @p1,
			:trigger => Rubygame::EventTriggers::YesTrigger.new(),
			:action => Rubygame::EventActions::MethodAction.new(:handle)
			}
		append_hook(hook)
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
			@screen.fill([0,0,0])
			@background.blit(@screen,[0,0])
			@p1.draw()
			@p1.p_bullets.update_bullets()
			@screen.flip()
			@clock.tick()
		end
	end
  
	def quit
		Rubygame.quit()
		exit
	end
end
