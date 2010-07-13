require 'scrollingbackground.rb'
class Background
	
	TERRAIN_FOLDER = "images/terrain/"

	def initialize (window)
		@window = window
		@sea = ScrollingBackground.new(window, TERRAIN_FOLDER + "sea.png", 0, 0, ZOrdinals::SEA)
		@cloud = ScrollingBackground.new(window, TERRAIN_FOLDER + "cloud.png", 900, 500, ZOrdinals::CLOUD_1)
		@cloud1 = ScrollingBackground.new(window, TERRAIN_FOLDER + "cloud1.png", 49, 0, ZOrdinals::CLOUD_2)
		@cloud2 = ScrollingBackground.new(window, TERRAIN_FOLDER + "cloud2.png", 100, 200, ZOrdinals::CLOUD_3)
		@island = Gosu::Image.new(window, TERRAIN_FOLDER + "island.png", false)
	end

	def update
		@sea.scroll(0.2, 0)
		@cloud.scroll(0.6, 0)
		@cloud1.scroll(0.9, 0)
		@cloud2.scroll(0.3, 0)
	end

	def draw
		@sea.draw
		@cloud.draw
		@cloud1.draw
		@cloud2.draw
		@island.draw_rot(@window.width / 2, @window.height / 2, ZOrdinals::ISLAND, 0)
	end
end
