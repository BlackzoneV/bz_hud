local seatbeltInput = 182                   -- Toggle seatbelt on/off with K or DPAD down (controller)
local seatbeltPlaySound = true              -- Play seatbelt sound
local seatbeltDisableExit = true            -- Disable vehicle exit when seatbelt is enabled
local seatbeltEjectSpeed = 45.0             -- Speed threshold to eject player (MPH)
local seatbeltEjectAccel = 100.0            -- Acceleration threshold to eject player (G's)
local seatbeltColorOn = {160, 255, 160}     -- Color used when seatbelt is on
local seatbeltColorOff = {255, 96, 96}      -- Color used when seatbelt is off
local enableCruise = false
local motorcruise = false

function getVehicleInDirection(coordFrom, coordTo)
    local playerPed = PlayerPedId()
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, playerPed, 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
local pedInVeh = false
local seatbeltIsOn = false
Citizen.CreateThread(function()
	local currSpeed = 0.0
	while true do
		sleep = 2000
		local player = PlayerPedId()
		local position = GetEntityCoords(player)
		local vehicle = GetVehiclePedIsIn(player, false)

		-- Set vehicle states
		if IsPedInAnyVehicle(player, false) then
            pedInVeh = true
            sleep = 5
		else
			-- Reset states when not in car
			pedInVeh = false
			seatbeltIsOn = false
			motorcruise = false
		end
		local vehicleClass = GetVehicleClass(vehicle)
		if pedInVeh and vehicleClass ~= 13 then
			local prevSpeed = currSpeed
			currSpeed = GetEntitySpeed(vehicle)

			-- Set PED flags
			SetPedConfigFlag(player, 32, true)
			if IsControlJustReleased(0, seatbeltInput) and (enableController or GetLastInputMethod(0)) and vehicleClass ~= 8 then
				-- Toggle seatbelt status and play sound when enabled
				seatbeltIsOn = not seatbeltIsOn
			end
			
			if IsControlJustReleased(0, seatbeltInput) and (enableController or GetLastInputMethod(0)) and vehicleClass ~= 8 and seatbeltIsOn then
                TriggerEvent("seatbelt:sounds", "buckle", 0.3)
                Citizen.Wait(500)
                -- exports['mythic_notify']:SendAlert('inform', 'Kemer takıldı.')
                TriggerEvent('notification', 'Kemer takıldı.', 1)
            end
			if IsControlJustReleased(0, seatbeltInput) and (enableController or GetLastInputMethod(0)) and motorcruise == false then
			motorcruise = true
			TriggerEvent('np-carhud:cruiseresmon')
			end
            
            if IsControlJustReleased(0, seatbeltInput) and (enableController or GetLastInputMethod(0)) and vehicleClass ~= 8 and seatbeltIsOn == false then
                TriggerEvent("seatbelt:sounds", "unbuckle", 0.3)
                Citizen.Wait(500)
                -- exports['mythic_notify']:SendAlert('inform', 'Kemer çıkartıldı.')
                TriggerEvent('notification', 'Kemer çıkartıldı.', 2)
			end
			if not seatbeltIsOn then
				-- Eject PED when moving forward, vehicle was going over 45 MPH and acceleration over 100 G's
				local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
				local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
				if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
					SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
					SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
					Citizen.Wait(0)
					SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
				else
					-- Update previous velocity for ejecting player
					prevVelocity = GetEntityVelocity(vehicle)
				end
			elseif seatbeltDisableExit then
				-- Disable vehicle exit when seatbelt is on
				DisableControlAction(0, 75)
			end
        end
        Citizen.Wait(sleep)
	end
end)

AddEventHandler('seatbelt:sounds', function(soundFile, soundVolume)
    SendNUIMessage({
      transactionType     = 'playSound',
      transactionFile     = soundFile,
      transactionVolume   = soundVolume
    })
  end)

local zoneNames = {
AIRP = "Los Santos Uluslararası Havalimanı",
ALAMO = "Alamo Denizi",
ALTA = "Alta",
ARMYB = "Zancudo Kalesi",
BANHAMC = "Banham Kanyonu Dr",
BANNING = "Banning",
BAYTRE = "Baytree Kanyonu", 
BEACH = "Vespucci Plajı",
BHAMCA = "Banham Kanyonu",
BRADP = "Braddock Gecidi",
BRADT = "Braddock Tüneli",
BURTON = "Burton",
CALAFB = "Calafia Köprüsü",
CANNY = "Raton Kanyonu",
CCREAK = "Cassidy Deresi",
CHAMH = "Chamberlain Tepesi",
CHIL = "Vinewood Tepesi",
CHU = "Chumash",
CMSW = "Chiliad Dağı Eyalet Cölü",
CYPRE = "Cypress Düzlükleri",
DAVIS = "Davis",
DELBE = "Del Perro Plajı",
DELPE = "Del Perro",
DELSOL = "La Puerta",
DESRT = "Grand Senora Cölü",
DOWNT = "Sehir Merkezi",
DTVINE = "Vinewood Sehir Merkezi",
EAST_V = "Dogu Vinewood",
EBURO = "El Burro Tepesi",
ELGORL = "El Gordo Deniz Feneri",
ELYSIAN = "Elysian Adası",
GALFISH = "Galilee",
GALLI = "Galileo Parkı",
golf = "GWC ve Golf Toplulugu",
GRAPES = "Üzüm Cekirdegi",
GREATC = "Büyük Chaparral",
HARMO = "Harmony",
HAWICK = "Hawick",
HORS = "Vinewood Yarıs Pisti",
HUMLAB = "Humane Laboratuvar ve Arastırma Merkezi",
JAIL = "Bolingbroke Cezaevi",
KOREAT = "Küçük Seoul",
LACT = "Land Act Rezervuarı",
LAGO = "Zancudo Gölü",
LDAM = "Land Act Barajı",
LEGSQU = "Lejyon Meydanı",
LMESA = "La Mesa",
LOSPUER = "La Puerta",
MIRR = "Mirror Parkı",
MORN = "Morningwood",
MOVIE = "Richards Majestic",
MTCHIL = "Chiliad Dagı",
MTGORDO = "Gordo Dagı",
MTJOSE = "Josiah Dagı",
MURRI = "Murrieta Tepesi",
NCHU = "Kuzey Chumash",
NOOSE = "N.O.O.S.E",
OCEANA = "Pasifik Okyanusu",
PALCOV = "Paleto Koyu",
PALETO = "Paleto Bay",
PALFOR = "Paleto Ormanları",
PALHIGH = "Palomino Yaylası",
PALMPOW = "Palmer-Taylor Elektrik Santrali",
PBLUFF = "Pasifik Uçurumu",
PBOX = "Pillbox Tepesi",
PROCOB = "Procopio Plajı",
RANCHO = "Rancho",
RGLEN = "Richman Glen",
RICHM = "Richman",
ROCKF = "Rockford Tepesi",
RTRAK = "Redwood Isık İzi",
SanAnd = "San Andreas",
SANCHIA = "San Chianski Sıradagları",
SANDY = "Sandy Sahili",
SKID = "Mission Row",
SLAB = "Stab Sehri",
STAD = "Maze Bank Arena",
STRAW = "Strawberry",
TATAMO = "Tataviam Dagı",
TERMINA = "Terminal",
TEXTI = "Textile Sehri",
TONGVAH = "Tongva Tepesi",
TONGVAV = "Tongva Vadisi",
VCANA = "Vespucci Kanalı",
VESP = "Vespucci",
VINE = "Vinewood",
WINDF = "Ron Alternates Rüzgar Degirmenleri",
WVINE = "Batı Vinewood",
ZANCUDO = "Zancudo Nehri",
ZP_ORT = "Güney Los Santos Limanı",
ZQ_UAR = "Davis Quartz"
}

local seatbelt = false
RegisterNetEvent("seatbelt")
AddEventHandler("seatbelt", function(belt)
    seatbelt = belt
end)

local time = "12:00"
RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(h,m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)



local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed, false)
local Mph = GetEntitySpeed(vehicle) * 3.6
local uiopen = false
local colorblind = false
local compass_on = false

RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

Citizen.CreateThread(function()
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    playerStreetsLocation = zoneNames[tostring(zone)]

    if not zone then
        zone = "UNKNOWN"
        zoneNames['UNKNOWN'] = zone
    elseif not zoneNames[tostring(zone)] then
        local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
        zoneNames[tostring(zone)] = "Undefined Zone"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
    else
        playerStreetsLocation = "[" .. zoneNames[tostring(zone)] .. "]"
    end

    while true do
        local sleep = 1000
		Citizen.Wait(sleep)
        local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
        zone = tostring(GetNameOfZone(x, y, z))
        playerStreetsLocation = zoneNames[tostring(zone)]
		if IsPedInAnyVehicle(player) then
		sleep = 500
		end
        if not zone then
            zone = "UNKNOWN"
            zoneNames['UNKNOWN'] = zone
        elseif not zoneNames[tostring(zone)] then
            local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
            zoneNames[tostring(zone)] = "Undefined Zone"
        end

        if intersectStreetName ~= nil and intersectStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
        elseif currentStreetName ~= nil and currentStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | [" .. zoneNames[tostring(zone)] .. "]"
        else
            playerStreetsLocation = "[".. zoneNames[tostring(zone)] .. "]"
        end
        -- compass = getCardinalDirectionFromHeading(math.floor(GetEntityHeading(player) + 0.5))
        -- street = compass .. " | " .. playerStreetsLocation
        street = playerStreetsLocation
 
        if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then          

            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                }) 
            end
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            Fuel = exports["LegacyFuel"]:GetFuel(vehicle)
            Mph = math.ceil(GetEntitySpeed(vehicle) * 3.6)
            local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end

            local atl = false
            if IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(vehicle) * 3.28084)
            end
            local engine = false
            if GetVehicleEngineHealth(vehicle) < 400.0 then
                engine = true
            end
            local GasTank = false
            if GetVehiclePetrolTankHealth(vehicle) < 3002.0 then
                GasTank = true
            end


            SendNUIMessage({
              open = 2,
              mph = Mph,
              fuel = math.ceil(Fuel),
              street = street,
              belt = seatbeltIsOn,
              time = hours .. ':' .. mins,
              colorblind = colorblind,
              atl = atl,
              engine = engine,
              GasTank = GasTank
            }) 

        else

            if uiopen and not compass_on then
                SendNUIMessage({
                  open = 3,
                }) 

                uiopen = false
            end

            compass_on = false
        end
