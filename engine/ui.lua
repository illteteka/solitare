local ui = {}

function ui.init()

	game_paused = false

	-- Pause menu option constants
	PAUSE_RESUME = 1
	PAUSE_QUIT = 2

	-- Load menus
	ui.loadPauseMenu()
	window.x, window.y = love.window.getPosition()

	ui.pause_timer = 0
	ui.pause_scroll_dir = 1

	ui.pause_menu_tip_cursor = 1
	ui.pause_menu_tip = {"RP_A is paused.", "This is another tip about RP_A being paused."}
	
end

function ui.loadPauseMenu()
	ui.pause_menu = {}
	ui.pause_menu.cursor = 1
	ui.addMenu("resume game", ui.pause_menu, PAUSE_RESUME)
	ui.addMenu("quit", ui.pause_menu, PAUSE_QUIT)
end

function ui.unpause()
	input.throw_away_timer = 2
	input.throw_away = true
end

function ui.draw()

	if game_paused then
		
		lg.push()
		lg.setColor(c_black[1], c_black[2], c_black[3], (255*0.75)/255)
		lg.rectangle("fill", -10, -10, window.screen_w+10, window.screen_h+10)
		
		--draw menu title
		lg.setColor({1,1,1,1})
		lg.push()
		lg.translate(window.x_offset, window.y_offset)
		local this_tip = ui.pause_menu_tip[ui.pause_menu_tip_cursor]
		this_tip = string.gsub(this_tip, "RP_A", GAME_NAME)
		lg.print(this_tip, 36, 48)
		lg.pop()
		
		ui.drawMenu(ui.pause_menu)
		
		lg.pop()
		
	end

end

function ui.drawMenu(menu)

	-- draw menu options
	local i = 1
	while i <= #menu do
		lg.setColor({1,1,1,1})
		lg.push()
		lg.translate(window.x_offset, window.y_offset)
		
		local append_before = ""
		local append_after = ""
		if menu.cursor == i then append_before, append_after = "> ", " <" end
		
		lg.printf(append_before .. menu[i].text .. append_after, 0, ((128+(48 * (i-1)))), (window.screen_w), "center", 0)
		lg.pop()
		i = i + 1
	end -- end while

end

function ui.update(dt)

	-- Detect if window moved and pause game
	local new_pos_x, new_pos_y = love.window.getPosition()
	if new_pos_x ~= window.x or new_pos_y ~= window.y then
		game_paused = true
		window.x, window.y = new_pos_x, new_pos_y
	end
	
	-- Pause with enter or esc
	if (enter_key == _RELEASE and game_paused == false) or escape_key == _RELEASE then
		game_paused = not game_paused
		if game_paused == false then
			ui.unpause()
		end
		
		-- These are also pause menu selection keys so they need to be cleared
		enter_key = _OFF
		escape_key = _OFF
	end

	-- If game mode can't be paused
	if LEVEL_SWITCH == LEVEL_TEST_1 or LEVEL_SWITCH == LEVEL_EDITOR then
		game_paused = false
	end
	
	-- Update pause menu
	if game_paused then
	
		ui.pause_menu.cursor = ui.updateCursor(ui.pause_menu, dt)
		
		-- Action for pause menu
		if z_key == _RELEASE or enter_key == _RELEASE or space_key == _RELEASE then
			
			local get_option = ui.pause_menu[ui.pause_menu.cursor].index
			
			if get_option == PAUSE_RESUME then
				game_paused = false
				ui.unpause()
			elseif get_option == PAUSE_QUIT then
				love.event.quit()
			end

			z_key = _OFF
			enter_key = _OFF
			space_key = _OFF
			
		end -- end action button on menu
	
	else -- end game paused
	
		-- Randomize menu tip
		ui.pause_menu_tip_cursor = math.random(#ui.pause_menu_tip)
	
	end

end

function ui.addMenu(text, menu, index)
	local tbl = {}
	tbl.text = text
	tbl.index = index
	table.insert(menu, tbl)
end

function ui.updateCursor(menu, dt)

	local cursor, menu_len = menu.cursor, #menu

	local pause_max = 20
	local pause_small = pause_max - 10
	local cursor_mult = 0

	-- Input for pause menu
	if up_key == _PRESS then
		cursor = cursor - 1
		ui.pause_scroll_dir = -1
	end
	
	if down_key == _PRESS then
		cursor = cursor + 1
		ui.pause_scroll_dir = 1
	end
	
	if cursor_dir ~= 0 then
		ui.pause_timer = math.min(ui.pause_timer + 60 * dt, pause_max)
	end
	
	if up_key == _RELEASE and down_key == _ON then
		ui.pause_scroll_dir = 1
	end
	
	if down_key == _RELEASE and up_key == _ON then
		ui.pause_scroll_dir = -1
	end
	
	if (up_key == _RELEASE or up_key == _OFF) and (down_key == _RELEASE or down_key == _OFF) then
		ui.pause_timer = 0
		cursor_mult = 0
	end
	
	if ui.pause_timer == pause_max then
		cursor_mult = 1
		ui.pause_timer = ui.pause_timer - pause_small
	end
	
	cursor = cursor + (ui.pause_scroll_dir * cursor_mult)
	
	-- Keep pause cursor in bounds
	if cursor < 1 then
		cursor = cursor + menu_len
	end
	
	if cursor > menu_len then
		cursor = cursor - menu_len
	end

	return cursor

end

return ui