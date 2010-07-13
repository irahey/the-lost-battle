class GamepadConfig
	attr_accessor :vehicle_movement, :crosshair_movement, :fire_main, :triple_shot

	def initialize (vehicle_movement, crosshair_movement, fire_main, triple_shot)
		self.vehicle_movement = vehicle_movement
		self.crosshair_movement = crosshair_movement
		self.fire_main = fire_main
		self.triple_shot = triple_shot

		self.vehicle_movement[:type] = :vehicle
		self.crosshair_movement[:type] = :crosshair
	end
end
