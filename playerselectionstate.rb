require 'playerlisting.rb'
require 'textfield.rb'
require 'cursor.rb'

class PlayerSelectionState


	INIT_X = 250
	INIT_Y = 100

	def initialize (window)
		available_gamepads = GamePad::available_gamepads
		max_players = available_gamepads.length + 1 #the number of players that can play is determined by the number of joysticks connected to the system + 1 (mouse+keyboard)

		@cursor = Cursor.new(window, Gosu::Image.new(window, "images/cursor.png", false), ZOrdinals::MENU_CURSOR, lambda { |id| 
			selected_player = @players.find { |p| p.text_field.under_point?(window.mouse_x, window.mouse_y) }
			if selected_player.nil? then
				unfocus_text
				return
			end
			window.text_input = selected_player.text_field
		} )
		@window = window
		curr_y = INIT_Y
		mouse_used = false
		controller_index = -1
		@players = Array.new(max_players) { |i|
			x = (i % 2 == 0 ? INIT_X : INIT_X + 300)
			y = (i % 2 == 0 ? (curr_y += 150) : curr_y)
			if !mouse_used then
				mouse_used = true
				controller = :mouse
			else 
				controller = :joystick
				controller_index += 1
			end
			PlayerListing.new(window, x, y, i, controller, controller == :joystick ? available_gamepads[controller_index] : "") 
		}

	end

	def draw
		Shared::background.draw
		@players.each { |p| p.draw }
		@cursor.draw
	end

	def update
		Shared::background.update
	end

	def button_down (id)
		@cursor.input id
		textbox_focused = !@window.text_input.nil?
		if id == Gosu::KbEnter or id == Gosu::KbReturn then
			if textbox_focused then
				unfocus_text 
			else
				playing_players = @players.select { |p| p.will_play? }
				if playing_players.length >= 2 then 
					Shared::set_is_game_running true
					StateMachine.set_state(:game,:restart, playing_players) 
				end
			end
		end
		if id == Gosu::KbEscape then
			if textbox_focused then
				unfocus_text
			else 
				StateMachine.set_state(:mainmenu,:resume)
			end
		end
	end

	def unfocus_text
		@window.text_input = nil
	end

end
