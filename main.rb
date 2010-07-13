require 'gosu'
require 'chipmunk'

require 'yaml'
require 'audiomanager.rb'
require 'gameoptions.rb'
require 'zordinals.rb'
require 'gamepadconfig.rb'
require 'background.rb'
require 'highscoresfile.rb'

require 'shared.rb'
require 'menustate.rb'
require 'playerselectionstate.rb'
require 'highscoresstate.rb'
require 'gamestate.rb'

require 'statemachine.rb'

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 768

class Main < Gosu::Window

	def initialize
		super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
		Shared::init(self)
		HighScoresFile::set_window(self)
		StateMachine.window = self
		AudioManager.window = self
		StateMachine.set_state :mainmenu, :restart# initial state
	end

	def update
		current_state.update if current_state.respond_to? 'update'
	end

	def draw
		current_state.draw if current_state.respond_to? 'draw'
	end

	def button_down (id)
		current_state.button_down id if current_state.respond_to? 'button_down'
	end
	
	def button_up (id)
		current_state.button_up id if current_state.respond_to? 'button_up'
	end

	def current_state
		StateMachine.state
	end
end

Main.new.show
