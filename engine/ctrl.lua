--[[
	Global game state controller
]]

local ctrl = {}

function ctrl.init()
	-- Init containers
	camera = {}
	mouse = {}

	-- Init camera
	camera.x = 0
	camera.y = 0
	camera.zoom = 1

	-- Init mouse
	mouse.x = 0
	mouse.y = 0
	-- Mouse relative to zoom and camera
	mouse.rx = 0
	mouse.ry = 0

	mouse.wheel = 0

	sleep = 0
end

function ctrl.update(dt)

	-- Get mouse pos, relative to screen scale
	mouse.x, mouse.y = (love.mouse.getX() - window.x_offset), (love.mouse.getY() - window.y_offset)

	local mx, my = mouse.x / window.scale, mouse.y / window.scale
	mx = (mx - camera.x)/camera.zoom
	my = (my - camera.y)/camera.zoom

	mouse.rx = mx
	mouse.ry = my

end

return ctrl