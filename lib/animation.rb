class Animation
 
  attr_accessor :data, :cur_frame, :ticks, :ticks_remaining, :pos
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
    @ticks_remaining += @tick_difference
    @dest = dest
  
    while @ticks_remaining <= 0
      @cur_frame += 1
      @cur_frame %= @data.length
      @ticks_remaining += @data[@cur_frame][0]
    end
      
    @data[@cur_frame][1].blit(dest, @pos)
  
  end
end
