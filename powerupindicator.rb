class PowerupIndicator

	IMG_SCALE = 0.4
	attr_accessor :x

	def initialize (window, image, x, y, z)
		@window = window
		@image = image
		self.x, @y, @z = x, y, z
	end

	def draw
		@image.draw(x, @y, @z, IMG_SCALE, IMG_SCALE)
	end
	
end
