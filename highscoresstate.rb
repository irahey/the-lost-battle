require 'score.rb'

class HighScoresState

	SCORE_Y = 270
	SCORE_Y_INC = 50 #height between one score and the next
	DISPLAYED = 5 #number of high-score entries displayed


	def initialize (window)
		@window = window
		@background = Shared::background
		@splash = Shared::title
		@hs_title = Gosu::Image.new(window, "images/titles/highscores.png", false)
		@cursor = Shared::cursor
		@highscores = get_scores.sort do |s1, s2|
			s2.score <=> s1.score
		end[0..DISPLAYED - 1]

		curr_score_y = SCORE_Y
		@highscores.each do |s|
			s.set_y curr_score_y += SCORE_Y_INC
		end
	end

	def get_scores
		HighScoresFile::scores
	end

	def update
		@background.update
	end

	def draw
		@background.draw
		@splash.draw(0, 0, ZOrdinals::TITLE)
		@hs_title.draw(@window.width / 2 - @hs_title.width / 2, 200, ZOrdinals::MENU_CURSOR - 1)
		@cursor.draw(@window.mouse_x, @window.mouse_y, ZOrdinals::MENU_CURSOR)
		@highscores.each do |h|
			h.draw
		end
	end

	def button_down (id)
		if (id == Gosu::KbEscape or id == Gosu::KbReturn) then
			StateMachine.set_state(:mainmenu, :resume)
		end
	end
end
