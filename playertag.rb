class PlayerTag
	def initialize (window, name, vehicle)
		@window = window
		@name = name
		@vehicle = vehicle
		@tag = Gosu::Font.new(window, Gosu::default_font_name, 20)
	end

	def draw
		xy = @vehicle.xy
		@tag.draw(@name, xy.x + 30, xy.y - 35, ZOrdinals::PLAYER + 1)
	end
end
