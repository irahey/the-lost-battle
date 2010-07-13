class ShipHelper
	SHIP_SIDE_A = 172
	SHIP_SIDE_B = 30
	SPEED = 0.3

	def initialize (window, space, players, off_screen_callback)
		@players = players
		@space = space
		@off_screen_callback = off_screen_callback
		@window = window
		@dirs = get_random_direction
		@axis, @direction = @dirs[:axis], @dirs[:dir]
		if @axis == :hor then #going left/right
			width, height = SHIP_SIDE_A, SHIP_SIDE_B

			if @direction > 0 then #going left
				image = "images/ship_left.png"
				x = @window.width + SHIP_SIDE_A
			else #going right
				image = "images/ship_right.png"
				x = -SHIP_SIDE_A 
			end
			y = get_calculated_y
		else #going up/down
			image = (@direction > 0 ? "images/ship_down.png" : "images/ship_up.png")
			width, height = SHIP_SIDE_B, SHIP_SIDE_A
			if @direction > 0 then #going down
				image = "images/ship_down.png"
				y = -SHIP_SIDE_A
			else #going up
				image = "images/ship_up.png"
				y = @window.height + SHIP_SIDE_A
			end
			x = get_calculated_x
		end
		@sprite = SpriteAnimation.new({window: window, imagefile: image, x: x, y: y, z: ZOrdinals::SEA + 1, width: width, height: height, speed: 200, loop: true, stopped_playing: lambda {}})
		@sprite.play
		@projectile_factory = ProjectileFactory.new(window, space, self, self)
		@last_projectile_shot = Gosu::milliseconds
		@projectiles = Array.new
	end

	def draw
		@sprite.draw
		@projectiles.each { |p|
			p.draw
		}
	end

	def fire
		target = closest_vehicle
		if !target.nil? then
			AudioManager.helper_ship_fire.play
			@last_projectile_shot = Gosu::milliseconds
			p_x, p_y = x, y
			if @axis == :hor then
				p_x += SHIP_SIDE_A / 2
			else
				p_y += SHIP_SIDE_A / 2
			end
			angle = Gosu::angle(p_x, p_y, target.x, target.y)
			new_projectile = @projectile_factory.new_round_bullet(target, angle) 
			new_projectile.set_position(p_x, p_y)
			@projectiles << new_projectile
		end
	end

	def update
		if (Gosu::milliseconds - @last_projectile_shot) > GameOptions::HELPER_SHIP_FIRE_INTERVAL then
			fire
		end

		if @axis == :hor then
			@sprite.x -= @direction
		else
			@sprite.y += @direction
		end
		
		if is_off_screen then
			@off_screen_callback.call(self)
		end

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

	def get_random_direction
		return {axis: (rand(100) < 50 ? :hor : :ver), dir: (rand(100) < 50 ? GameOptions::HELPER_SHIP_SPEED : -GameOptions::HELPER_SHIP_SPEED)}
	end

	def closest_vehicle
		return @players.sort { |p1, p2|
			Gosu::distance(@sprite.x, @sprite.y, p1.x, p1.y) <=> Gosu::distance(@sprite.x, @sprite.y, p2.x, p2.y)
		}[0]
	end

	# get_calculated_x and get_calculated_y calculate a position 
	# of the ship to avoid hitting the island in the middle

	def get_calculated_y
		range = (5..210).to_a + (615..@window.height).to_a
		range[rand(range.length - 1)]
	end

	def get_calculated_x
		range = (5..219).to_a + (800..@window.width).to_a
		range[rand(range.length - 1)]
	end

	def is_off_screen
		case @axis
			when :hor
				if @direction > 0 then #going left
					return true if @sprite.x < -SHIP_SIDE_A
				else #going right
					return true if @sprite.x > @window.width + SHIP_SIDE_A
				end
			when :ver
				if @direction > 0 then #going down
					return true if @sprite.y > @window.height + SHIP_SIDE_A
				else #going up
					return true if @sprite.y < -SHIP_SIDE_A
				end
		end
		return false
	end

	def x
		@sprite.x
	end

	def y
		@sprite.y
	end

	def has_powerup (type)
		return false
	end

	def bullet_hit (projectile)
		#p "ship hit"
		@projectiles.reject! { |p| p == projectile }
	end
end
