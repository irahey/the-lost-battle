class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

class PlayerVehicle
	
	BASE_TANK_FOLDER = "images/tank/"

	def initialize (window, space, image, shadow_image, x, y, z)
		@window = window
		@space = space
		@body_image = image
		@shadow = shadow_image

		@body = CP::Body.new(10.0, 150.0) #mass, moment of intertia
		half_body_height = @body_image.height / 2
		half_body_width = @body_image.width / 2
		shape_vertices = [CP::Vec2.new(-half_body_width, -half_body_height), CP::Vec2.new(-half_body_width, half_body_height), CP::Vec2.new(half_body_width, half_body_height), CP::Vec2.new(half_body_width, -half_body_height)]
		@shape = CP::Shape::Poly.new(@body, shape_vertices, CP::Vec2.new(0, 0))
	    	@shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
		@shape.collision_type = :player_vehicle

		@shape.body.p = CP::Vec2.new(x, y)

		@space.add_body(@body)
		@space.add_shape(@shape)
    		@shape.body.a = rand(359).gosu_to_radians
		@explosion = SpriteAnimation.new({window: @window, imagefile: "images/explosion.png", x: 0, y: 0, z: ZOrdinals::PLAYER_EXPLOSION, width: 320, height: 240, speed: 50, loop: false, stopped_playing: lambda {
			@destroyed.call()
		}})
		
		@z = z
		@shadow_offset = 20
		@plane_sound = AudioManager::plane_sound.play(0.3)
		@is_dead = false
	end

	def set_destroyed_callback (callback)
		@destroyed = callback
	end

	def draw
		@plane_sound.pan = get_sound_pan#.play_pan(get_sound_pan, 0.1)
		if @explosion.playing? then
			@explosion.draw
		else 
			@body_image.draw_rot(@shape.body.p.x, @shape.body.p.y, @z, @shape.body.a.radians_to_gosu)
			@shadow.draw_rot(@shape.body.p.x - @shadow_offset, @shape.body.p.y + @shadow_offset, @z - 1, @shape.body.a.radians_to_gosu)
		end
		@shape.body.reset_forces
		Helpers.validate_position!(@window, @shape.body.p, @body_image)
		if @is_dead
			@plane_sound.stop
		end
	end

	def move (angle, hor, ver)
		if hor != 0 or ver != 0 then
			@shape.body.p.x += hor / 8.5 
			@shape.body.p.y += ver / 8.5
			@shape.body.a = angle.gosu_to_radians
		end
	end

	def explode
		@explosion.setXY(@shape.body.p.x - @body_image.width  - 50, @shape.body.p.y - @body_image.height - 50)
		@explosion.play
		AudioManager::player_explosion_sound.play(2)
		@space.remove_body(@body)
		@space.remove_shape(@shape)
	end

	def body
		@body
	end

	def shape
		@shape
	end

	def image
		@body_image
	end

	def xy
		xy = Struct.new(:x, :y)
		return xy.new(@shape.body.p.x, @shape.body.p.y)
	end

	def get_sound_pan
		screen_percentage = (@shape.body.p.x / @window.width) * 100
		(screen_percentage * 2) / 100 - 1
	end
end
