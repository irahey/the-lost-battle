require 'gamepad.rb'
require 'mouse.rb'
require 'helpers.rb'
require 'projectilefactory.rb'
require 'healthbar.rb'
require 'spriteanimation.rb'
require 'playerscore.rb'
require 'playertag.rb'
require 'powerupindicator.rb'
require 'shiphelper.rb'

class Player
	attr_accessor :is_alive, :name

	def initialize(window, space, x, y, z, controller, vehicle, crosshair, player_number, name, player_list, dead_callback)
		hub_offset = player_number * 150 + 50
		@window = window
		@space = space
		@crosshair = crosshair
		@vehicle = vehicle
		@controller = controller
		@state
		@hor_value = @ver_value = 0
		@projectile_factory = ProjectileFactory.new(window, space, vehicle.body.p, self)
		@projectiles = Array.new
		@health_bar = HealthBar.new(window, 100, 20, GameOptions::MAX_PLAYER_HEALTH, GameOptions::MAX_PLAYER_HEALTH, hub_offset, 30, ZOrdinals::HEALTHBAR, name, GameOptions::HEALTH_BAR_FG, GameOptions::HEALTH_BAR_BG, lambda { die })
		@score = PlayerScore.new(window, hub_offset, 60, ZOrdinals::HUB_SCORE)
		@bullets_that_hit_me = Array.new
		self.is_alive = true
		@vehicle.set_destroyed_callback lambda {
			self.is_alive = false
			@dead_callback.call(self)
		}
		@projectiles_to_be_removed = Array.new
		@player_number = player_number
		@tag = PlayerTag.new(window, name, @vehicle)
		self.name = name

		@current_powerups = Array.new
		@ship_helpers = Array.new
		@player_list = player_list#.players_list.select { |p| p != self }
		@dead_callback = dead_callback
	end

	def update (key_input = nil)
		@projectiles_to_be_removed.reject! do |p|
			@projectiles.reject! do |pr| pr == p end
			p.remove
			true
		end

		@ship_helpers.each do |s| s.update end 

		if is_alive then
			update = @controller.update key_input
			update_movement update

			@projectiles.each do |p|
				p.update
				if !p.is_in_screen then
					@projectiles.reject! do |pr|
						pr == p
					end
					p.remove
				end
			end
		end

		@current_powerups.each do |p|
			powerup = p[:powerup]
			duration = powerup.duration
			return if duration == 0
			p_indicator = p[:indicator]
			p_indicator.draw
			if Gosu::milliseconds - p[:time_started] > duration then
				type = powerup.type
				@current_powerups.reject! { |pu| pu[:powerup].type == type }
				@current_powerups.each do |pu|
					pu[:indicator].x -= powerup_indicator_x_offset
				end
			end
		end
	end

	def update_movement (update)
		actions = update[:actions]
		if actions[:fire_main] then # fire main cannons
			if has_powerup(:triple_shot) then
				triple_shot
			else
				fire_main
			end
		end
=begin
		if actions[:triple_shot] then # triple shot
			if has_powerup(:triple_shot) then
				triple_shot
			end
		end
=end
		crosshair_horizontal = actions[:movement_crosshair][:horizontal]
		crosshair_vertical = actions[:movement_crosshair][:vertical]
		vehicle_horizontal = actions[:movement_vehicle][:horizontal]
		vehicle_vertical = actions[:movement_vehicle][:vertical]

		angle = Helpers::angle_from_coordinates(0, 0, vehicle_horizontal, vehicle_vertical)
		@vehicle.move(angle, vehicle_horizontal / 5000, vehicle_vertical / 5000)
		if update[:input] == :gamepad then
			@crosshair.x = (@crosshair.x + crosshair_horizontal / 15000)
			@crosshair.y = (@crosshair.y + crosshair_vertical / 15000)
		elsif update[:input] == :mouse then
			@crosshair.x = crosshair_horizontal
			@crosshair.y = crosshair_vertical
		end
	end

	def fire_main
		AudioManager::fire_primary_sound.play_pan(get_sound_pan, 0.4)
		b = @projectile_factory.new_small_bullet @crosshair
		b.set_position(@vehicle.body.p.x, @vehicle.body.p.y)
		@projectiles << b
	end

	def get_sound_pan
		screen_percentage = (x / @window.width) * 100
		(screen_percentage * 2) / 100 - 1
	end

	def triple_shot
		AudioManager::fire_primary_sound.play_pan(get_sound_pan, 0.4)
		angle = Gosu::angle(@vehicle.body.p.x, @vehicle.body.p.y, @crosshair.x, @crosshair.y)
		all_bullets = [@projectile_factory.new_small_bullet(@crosshair), @projectile_factory.new_small_bullet(@crosshair, angle + 5), @projectile_factory.new_small_bullet(@crosshair, angle - 5)]
		all_bullets.each do |b|
			b.set_position(@vehicle.body.p.x, @vehicle.body.p.y)
			@projectiles << b
		end
	end

	def draw
		@health_bar.draw
		@score.draw
		@ship_helpers.each do |s| s.draw end 
		if is_alive then
			@tag.draw
			@vehicle.draw
			@crosshair.draw
			@projectiles.each do |p|
				p.draw
			end
		end
	end

	def is_bullet_mine (bullet_shape)
		@projectiles.each do |p|
			return true if bullet_shape == p.shape
		end
		return false
	end

	def vehicle
		@vehicle
	end

	def hit (projectile, shooting_player)
		if !has_bullet_hit_me projectile then
			damage = projectile.damage
			if !shooting_player.nil? and shooting_player.has_powerup(:doubledamage) then
				damage *= 2
			end
			@health_bar.health -= damage
			@bullets_that_hit_me << projectile
		end
		
	end

	def has_bullet_hit_me (projectile)
		@bullets_that_hit_me.each do |p|
			if p == projectile then
				return true
			end
		end 
		return false
	end

	def bullet_hit (projectile)
		#projectile = projectile_from_shape projectile_shape
		@projectiles_to_be_removed << projectile
		@score.inc_score (10)
	end

	def projectile_from_shape (projectile_shape)
		@projectiles.each do |p|
			return p if projectile_shape == p.shape
		end
	end

	def die
		@vehicle.explode
	end

	def score
		@score.score
	end

	def x
		@vehicle.xy.x
	end

	def y
		@vehicle.xy.y
	end

	def apply_powerup (powerup)
		if (powerup.duration != 0 and !has_powerup(powerup.type)) then
			indicator_x = @health_bar.x + (@current_powerups.length * powerup_indicator_x_offset) 
			@current_powerups << {powerup: powerup, time_started: Gosu::milliseconds, indicator: PowerupIndicator.new(@window, powerup.image, indicator_x, @health_bar.y - 20, @health_bar.z)}
		end

		case powerup.type
			when :health
				@health_bar.health += GameOptions::HEALTH_PACK_INCREASE
				AudioManager::health_pack_sound.play
			when :doubledamage
				AudioManager::double_damage_sound.play
			when :shiphelper
				@ship_helpers << ShipHelper.new(@window, @space, @player_list.players_list.select { |p| p != self }, lambda { |sh|
					@ship_helpers.reject! { |s| s == sh }
				})
		end
	end

	def has_powerup (type)
		@current_powerups.each do |p|
			return true if p[:powerup].type == type
		end
		return false
	end

	def powerup_indicator_x_offset
		@current_powerups.length * 18
	end
end
