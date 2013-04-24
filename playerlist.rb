require_relative 'crosshair.rb'
require_relative 'playervehicle.rb'

class PlayerList

	@@crosshairs_folder = "images/crosshairs/"
	@@players_folder = "images/players/"

	def initialize (window, space, z)
		@players = Array.new
		@window = window
		@space = space
		@z = z
		@player_index = 0
		@space.add_collision_func(:bullet, :bullet) do |b1, b2|
			false
		end
		@space.add_collision_func(:player_vehicle, :bullet) do |veh, bullet|
			player_hit = player_from_vehicleshape veh  #the player that was hit by the projectile
			if player_hit.is_bullet_mine bullet then #the player that was hit owns the bullet; thus ignore
				false
			else
				projectile = bullet.obj[:projectile] #the projectile that was shot
				player_bullet = bullet.obj[:shooter] #the player that owns the projectile
				if player_bullet.nil? then #projectile was not fired from another player
					p bullet.obj
				end
				player_hit.hit(projectile, player_bullet)
				if !player_bullet.nil? then
					player_bullet.bullet_hit projectile
				end
			end
		end
	end

	def add (name, x, y, controller, vehicle_image, crosshair_image)
		vehicle = PlayerVehicle.new(@window, @space, vehicle_image, Gosu::Image.new(@window, @@players_folder + @player_index.to_s + "_shadow.png"), x, y, @z)
		crosshair = Crosshair.new(@window, crosshair_image, @window.width / 2, @window.height / 2, ZOrdinals::CROSSHAIR)

		@players << Player.new(@window, @space, x, y, @z, controller, vehicle, crosshair, @player_index, name, self, lambda { |p| 
			#@players.reject! { |pl| pl == p }
		 })
		@player_index += 1
	end

	def players
		@players.each { |p| yield p }
	end

	def player_from_vehicleshape (shape)
		players do |p|
			return p if p.vehicle.shape == shape
		end
		return nil
	end

	def player_from_bulletshape (shape)
		players do |p|
			return p if p.is_bullet_mine shape
		end
		return nil
	end

	def players_list
		@players
	end
end
