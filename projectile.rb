class Projectile
	attr_accessor :damage

	def initialize (window, space, image, angle, damage, shooter)
		@window = window
		@space = space

		@image = image
		@body = CP::Body.new(5, 50)
		half_body_height = @image.height / 2
		half_body_width = @image.width / 2
		shape_vertices = [CP::Vec2.new(-half_body_width, -half_body_height), CP::Vec2.new(-half_body_width, half_body_height), CP::Vec2.new(half_body_width, half_body_height), CP::Vec2.new(half_body_width, -half_body_height)]
		@shape = CP::Shape::Poly.new(@body, shape_vertices, CP::Vec2.new(0, 0))
	    	@shape.body.v = CP::Vec2.new(0.0, 0.0) # velocity
		@shape.collision_type = :bullet

		@space.add_body(@body)
		@space.add_shape(@shape)
    		@shape.body.a = angle.gosu_to_radians# (3*Math::PI/2.0) # angle in radians; faces towards top of screen
		self.damage = damage
		@shape.obj = {projectile: self, shooter: shooter}
	end

	def set_position (x, y)
		#@shape.body.p = CP::Vec2.new(x + 90, y + 90)
		@shape.body.p = CP::Vec2.new(x, y)
	end

	def draw
		@image.draw_rot(@shape.body.p.x, @shape.body.p.y, 5, @shape.body.a.radians_to_gosu)
	end

	def update
		@shape.body.p.x += Gosu::offset_x(@body.a.radians_to_gosu, 2.4)
		@shape.body.p.y += Gosu::offset_y(@body.a.radians_to_gosu, 2.4)
	end

	def shape
		@shape
	end
	
	def remove
		@space.remove_body(@body)
		@space.remove_shape(@shape) #causes a seg-fault in 
	end

	def is_in_screen
		x = @shape.body.p.x
		y = @shape.body.p.y
		(x < @window.width and x > 0) and (y < @window.height and y > 0)
	end
end
