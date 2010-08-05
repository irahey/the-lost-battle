require 'powerup.rb'

class PowerupManager
	BASE_POWERUPS_FOLDER = "images/powerups/"

	def initialize (window, player_list, hit_callback)
		@window = window
		@powerups = [
			{image: "Help.png", type: :health, duration: 0}, 
			{image: "doubledamage.png", type: :doubledamage, duration: 5000},
			{image: "triple_shot.png", type: :triple_shot, duration: 5000}, 
			{image: "helper_ship.png", type: :shiphelper, duration: 0}
		]
		@hit_callback = hit_callback
		@current_powerups = Array.new
		@player_list = player_list
	end

	def draw
		if @current_powerups.length > 0 then
			@current_powerups.each { |p|
				p.draw
			}
		end
	end

	def update
		if rand(1000) < 4 then
			@current_powerups << get_random_powerup
			if @current_powerups.length > GameOptions::MAX_POWERUPS_ON_SCREEN then
				@current_powerups.shift
			end
		end
		@player_list.players do |p|
			@current_powerups.each { |pu|
				if (pu.has_hit(p.x, p.y)) then
					@hit_callback.call(p, pu)
					@current_powerups.reject! { |pu2| pu2 == pu }
				end
			}
		end
	end

	def get_random_powerup
		powerup = @powerups[rand(@powerups.length)]
		Powerup.new(@window, BASE_POWERUPS_FOLDER + powerup[:image], rand(@window.width), rand(@window.height), ZOrdinals::PLAYER - 1, powerup[:type], powerup[:duration])
	end

end
