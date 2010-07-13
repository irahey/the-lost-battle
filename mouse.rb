
class Mouse

	SPEED = 30000

	def initialize (window)
		@window = window
		@vehicle_vertical = @vehicle_horizontal = 0
	end

	def update (key_input = nil)
		vehicle_vertical = vehicle_horizontal = 0
		fire_main = triple_shot = false
		if key_input == Gosu::MsLeft then
			fire_main = true
		end

		if key_input == Gosu::MsRight then
			triple_shot = true
		end

		if @window.button_down? Gosu::KbW then
				vehicle_vertical = -SPEED
		end
		if @window.button_down? Gosu::KbA then
				vehicle_horizontal = -SPEED
		end
		if @window.button_down? Gosu::KbS then
				vehicle_vertical = SPEED
		end
		if @window.button_down? Gosu::KbD then
				vehicle_horizontal = SPEED
		end

		return {input: :mouse,
			actions: {
				fire_main: fire_main,
				triple_shot: triple_shot,
				movement_crosshair: {horizontal: @window.mouse_x, vertical: @window.mouse_y},
				movement_vehicle: {horizontal: vehicle_horizontal, vertical: vehicle_vertical}
		}}
	end
end
