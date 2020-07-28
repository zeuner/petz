local modpath, S = ...

--
-- Egg refilling
--

function petz.bh_refill_egg(self)
	if not self.lay_eggs then
	elseif 0 == self.recovering_eggs_count then
	else
		local now = minetest.get_gametime(
		)
		if (
			self.recovering_eggs_time + petz.settings.egg_recovery_delay
		) < now then
			self.recovering_eggs_count = mobkit.remember(
				self,
				"recovering_eggs_count",
				self.recovering_eggs_count - 1
			)
			minetest.log(
				"warning",
				"DEBUG recovering egg count " .. self.recovering_eggs_count
			)
			self.recovering_eggs_time = mobkit.remember(
				self,
				"recovering_eggs_time",
				now
			)
			minetest.log(
				"warning",
				"DEBUG recovering egg time " .. self.recovering_eggs_time
			)
		end
	end
end
