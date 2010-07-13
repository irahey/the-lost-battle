class Score

	attr_accessor :score
	def initialize (window, name, score, x, y, z)
		@name = name
		self.score = score
		@x = x
		@y = y
		@z = z
		@name_font = Gosu::Font.new(window, Gosu::default_font_name, 30)
		@score_font = Gosu::Font.new(window, Gosu::default_font_name, 30)
	end

	def draw
		@name_font.draw(@name, @x, @y, @z)
		@score_font.draw(score, @x + 200, @y, @z)
	end

	def set_y (y)
		@y = y
	end
end
