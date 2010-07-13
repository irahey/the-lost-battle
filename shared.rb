module Shared

	def self.init (window)
		@window = window
		@is_game_running = false
	end

	def self.is_game_running
		@is_game_running
	end

	def self.set_is_game_running (is_running)
		@is_game_running = is_running
	end

	def self.background
		@background ||= Background.new(@window)
	end

	def self.title
		@title ||= Gosu::Image.new(@window, "images/titles/mainmenu.png", false) 
	end

	def self.cursor
		@cursor ||= Gosu::Image.new(@window, "images/cursor.png", false)
	end
end
