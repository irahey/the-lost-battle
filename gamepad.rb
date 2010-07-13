require 'joystick'

class GamePad

	def self.available_gamepads
		max_num_to_test, base_path, gamepads = 5, "/dev/input/js", Array.new
		max_num_to_test.times do |n|
			begin
				jpath = "/dev/input/js" + n.to_s
				Joystick::Device.new jpath
				gamepads << jpath
			rescue Exception => e
				#not joystick on this port
			end
		end
		gamepads
	end

	def initialize (js_port, configuration)
		@joystick = Joystick::Device.new js_port
		@old_value = @old_action = @old_type = nil
		@config = configuration
		@movement_controls = Array[configuration.vehicle_movement, configuration.crosshair_movement]
		@vehicle_horizontal = @vehicle_vertical = @crosshair_vertical = @crosshair_horizontal = 0
	end

	def update (key_input = nil)
		triple_shot = fire_main = false
		if @joystick.pending? then
			ev = @joystick.ev
			case ev.type
				when Joystick::Event::BUTTON
					#p "button: #{ev.num}: #{ev.val}"
					if ev.val == 1 and ev.num == @config.fire_main
						fire_main = true
					end
					if ev.val == 1 and ev.num == @config.triple_shot
						triple_shot = true
					end
				when Joystick::Event::AXIS
					#p "axis: #{ev.num}: #{ev.val}"
					@movement_controls.each do |c|
						if (c.has_value? ev.num) then
							case c[:type]
								when :vehicle
									if ev.num == c[:horizontal] then
										@vehicle_horizontal = ev.val
									else
										@vehicle_vertical = ev.val
									end
								when :crosshair
									if ev.num == c[:horizontal] then
										@crosshair_horizontal = ev.val
									else
										@crosshair_vertical = ev.val
									end
							end
							break
						end
					end
			end
		end

		return {input: :gamepad, 
			actions: {
				fire_main: fire_main, 
				triple_shot: triple_shot,
				movement_crosshair: {horizontal: @crosshair_horizontal, vertical: @crosshair_vertical},
				movement_vehicle: {horizontal: @vehicle_horizontal, vertical: @vehicle_vertical}
		}}
	end
end
