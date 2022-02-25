--[[
	Developer Tools
	(Debug menus)
]]

local dev = {}

function dev.init()

	dev.debug_window = false
	dev.game_speed = 1
	dev.tri_count = 0

end

function dev.updateDebugMenu(dt)

	if dev.debug_window then
		-- Speed up or slow down game when pressing + or - in debug mode
		if plus_key == _PRESS then
			dev.game_speed = dev.game_speed + 0.25
			--music:setPitch(dev.game_speed)
		end

		if minus_key == _PRESS then
			dev.game_speed = math.max(dev.game_speed - 0.25, 0.25)
			--music:setPitch(dev.game_speed)
		end
	end

	-- Enter and exit debug mode
	if grave_key == _PRESS then
		dev.debug_window = not dev.debug_window
	end

	-- Change game speed
	if dev.game_speed ~= 1 then
		dt = dt * dev.game_speed
	end

	return dt

end

function dev.drawDebugMenu()

	-- Draw debug window
	if dev.debug_window then
		lg.setColor(0,0,1,0.5)
		lg.rectangle("fill",0,0,225,96)
		lg.setColor(c_white)
		lg.push()

		local _fps = love.timer.getFPS()
		lg.print("fps: " .. _fps, 16, 16)
		lg.print("speed: " .. dev.game_speed .. "x", 16, 40)
		lg.print("triangles: " .. dev.tri_count, 16, 64)
		lg.pop()
	end

	dev.tri_count = 0

end

return dev