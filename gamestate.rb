require_relative 'playerlist.rb'
require_relative 'player.rb'
require_relative 'playerlisting.rb'
require_relative 'gamescores.rb'
require_relative 'powerupmanager.rb'

class GameState
	SUBSTEPS = 6

	PS3_CONTROLLER  = GamepadConfig.new({horizontal: 0, vertical: 1}, {:horizontal => 2, :vertical => 3}, 11, 9)#9)
	#GPAD_CONTROLLER = GamepadConfig.new({horizontal: 0, vertical: 1}, {:horizontal => 3, :vertical => 2}, 7)

	def initialize(window, playerlistings)
		@space = CP::Space.new
	        #@space.damping = 0.8    

		@player_list = PlayerList.new(window, @space, ZOrdinals::PLAYER)

		playerlistings.each { |p|
			@player_list.add(p.name, rand(window.width), rand(window.height), p.controller_type == :joystick ? GamePad.new(p.joystick_path, PS3_CONTROLLER) : Mouse.new(window), p.vehicle, p.crosshair)
		}

=begin
		@player_list.add(10, 10, GamePad.new('/dev/input/js0', PS3_CONTROLLER))
		#@player_list.add(50, 50, GamePad.new('/dev/input/js1', PS3_CONTROLLER))
		#@player_list.add(50, 50, GamePad.new('/dev/input/js2', GPAD_CONTROLLER))
		@player_list.add(50, 50, Mouse.new(window))
=end
	    	@dt = (1.0/60.0)

		@background = Shared::background
		@game_is_over = false
		@window = window
		@powerup_manager = PowerupManager.new(window, @player_list, lambda { |player, powerup|
			player.apply_powerup powerup
		})
	end

	def update
		@background.update
		@powerup_manager.update 
		SUBSTEPS.times do
			@player_list.players do |p|
				p.update
			end
      			@space.step(@dt)
		end

		if remaining_players == 1 and !@game_is_over then
			@game_is_over = true
			score = Struct.new(:name, :score)
			scores = Array.new
			@player_list.players do |p|
				scores << score.new(p.name, p.score)
			end
			scores.sort! { |s1, s2|
				s2.score <=> s1.score
			}
			@scores = GameScores.new(@window, scores)
			HighScoresFile::write(scores_in_yaml scores)
		end
	end

	def draw
		@background.draw
		@powerup_manager.draw 
		if @game_is_over then
			@scores.draw
		end
		@player_list.players do |p|
			p.draw
		end
	end

	def button_down (id)
		@player_list.players do |p|
			p.update id
		end

		if id == Gosu::KbEscape then
			StateMachine.set_state(:mainmenu, :resume)
		end

		if (id == Gosu::KbReturn or id == Gosu::KbEscape) and @game_is_over
			Shared::set_is_game_running false
			StateMachine.set_state(:highscores, :restart)
		end
		
	end

	def remaining_players
		total = 0
		@player_list.players do |p| 
			(total += 1) if p.is_alive
		end
		total
	end

	def scores_in_yaml (scores)
		yml_scores = ""
		scores.each { |s| 
			yml_scores << "  #{s.name}: #{s.score}\n"
		} 
		yml_scores
	end
end
