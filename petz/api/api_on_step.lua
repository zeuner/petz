local modpath, S = ...

petz.on_step = function(self, dtime)
	if mobkit.timer(self, 1) and not(self.dead) then --Only check every 1 sec, not every step!
		if self.init_tamagochi_timer == true then
			petz.init_tamagochi_timer(self)
		end
		if self.is_pregnant == true then
			petz.pregnant_timer(self, 1)
		elseif self.is_baby == true then
			petz.growth_timer(self, 1)
		end
		if self.gallop == true then
			petz.gallop(self, 1)
		end
		if self.dreamcatcher then
			petz.dreamcatcher_save_metadata(self)
		end
		local lifetime = petz.check_lifetime(self)
		if lifetime then
			petz.lifetime_timer(self, lifetime, 1)
		end
	end
end
