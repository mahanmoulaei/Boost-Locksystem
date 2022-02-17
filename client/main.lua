local searchedVeh = {}
local startedEngine = {}
local uiOpen = false
local PlayerPed = nil
local mainThread = nil
local lockThread = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    
	TriggerServerEvent('JL-LockSystem:Refresh')
	TriggerServerEvent('JL-LockSystem:SyncEngine')
end)

CreateThread(function()
    RegisterCommand('search', Search)
end)

mainThread = SetInterval(function()
	local PlayerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(PlayerPed, true)
    local plate = GetVehicleNumberPlateText(veh)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    if not isInVehicle then SetInterval(mainThread, 500) end

    if isInVehicle and GetPedInVehicleSeat(veh, -1) == PlayerPed then
        if startedEngine[plate] == true then
			SetInterval(mainThread, 500)
            SetVehicleEngineOn(veh, true, true, false)
        else
			SetInterval(mainThread, 0)
            SetVehicleEngineOn(veh, false, false, true)
        end
    end
end, 250)

lockThread = SetInterval(function()
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
        local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
	    local lock = GetVehicleDoorLockStatus(veh)
	    if lock == Config.LockStateLocked then
	        ClearPedTasks(ped)
	    end
    else SetInterval(lockThread, 500)  end
end, 10)

function Search()
	local PlayerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    local plate = GetVehicleNumberPlateText(vehicle)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    ESX.TriggerServerCallback('JL-LockSystem:HasKeys', function(hasKeys) 
        if hasKeys then
            Notification('info', _('has_key'))
            return
        end
        if isInVehicle then
            if searchedVeh[plate] then
                Notification('error', _('no_key_veh'))
            else
			
                if Config.OnlyRegisteredCars then
                    ESX.TriggerServerCallback('JL-LockSystem:IsCarRegistered', function(isRegistered) 
                        if isRegistered then
                            searchedVeh[plate] = true
                            Notification('success', _('found_key'))
                            TriggerServerEvent('JL-LockSystem:AddKeys', plate)
                        else
                            Notification('error', _('not_registered'))
                        end
                    end, plate)
                else
                    searchedVeh[plate] = true
                    Notification('success', _('found_key'))
                    TriggerServerEvent('JL-LockSystem:AddKeys', plate)
                end
            end
        end
    end, plate)
end

exports('JL-LockSystem:LockUnlock', function(data, slot)
    if not slot.metadata.plate then Notification('error', 'The key has no metadata !') return end
    OpenUi(slot.metadata.plate)
end)

RegisterNUICallback('Close', function(data)
    CloseUi()
end)

RegisterNUICallback('Lock', function(data)
	local PlayerPed = PlayerPedId()
    local veh = ESX.Game.GetClosestVehicle()
    if veh == -1 then
        Notification('error', _('no_veh_nearby'))
        return
    end
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehLockStatus = GetVehicleDoorLockStatus(veh)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    local plate = GetVehicleNumberPlateText(veh)
    if data.plate ~= plate then
        Notification('error', _('key_not_owned_car'))
        return
    end
    if isInVehicle then
        if vehLockStatus == 1 then
            --Progress(_('pr_lock'), 300)
            SetVehicleDoorsLocked(veh, Config.LockStateLocked)
            Notification('success', _('lock_veh'))
        else
            Notification('error', _('locked'))
        end
    else
        if vehLockStatus == 1 then
            if #(playerCoords - GetEntityCoords(veh)) <= 4.0 then
				PlayAnimation()
                --Progress(_('pr_lock'), 300)
                SetVehicleDoorsLocked(veh, Config.LockStateLocked)
                Notification('success', _('lock_veh'))
            else
                Notification('error',_('too_far_veh'))
            end
        else
            Notification('error', _('locked'))
        end
    end
end)

