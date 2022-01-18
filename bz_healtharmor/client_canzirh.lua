Citizen.CreateThread(function()
	while true do
		-- local playerStatus
		-- local showPlayerStatus = 0
		local health = GetEntityHealth(PlayerPedId())
		local armor = GetPedArmour(PlayerPedId()) 
		
		-- playerStatus = { action = 'setStatus', status = {} }
		
		-- showPlayerStatus = (showPlayerStatus+1)

			-- playerStatus['isdead'] = false

			-- playerStatus['status'][showPlayerStatus] = {
				-- name = 'health',
				-- value = health
			-- }
			
		-- if IsEntityDead(PlayerPedId()) then
				-- playerStatus.isdead = true
			-- end

		-- showPlayerStatus = (showPlayerStatus+1)

		-- playerStatus['status'][showPlayerStatus] = {
				-- name = 'armor',
				-- value = armor,
			-- }
		
		SendNUIMessage({action = "hud",
						health = health,
						armor = armor,
						})
						
		-- if showPlayerStatus > 0 then
			-- SendNUIMessage(playerStatus)
		-- end
		
		
		Citizen.Wait(200)
	end
end)