local ESX	 = nil
-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

Citizen.CreateThread(function()

	while true do

	local playerStatus 
	local showPlayerStatus = 0
	playerStatus = { action = 'setStatus', status = {} }


		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'hunger',
				value = math.floor(100-status.getPercent())
			}
		end)


		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'thirst',
				value = math.floor(100-status.getPercent())
			}
		end)
		
		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('esx_status:getStatus', 'stress', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'stress',
				value = math.floor(status.getPercent())
			}
		end)

	if showPlayerStatus > 0 then
		SendNUIMessage(playerStatus)
	end

	Citizen.Wait(5000)
end
end)
