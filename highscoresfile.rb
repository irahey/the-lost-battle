module HighScoresFile
	SCORE_X = 400

	@file = 'highscores.yml'

	def self.set_window (window)
		@window = window
	end

	def self.write (text)
		File.open(@file, 'a') { |f|
			f.write(text)
		}
	end

	def self.scores
		score_list = Array.new
		scores_from_file = YAML::load_file(@file)
		scores_from_file['highscores'].each do |s|
			score_list << Score.new(@window, s[0], Integer(s[1]), SCORE_X, 0, ZOrdinals::MENU_CURSOR - 1)
		end
		score_list
	end
end
