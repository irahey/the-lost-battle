class Cursor
	def initialize (window, image, z, onclick = nil)
		@window = window
		@image = image
		@z = z
		@onclick = onclick
	end

	def draw
		@image.draw(@window.mouse_x, @window.mouse_y, @z)
	end

	def update
		
	end

	def input (id)
		return if @onclick.nil? 

		if id == Gosu::MsLeft or id == Gosu::MsRight or id == Gosu::MsMiddle then
			@onclick.call(id)
		end
	end

end
