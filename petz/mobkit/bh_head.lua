local modpath, S = ...

function petz.bh_look_at(self, player_pos, prty)
	if not(self.status == "looking") then
		mobkit.animate(self, "idle")
		petz.hq_look_at(self, player_pos, prty)
		return true
	end
end

function petz.hq_look_at(self, player_pos, prty)
	local func = function(self)
		if not(self.status == "looking") then
			local random_time = math.random(2, 3)
			petz.move_head(self, player_pos)
			minetest.after(random_time, function(self)
				if mobkit.is_alive(self) then
					mobkit.clear_queue_low(self)
					mobkit.clear_queue_high(self)
					petz.return_head_to_origin(self)
					self.looking = false
					self.status = ""
					return true
				end
			end, self)
			self.status = "looking"
		end
	end
	mobkit.queue_high(self, func, prty)
end

--a movement test to move the head
function petz.move_head(self, tpos)
	local head_position, head_rotation = self.object:get_bone_position("head") -- get the pos and rotation of the head bone. Currently causes a bug!
	local pos = self.object:get_pos() --the pos of the mob
	tpos.y = tpos.y + 1.625 -- the pos of the eyes of the player
	if not(self.head_position) then
		local head_position, head_rotation = self.object:get_bone_position("head")
		self.head_position = vector.add(head_position, self.head.position_correction) --correction of the pos by cause of the bug, and save it
	end
	local direction = vector.direction(pos, tpos) -- vector direction from mob to player's eyes
	local look_at_dir = vector.normalize(direction) -- important: normalize the vector
	-- Functions to calculate the pitch & yaw (in degrees):
	local pitch = mokapi.yaw_to_degrees(math.asin(look_at_dir.y))
	local yaw =mokapi.yaw_to_degrees(math.atan2(look_at_dir.x, look_at_dir.z))
	local body_yaw = mokapi.yaw_to_degrees(self.object:get_yaw()) --yaw of the body in degrees
	local final_yaw = yaw + body_yaw --get the head yaw in reference with the body
	head_rotation = {x= pitch, y= final_yaw, z= 0} -- the head movement {pitch, yaw, roll}
	self.head_rotation = vector.add(head_rotation, self.head.rotation_origin) --the offset for the rotation, depends on the blender model
	self.object:set_bone_position("head", self.head_position, self.head_rotation) --set the head movement
end

--this sets the mob to move it's head back to pointing forwards
petz.return_head_to_origin = function(self)
	self.object:set_bone_position("head", self.head_position, self.head.rotation_origin)
end
