class PlayerScore
	attr_accessor :score

	def initialize (window, x, y, z)
		@window = 0
		self.score = 0
		@score_display = Gosu::Font.new(window, Gosu::default_font_name, 30)
		@x = x
		@y = y
		@z = z
	end

	def inc_score (value)
		self.score += value
	end

	def draw
		@score_display.draw(score.to_s, @x, @y, @z)
	end
end
