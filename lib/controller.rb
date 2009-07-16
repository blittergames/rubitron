class Animation
 
  attr_reader :data, :cur_frame, :ticks, :ticks_remaining, :pos
  def initialize data
    @my_clock = Rubygame::Clock.new()
    @my_clock.enable_tick_events()
    @data = data # data = [ [time, image], [time, image], ...]
    @cur_frame = 0
    @ticks = @my_clock.tick()
    @ticks_remaining = data[0][0]
    @pos = [0, 0]
  end
  
  def draw dest
    @old_ticks = @ticks
    @ticks = @my_clock.tick()
    @tick_difference = (@ticks - @old_ticks)
    @ticks_remaining += tick_difference
    @dest = dest
  
    while @ticks_remaining <= 0
      @cur_frame += 1
      @cur_frame %= @data.length
      @ticks_remaining += @data[@cur_frame][0]
    end
      
    @data[@cur_frame][1].blit(dest, @pos)
  
  end
end

class Player
	include Rubygame::EventHandler::HasEventHandler
	attr_accessor :queue, :screen, :x, :y, :hurt
	def initialize screen
		@screen = screen
		@queue = Rubygame::EventQueue.new()
		@queue.enable_new_style_events()
		@player_1_img = Surface.load("graphics/player_ship.png")
		@player_2_img = Surface.load("graphics/player_ship_2.png")
	    @x = 150
		@y = 400
		@font = TTF.new("data/Welbut__.ttf",18)
		@text_str = "Player: " + "#{@x}" + ", " + "#{@y}"
		@text = @font.render(@text_str,false,[214,214,214])
		@hurt = Animation.new([[1000, @player_1_img],[1000, @player_2_img]])	
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
			@p1.hurt.draw(@screen)
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
