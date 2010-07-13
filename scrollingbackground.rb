class ScrollingBackground
	attr_accessor :window, :init_x, :init_y

	class Tile
		attr_accessor :x, :y, :z, :window, :width, :height
		def initialize (window, image, z, x = 0, y = 0)
			@image = Gosu::Image.new(window, image, true)
			self.x = x
			self.y = y
			self.z = z
			self.width = @image.width
			self.height = @image.height
		end

		def draw
			@image.draw(x, y, z)
		end
	end

	def initialize (window, image, init_x, init_y, z)
		self.window = window
		self.init_x = init_x
		self.init_y = init_y
		@image = Gosu::Image.new(window, image, true)
		@images = Array.new
		@tiles_needed = (window.width / @image.width) + 2 # 2: one off screen to the left and to the right
		x = -window.width 
		y = init_y
		@tiles_needed.times { |i| 
			tile = Tile.new(window, image, z, x, y)
			@images << tile
			x += window.width
		}
	end

	def scroll (x, y) #offsets
		@images.each { |i|
			i.x += x
			i.y += y
		}
		if @images[0].x >= 0 or @images[2].x <= 0 then
			reset_pos
		end
	end

	def draw
		@images.each { |i| i.draw }
	end

	def reset_pos
		x = -window.width
		y = init_y
		@images.each{ |i|
			i.x = x
			i.y = y
			x += window.width
		}
	end
end
