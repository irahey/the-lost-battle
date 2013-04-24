require_relative 'projectile.rb'

class ProjectileFactory

	PROJECTILES_PATH = "images/projectiles/"

=begin
	def initialize (window, space, source_position, destination_position)
		@window = window
		@space = space
		@source_position = source_position
		@destination_position = destination_position
	end

	def new_small_bullet (angle = default_angle, destination_position = @destination_position)
		new_projectile "bullet_3.png", GameOptions::PRIMARY_FIRE_DAMAGE, angle
	end

	def new_round_bullet (angle = default_angle, destination_position = @destination_position)
		new_projectile "bullet_1.png", GameOptions::PRIMARY_FIRE_DAMAGE, angle
	end

	def new_projectile (image, damage, angle, destination_position = @destination_position)
		Projectile.new(@window, @space, Gosu::Image.new(@window, PROJECTILES_PATH + image), angle, damage)
	end

	def default_angle
		Gosu::angle(@source_position.x, @source_position.y, @destination_position.x, @destination_position.y)
	end
=end
	def initialize (window, space, source_position, shooter)
		@window = window
		@space = space
		@source_position = source_position
		@shooter = shooter
	end

	def new_small_bullet (destination_position, angle = default_angle(destination_position))
		new_projectile "bullet_3.png", GameOptions::PRIMARY_FIRE_DAMAGE, angle, destination_position
	end

	def new_round_bullet (destination_position, angle = default_angle(destination_position))
		new_projectile "bullet_1.png", GameOptions::HELPER_SHIP_FIRE_DAMAGE, angle, destination_position
	end

	def new_projectile (image, damage, angle, destination_position)
		Projectile.new(@window, @space, Gosu::Image.new(@window, PROJECTILES_PATH + image), angle, damage, @shooter)
	end

	def default_angle (destination_position)
		Gosu::angle(@source_position.x, @source_position.y, destination_position.x, destination_position.y)
	end

	private :new_projectile, :default_angle
end
