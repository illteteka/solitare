local window = {}

function window.init()
	
	-- Global constants
	WINDOW_BG = c_black
	WINDOW_ASPECT_FIT = true
	EXPECTED_MAX_ZOOM = 3 -- !!! Max the game will zoom in (user controllable/camera zooms), decides if cached models look blurry

	-- Init window
	window.w = 720
	window.h = 405
	window.x = 0
	window.y = 0

	window.scale = 1
	window.x_offset = 0
	window.y_offset = 0

	window.screen_w = window.w
	window.screen_h = window.h

	local _, _, flags = love.window.getMode()
	local res_w, res_h = love.window.getDesktopDimensions( flags.display )
	window.display_w = res_w
	window.display_h = res_h
	window.half_w = math.floor(window.w / 2)
	window.half_h = math.floor(window.h / 2)

	window.scale = math.min( math.floor(window.screen_w/window.w), math.floor(window.screen_h/window.h))

	window.color = c_black
	
	-- Set the window
	window.set(false)

end

function window.set(fs)
	local _, _, flags = love.window.getMode()
	love.window.setMode(window.screen_w, window.screen_h, {resizable=true, minwidth=window.w, minheight=window.h, fullscreen=fs, highdpi=true, usedpiscale=true, display=flags.display})
	game_paused = true
	enter_key = _OFF
	
	-- Update/create global constants used by cache
	DPI_SCALE = lg.getDPIScale()
	MAX_GUI_SCALE = window.getMaxGUIScale()
	
	polygon.rebuildCache()
end

function window.updateFullscreen()

	-- Toggle fullscreen with alt + enter or F4
	if input.altCombo(enter_key) or f4_key == _PRESS then
		local isfs = love.window.getFullscreen()
		
		if isfs then
			window.resize(window.w, window.h)
		end
		
		window.set(not isfs)
	end

end

function window.resize(w, h)

	window.screen_w = w
	window.screen_h = h
	
	window.scale = math.min((w/window.w), (h/window.h))
	if not WINDOW_ASPECT_FIT then
		window.scale = math.floor(window.scale)
	end

	window.x_offset = (window.screen_w - (window.w*window.scale))/2
	window.y_offset = (window.screen_h - (window.h*window.scale))/2

end

function window.draw()

	local center_fullscreen_window = window.x_offset ~= 0 or window.y_offset ~= 0
	
	-- Screen offset
	-- Push the game window over, creates black bars if the window isn't the same aspect ratio as what the game's expecting
	if center_fullscreen_window then
	lg.setColor(WINDOW_BG)
	lg.rectangle("fill", 0, 0, window.screen_w, window.screen_h)
	
	lg.push()
	lg.translate(window.x_offset, window.y_offset)
	end
		
		-- Screen scaling
		lg.push()
		lg.scale(window.scale)
		love.graphics.setScissor(window.x_offset, window.y_offset, window.w * window.scale, window.h * window.scale)
		
		-- Draw window background

		lg.setColor(window.color)
		lg.rectangle("fill", 0, 0, window.w, window.h)
		
		-- Center window
		lg.push()
		
			local rnd = (window.w/(window.scale*window.w))
			if rnd == 1 then rnd = 0.5 end
			
			lg.translate(lume.round(camera.x, rnd),lume.round(camera.y, rnd))

			lg.scale(camera.zoom)
			drawGame()
		
		lg.pop()
		-- End center window

		-- End draw window background
		
		love.graphics.setScissor()
		lg.pop() -- End screen scaling
	
	if center_fullscreen_window then
	lg.pop() -- End screen offset
	end

end

function window.getMaxGUIScale()

	-- how large does the largest monitor allow you to scale
	local num_monitors = love.window.getDisplayCount()
	local i = 1
	local max_w, max_h = 0, 0
	while i <= num_monitors do
		local ww, hh = love.window.getDesktopDimensions(i)
		max_w = math.max(max_w, ww)
		max_h = math.max(max_h, hh)
		i = i + 1
	end
	
	return math.max( math.ceil(max_w/window.w), math.ceil(max_h/window.h))

end

return window