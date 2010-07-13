class PlayerListing
	attr_accessor :text_field, :controller_type, :joystick_path, :vehicle, :crosshair
	def initialize (window, init_x, init_y, p_number, controller, joystick_path = "")
		@x, @y, @z = init_x, init_y, ZOrdinals::MENU_CURSOR - 1
		font = Gosu::Font.new(window, Gosu::default_font_name, 20)
		self.vehicle = Gosu::Image.new(window, "images/players/#{p_number.to_s}.png", false)
		self.crosshair = Gosu::Image.new(window, "images/crosshairs/#{p_number.to_s}.png", false)
		@text_field = TextField.new(window, font, init_x + 100, init_y + vehicle.height, @z)
		@controller_image = Gosu::Image.new(window, "images/icons/#{controller == :mouse ? "mouse" : "joystick"}.png", false)
		self.joystick_path = joystick_path
		self.controller_type = controller
	end

	def draw
		vehicle.draw(@x, @y, @z)
		crosshair.draw(@x + 100 - crosshair.width / 2, @y, @z)
		@controller_image.draw(@x + 130, @y, @z)
		@text_field.draw
	end


	def will_play? 
		@text_field.text != ""
	end

	def name
		@text_field.text
	end
end
