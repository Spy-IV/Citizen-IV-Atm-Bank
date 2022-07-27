--================================================================================================--
--==                                VARIABLES                                                   ==--
--================================================================================================--
inMenu                   = true
local atbank             = false
local bankMenu           = true
local bankmoney          = 0 --change this to yours
local money              = 0 --change this to yours
local uiopen = false

--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local px,py,pz = GetCharCoordinates(GetPlayerChar(-1), _f, _f, _f)
			local atmmodel = GetHashKey("gb_cashmachine01")
			local atmmodel2 = GetHashKey("gb_cashmachine01_hi")
			local atmmodel3 = GetHashKey("gb_cashmachine02")
			local atmmodel4 = GetHashKey("gb_cashmachine_hi")
			if(DoesObjectOfTypeExistAtCoords(px, py, pz, 2.0, atmmodel) or DoesObjectOfTypeExistAtCoords(px, py, pz, 2.0, atmmodel2) or DoesObjectOfTypeExistAtCoords(px, py, pz, 2.0, atmmodel3) or DoesObjectOfTypeExistAtCoords(px, py, pz, 2.0, atmmodel4)) then
				if(IsGameKeyboardKeyJustPressed(18)) then
					if(uiopen == 0) then
						openUI()
						TriggerServerEvent('bank:balance')
						local ped = GetPlayerChar(-1)
						SetPlayerControl(GetPlayerId(), false)
						uiopen = true
					else
						uiopen = false
						closeUI()
						SetPlayerControl(GetPlayerId(), true)
					end
				end
			end
		end
	end)
end
--===============================================
--==             Balance                       ==
--===============================================

RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local playerName = GetPlayerName(GetPlayerId())

	SendNUIMessage({
		type = "balanceHUD",
		balance = bankmoney,
		player = playerName
		})
end)
--===============================================
--==           Deposit and withdraw Event       ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('withdraw')
AddEventHandler('withdraw', function(amount)
	if(bankmoney >= amount) then
		money = money + amount
		bankmoney = bankmoney - amount
		
		TriggerEvent("noticeme:Info", "You have withdrawed " .. amount .. ".Rs from your bank") -- download this from https://citizeniv.net/d/207-freerelease-noticeme-notifications
	else
		TriggerEvent("noticeme:Info", "You dont have enough money in your bank")-- download this from https://citizeniv.net/d/207-freerelease-noticeme-notifications
	end
end)

RegisterNetEvent('deposit')
AddEventHandler('deposit', function(amount)
	if(money >= amount) then
		bankmoney = bankmoney + amount
		money = money - amount
		TriggerEvent("noticeme:Info", "You have Deposited " .. amount .. ".Rs to your bank")
	else
		TriggerEvent("noticeme:Info", "You dont have enough money")
	end
end)


--===============================================
--==          Withdraw Event                   ==9ikymhVB
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)


--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	closeUI()
end)

function closeUI()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end

function openUI()
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
	TriggerServerEvent('bank:balance')
end

function IsPlayerNearCoords(x, y, z, radius)
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
    local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3]-1.1);
	if dist < radius then 
		return true
	else 
		return false
    end
end