RegisterNUICallback('Unlock', function(data)
	local PlayerPed = PlayerPedId()
    local veh = ESX.Game.GetClosestVehicle()
    if veh == -1 then
        Notification('error', _('no_veh_nearby'))
        return
    end
    local playerCoords = GetEntityCoords(PlayerPed)
    local vehLockStatus = GetVehicleDoorLockStatus(veh)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    local plate = GetVehicleNumberPlateText(veh)
    if data.plate ~= plate then
        Notification('error', _('key_not_owned_car'))
        return
    end
    if isInVehicle then
        if vehLockStatus == Config.LockStateLocked then
            --Progress(_('pr_unlock'), 300)
            SetVehicleDoorsLocked(veh, 1)
            Notification('success', _('unlock_veh'))
        else
            Notification('error', _('unlocked'))
        end
    else
        if vehLockStatus == Config.LockStateLocked then
            if #(playerCoords - GetEntityCoords(veh)) <= 4.0 then
                PlayAnimation()
				--Progress(_('pr_unlock'), 300)
                SetVehicleDoorsLocked(veh, 1)
                Notification('success', _('unlock_veh'))
            else
                Notification('error',_('too_far_veh'))
            end
        else
            Notification('error', _('unlocked'))
        end
    end
end)

RegisterNUICallback('Engine', function(data)
	local PlayerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(PlayerPed, true)
    local plate = GetVehicleNumberPlateText(vehicle)
    local isInVehicle = IsPedInAnyVehicle(PlayerPed, false)
    local plate = GetVehicleNumberPlateText(veh)
    if isInVehicle then
        if data.plate ~= plate then
            Notification('error', _('key_not_owned_car'))
            return
        end
        if not startedEngine[plate] then
            Progress(_('pr_engine_on'), 2000)
            startedEngine[plate] = true
            TriggerServerEvent('JL-LockSystem:SyncEngine', plate, true)
        else
            Progress(_('pr_engine_off'), 1000)
            startedEngine[plate] = false
            TriggerServerEvent('JL-LockSystem:SyncEngine', plate, false)
        end
    end
end)

loadAnimDict = function(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Wait(0)
    end
end

RegisterNetEvent('JL-LockSystem:SetUpSearched', function(data)
    searchedVeh = data
end)

RegisterNetEvent('JL-LockSystem:SetUpEngine', function(data)
    startedEngine = data
end)

function OpenUi(plate)
    if not uiOpen then
        SetNuiFocus(true, true)
        SendNUIMessage({
            show = true,
            plate = plate
        })
        uiOpen = true
    end
end

function CloseUi()
    if uiOpen then
        SetNuiFocus(false, false)
        SendNUIMessage({
            show = false,
            plate = ''
        })
        uiOpen = false
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
		CloseUi()
    end
    
end)

function BlinkVehicleLight(vehicle)
	SetVehicleInteriorlight(vehicle, true)
	SetVehicleIndicatorLights(vehicle, 0, true)
	SetVehicleIndicatorLights(vehicle, 1, true)
	Citizen.Wait(450)
	SetVehicleIndicatorLights(vehicle, 0, false)
	SetVehicleIndicatorLights(vehicle, 1, false)
	Citizen.Wait(450)
	SetVehicleInteriorlight(vehicle, true)
	SetVehicleIndicatorLights(vehicle, 0, true)
	SetVehicleIndicatorLights(vehicle, 1, true)
	Citizen.Wait(450)
	SetVehicleInteriorlight(vehicle, false)
	SetVehicleIndicatorLights(vehicle, 0, false)
	SetVehicleIndicatorLights(vehicle, 1, false)
end

function PlayAnimation()
	local playerPed = PlayerPedId()
	local library = "anim@mp_player_intmenu@key_fob@"
	local animmation = "fob_click"

	ESX.Streaming.RequestAnimDict(library, function()
		TaskPlayAnim(playerPed, library, animmation, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
	
	local keyFob = CreateObject(GetHashKey("p_car_keys_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(keyFob, playerPed, GetPedBoneIndex(playerPed, 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
	
	DeleteEntity(keyFob)
    ClearPedTasksImmediately(PlayerPed)
end

RegisterNetEvent('JL-LockSystem:AddKeysOfTheVehiclePedIsIn', function()
    local PlayerPed = PlayerPedId()
    local veh
	local timeout = 1000
	repeat
		Wait(0)
		timeout = timeout - 1
		veh = GetVehiclePedIsIn(PlayerPed, true)
	until veh ~= 0 or timeout < 1
	
	local plate = GetVehicleNumberPlateText(veh)
	if plate and plate ~= nil and plate ~= "" and plate ~= " " then
		TriggerServerEvent('JL-LockSystem:AddKeys', plate)
	end
end)