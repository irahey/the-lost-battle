require 'menu.rb'

class MainMenuState

	ITEM_SPACE = 60

	def initialize (window)
		@window = window
		@background = Shared::background
		@splash = Shared::title
		@cursor = Shared::cursor
		@first_menu_option_pos = {x: (window.width / 2) - 100, y: (window.height / 2) - 50}

		@menu = Menu.new(window)
		@menu.add_item(Gosu::Image.new(window, "images/mainmenu/startgame.png", false), @first_menu_option_pos[:x], @first_menu_option_pos[:y], ZOrdinals::MENU_CURSOR - 1, lambda { 
			#StateMachine.set_state(:game,:restart)
			StateMachine.set_state(:playerselection,:restart)
		}, Gosu::Image.new(window, "images/mainmenu/startgame_hover.png", false))
		.add_item(Gosu::Image.new(window, "images/mainmenu/highscores.png", false), @first_menu_option_pos[:x] - 10, @first_menu_option_pos[:y] + ITEM_SPACE, ZOrdinals::MENU_CURSOR - 1, lambda { 
			StateMachine.set_state(:highscores, :restart)
		}, Gosu::Image.new(window, "images/mainmenu/highscores_hover.png", false))
		.add_item(Gosu::Image.new(window, "images/mainmenu/exit.png", false), @first_menu_option_pos[:x] + 75, @first_menu_option_pos[:y] + ITEM_SPACE * 2, ZOrdinals::MENU_CURSOR - 1, lambda { 
			window.close 
		}, Gosu::Image.new(window, "images/mainmenu/exit_hover.png", false))

		AudioManager::intro_song.play
	end

	def update
		@background.update
		@cursor.draw(@window.mouse_x, @window.mouse_y, ZOrdinals::MENU_CURSOR)
		@menu.update
	end

	def draw
		@background.draw
		@splash.draw(0, 0, ZOrdinals::TITLE)
		@menu.draw
	end

	def button_down (id)
		if id == Gosu::KbEscape then
			if Shared::is_game_running then
				StateMachine.set_state(:game,:resume)
				return
			end
			@window.close
		end

		if id == Gosu::MsLeft then
			@menu.clicked
		end
	end

	def close_game
		@window.close
	end
end
