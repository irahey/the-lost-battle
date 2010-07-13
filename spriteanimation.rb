class SpriteAnimation
  
  attr_accessor :x, :y

  def initialize( h )
    @window, imagefile, self.x, self.y, @z, width, height, @speed, @stopped_playing_callback, @loop = h.values_at( :window, :imagefile, :x, :y, :z, :width, :height, :speed, :stopped_playing, :loop)
    @sprite = Gosu::Image.load_tiles(@window, imagefile, width, height, false)
    @playing = false
    @last_change = 0
    @current_frame = 0
  end
  
  def playing?
    @playing
  end 
  
  def play
    @playing = true
  end
  
  def stop
    @playing = false
    @stopped_playing_callback.call()
  end
  
  def draw
    if (Gosu::milliseconds - @last_change) > @speed then
      @last_change = Gosu::milliseconds
      @current_frame += 1
    end
    
    if !@loop then
	    if @current_frame < @sprite.length then
	      @sprite[@current_frame].draw(x, y, @z)
	    else
	      stop
	    end
    else
	@current_frame = @current_frame % @sprite.length
	@sprite[@current_frame].draw(x, y, @z)
    end
    
  end
  
  def setXY (x, y)
    self.x = x
    self.y = y
  end
  
end
