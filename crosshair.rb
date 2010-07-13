
class Crosshair
	attr_accessor :x, :y, :z

	def initialize (window, image, x, y, z)
		@image = image
		@window = window
		self.x = x
		self.y = y
		self.z = z
	end
	
	def draw
		@image.draw(x, y, z)
		Helpers.validate_position!(@window, self, @image)
	end
end
