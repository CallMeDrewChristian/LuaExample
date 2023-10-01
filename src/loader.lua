local Functions = {}
local Train = script.Parent.Train.Value
local ContextActionService = game:GetService('ContextActionService');
local RunService  = game:GetService('RunService')
local DoorKeybind = {Enum.KeyCode.Q, Enum.KeyCode.E}
Functions = {
	["Client"] = {
		["RightDoor"] = {	
			["Debounce"] = false;
			["Function"] = function(Name, InputState, InputObj)
				local self = Functions["Client"][Name]
				local Value = Train:GetAttribute("RightDoor")
			end;
		};
		["LeftDoor"] = {	
			["Debounce"] = false;
			["Function"] = function(Name, InputState, InputObj)
				local self = Functions["Client"][Name]
				local Value = Train:GetAttribute("LeftDoor")
			end;
		};
		["Gear"] = {	
			["Debounce"] = false;
			["Function"] = function(Name, InputState, InputObj)
				local GearIncrement = tonumber(Name)
				local Value = Train:GetAttribute("Gear")
				Train:SetAttribute("Gear", math.clamp(Value + GearIncrement, -1, 1))
			end;
		};
		["Horn"] = {
			["Function"] = function(Name, InputState, InputObj)
				local self = Functions["Client"][Name]
				if InputState == Enum.UserInputState.Begin then
					--Set CarA/B--
					print("H On")
					Functions["SendToServer"](Name, true)
				else
					print("H Off")
					Functions["SendToServer"](Name, nil)
				end
			end;
		};
	};
	["Server"] = {
		["Horn"] = {
			["Function"] = function(HornHeld)
				if HornHeld then
					print("Held")
				else
					print("LetGo")
				end
			end;
		};
	};
	["SendToServer"] = function(...)
		script.RemoteEvent:FireServer(...)
	end,
}


	if RunService:IsClient() then
		print("Client")
		if Train:GetAttribute("Opposite") then
			DoorKeybind = {Enum.KeyCode.E, Enum.KeyCode.Q}
		end
		print("Starting to BindAction")
		ContextActionService:BindAction("LeftDoor", Functions["Client"]["LeftDoor"]["Function"], false, DoorKeybind[1])
		ContextActionService:BindAction("RightDoor", Functions["Client"]["RightDoor"]["Function"], false, DoorKeybind[2])
		ContextActionService:BindAction("-1", Functions["Client"]["Gear"]["Function"], false, Enum.KeyCode.LeftBracket)
		ContextActionService:BindAction("1", Functions["Client"]["Gear"]["Function"], false, Enum.KeyCode.RightBracket)
		ContextActionService:BindAction("Horn", Functions["Client"]["Horn"]["Function"], false, Enum.KeyCode.H)
	else
		print("Server")
	script.RemoteEvent.OnServerEvent:Connect(function(Player, FunctionName, ...)
			Functions["Server"][FunctionName]["Function"](...)
		end)
	end



return Functions
