class Powerup
	attr_accessor :type, :duration, :image

	def initialize (window, image, x, y, z, type, duration = 0)
		@window = window
		self.image = Gosu::Image.new(window, image, false)
		@x, @y, @z = x, y, z
		self.type = type
		self.duration = duration
	end

	def draw
		image.draw(@x, @y, @z)
	end

	def has_hit (x, y)
		(x >= @x and y >= @y) and (x <= @x + image.width) and (y <= @y + image.height)
	end
end
