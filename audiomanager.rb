module AudioManager
	@audio_folder = "audio/"

	def self.window=(window)
		@window = window
	end

	def self.intro_song
		@intro_song ||= Gosu::Song.new(@window, @audio_folder + "intro.mp3")
	end

	def self.fire_primary_sound
		@fire_primary_sound ||= Gosu::Sample.new(@window, @audio_folder + "luger.wav")
	end

	def self.health_pack_sound
		@health_pack_sound ||= Gosu::Sample.new(@window, @audio_folder + "healthpack_collect.wav")
	end

	def self.double_damage_sound
		@double_damage_sound ||= Gosu::Sample.new(@window, @audio_folder + "doubledamage.wav")
	end

	def self.plane_sound
		@plane_sound ||= Gosu::Sample.new(@window, @audio_folder + "plane.wav")
	end

	def self.player_explosion_sound
		@player_explosion_sound ||= Gosu::Sample.new(@window, @audio_folder + "player_explosion.wav")
	end

	def self.helper_ship_fire
		@helper_ship_fire ||= Gosu::Sample.new(@window, @audio_folder + "helper_ship_fire.wav")
	end
end
