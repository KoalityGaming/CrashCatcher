--[[
	An addon to catch crazy ragdolls and hopefully stop them before they can crash the server
]]--
hook.Add("Think","AMB_CrashCatcher",function()
	for k, ent in pairs(ents.FindByClass("prop_ragdoll")) do
		if IsValid(ent) then
			if ent.player_ragdoll then
				local velo = ent:GetVelocity( ):Length()
				if velo >= 1500 and velo < 5000 then
					AMB_KillVelocity(ent)
					print("[!CRASHCATCHER!] Caught velocity > 1500 on a ragdoll entity, negating velocity and temporarily disabling motion.\n")
				elseif velo >= 5000 then
					ent:Remove()
					print("[!CRASHCATCHER!] Caught velocity > 2500 on a ragdoll entity, removing offending ragdoll entity from world.\n")
				end
			end
		end
	end
end)

function AMB_SetSubPhysMotionEnabled(ent, enable)
   if not IsValid(ent) then return end

   for i=0, ent:GetPhysicsObjectCount()-1 do
      local subphys = ent:GetPhysicsObjectNum(i)
      if IsValid(subphys) then
         subphys:EnableMotion(enable)
         if enable then
            subphys:Wake()
         end
      end
   end
end

function AMB_KillVelocity(ent)
   ent:SetVelocity(vector_origin)

   -- The only truly effective way to prevent all kinds of velocity and
   -- inertia is motion disabling the entire ragdoll for a tick
   -- for non-ragdolls this will do the same for their single physobj
   AMB_SetSubPhysMotionEnabled(ent, false)

   timer.Simple(0, function() AMB_SetSubPhysMotionEnabled(ent, true) end)
end

