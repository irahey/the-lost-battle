
class Helpers
	def self.angle_from_coordinates(x1, y1, x2, y2)
		a = b = Gosu::distance(x1, y1, x2, y2)
		if a > 0 then
			c = Gosu::distance(0, 0 - a, x2, y2)
			cosc = (a ** 2 + b ** 2 - c ** 2) / (2 * a * b)
			angle = Math.acos(cosc) * (180 / Math::PI)
			if x2 < 0 then
				angle = 360 - angle
			end
			return angle
		end
		return 0
	end

	#TODO: fix issue with xy starting at top or in the middle
	def self.validate_position!(window, item, image)
		if item.x + (image.width / 2) >= window.width then # left
			item.x = window.width - (image.width / 2)
		elsif (item.x  - (image.width/2))<= 0 then #right
			item.x = (image.width / 2)
		end
		if item.y >= (window.height - image.height/2) then #bottom
			item.y = window.height - image.height/2
		elsif (item.y - (image.height/2)) <= 0 then
			item.y = (image.height / 2)
		end
	end
end
