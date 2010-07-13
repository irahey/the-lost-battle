class GameScores
	INIT_X = 400
	INIT_Y = 300

	def initialize (window, scores)
		@window = window
		@scores = Array.new
		@title = Gosu::Image.new(window, "images/titles/gameover.png", false)
		curr_y = INIT_Y
		scores.each { |s|
			@scores << Score.new(window, s.name, s.score, INIT_X, curr_y, ZOrdinals::MENU_CURSOR - 1)
			curr_y += 50
		}
	end

	def draw
		@title.draw(((@window.width / 2) - (@title.width / 2)) + 30, INIT_Y - 150, ZOrdinals::MENU_CURSOR - 1)
		@scores.each { |s|
			s.draw
		}
	end
end