end
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2000
        local player = PlayerPedId()
        local veh = GetVehiclePedIsIn(player, false)
        local headingg = (-GetEntityHeading(player) % 360)
        if IsPedInAnyVehicle(player, false) then
            sleep = 100
        end
        if IsVehicleEngineOn(veh) then
            -- in vehicle
            SendNUIMessage({
                open = 2,
                direction = math.floor(calcHeading(headingg)),
            })
        elseif compass_on == true then
            -- has compass toggled
            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end

            SendNUIMessage({
                open = 4,
                time = time,
                direction = math.floor(calcHeading(headingg)),
            })
            
        else
            Citizen.Wait(3000)
        end
        Citizen.Wait(sleep)
    end
end)


 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end

-- Hız Sabitleyici
	Citizen.CreateThread(function()
		while true do 
           local sleep = 2000
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            local vehicleModel = GetEntityModel(vehicle)
            local speed = GetEntitySpeed(vehicle)
            local float Max = GetVehicleMaxSpeed(vehicleModel) * 3.6
                if (ped) then
				local inVehicle = IsPedSittingInAnyVehicle(ped)
                       if (inVehicle) then
					   sleep = 5
                    if IsControlJustPressed(1, 20) then
                            if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                                if enableCruise == false then
                                    SetEntityMaxSpeed(vehicle, speed)
                                    TriggerEvent('notification', 'Hız sabitleyici açıldı: '.. math.floor(speed*3.6)..' kmh', 1)
                                    enableCruise = true
                                else
                                
                                    SetEntityMaxSpeed(vehicle, Max)
                                    TriggerEvent('notification', 'Hız sabitleyici kapatıldı', 2)
                                    enableCruise = false
                                end
                            end
                        end
                    end
                end
				Citizen.Wait(sleep)
            end
		end)