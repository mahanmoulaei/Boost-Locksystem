local searchedVeh = {}
local startedEngine = {}
local searchedFile
local ox_inventory = exports.ox_inventory

ESX.RegisterServerCallback('JL-LockSystem:HasKeys', function(source, cb, _plate)
    if HasKeys(source, _plate) then
		if not searchedVeh[_plate] or searchedVeh[_plate] == false then
			searchedVeh[_plate] = true
			TriggerEvent('JL-LockSystem:Refresh')
		end
		cb(true)
	else
		cb(false)
	end    
end)

ESX.RegisterServerCallback('JL-LockSystem:IsCarRegistered', function(source, cb, _plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', 
    {['@plate'] = _plate}, 
    function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('JL-LockSystem:AddKeys', function(_plate)
    local _source = source
    if HasKeys(_source, _plate) then
        return
    end
    searchedVeh[_plate] = true
    TriggerEvent('JL-LockSystem:Refresh')
    if ox_inventory:CanCarryItem(_source, 'car_keys', 1) then
        ox_inventory:AddItem(_source, 'car_keys', 1, {plate = _plate, description = _U('key_description',_plate)})
    end
end)

RegisterServerEvent('JL-LockSystem:CreateKeyCopy', function(_plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name ~= 'mechanic' then
        DropPlayer(xPlayer.source, 'kunet bezaram chaghal?')
        return
    end
    if ox_inventory:CanCarryItem(xPlayer.source, 'car_keys', 1) then
        ox_inventory:AddItem(xPlayer.source, 'car_keys', 1, {plate = _plate, description = _U('key_description',_plate)})
    end
end)

RegisterServerEvent('JL-LockSystem:RemoveKey', function(_plate)
	if searchedVeh[_plate] or searchedVeh[_plate] == true then
		searchedVeh[_plate] = false
		TriggerEvent('JL-LockSystem:Refresh')
		TriggerEvent('JL-LockSystem:SyncEngine', _plate, false)
	end
    HasKeys(source, _plate, true)
end)

RegisterServerEvent('JL-LockSystem:Refresh', function()
    if tablelength(searchedVeh) < 1 then
        searchedFile = LoadResourceFile(GetCurrentResourceName(), './searchedVeh.json')
        searchedVeh = json.decode(searchedFile)
        print('[^6JL-LockSystem^0] Refreshed ' .. tablelength(json.decode(searchedFile)) .. ' searched vehicles !')
        TriggerClientEvent('JL-LockSystem:SetUpSearched', -1, searchedVeh)
    else
        searchedFile = LoadResourceFile(GetCurrentResourceName(), './searchedVeh.json')
        SaveResourceFile(GetCurrentResourceName(), 'searchedVeh.json', json.encode(searchedVeh), -1)
        print('[^6JL-LockSystem^0] Refreshed ' .. tablelength(json.decode(searchedFile)) .. ' searched vehicles !')
        TriggerClientEvent('JL-LockSystem:SetUpSearched', -1, searchedVeh)
    end
end)

RegisterServerEvent('JL-LockSystem:SyncEngine', function(_plate, state)
	if _plate and state then	
		startedEngine[_plate] = state
	end
	
    SyncEngine()
end)

function SyncEngine()
	print('[^6JL-LockSystem^0] Synced ' .. tablelength(startedEngine) .. ' engines !')
    TriggerClientEvent('JL-LockSystem:SetUpEngine', -1, startedEngine)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
		Wait(500)
		SaveResourceFile(GetCurrentResourceName(), 'searchedVeh.json', "{}", -1)
		TriggerEvent('JL-LockSystem:Refresh')
    end
end)

function HasKeys(source, plate, remove)
    local keys = ox_inventory:Search(source, 'slots', 'car_keys')
	if keys then
		for k,v in pairs(keys) do
			if v.metadata.plate == plate then
				if remove then
					ox_inventory:RemoveItem(source, 'car_keys', v.slot)
					return true
				else
					return true
				end
			end
		end
	end
  
    return false
end
  
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
