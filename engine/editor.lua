local editor = {}

--[[
	Editor do once
]]
function editor.load()

	window.color = {6/255,13/255,69/255,1}
	smallfont = love.graphics.newFont("font.ttf", 9)

	-- Import editor icons
	edit_move  = polygon.new("soda/editor/edit_move.soda")
	edit_grid  = polygon.new("soda/editor/edit_grid.soda")
	edit_reset = polygon.new("soda/editor/edit_reset.soda")
	edit_trash = polygon.new("soda/editor/edit_trash.soda")
	edit_print = polygon.new("soda/editor/edit_print.soda")
	edit_default = polygon.new("soda/editor/edit_default.soda")

	editor.toolbar = {}
	editor.addTool("MOVE", edit_move)
	editor.addTool("GRID", edit_grid)
	editor.addTool("RESETCAM", edit_reset)
	editor.addTool("TRASH", edit_trash)
	editor.addTool("PRINT", edit_print)

	editor.toolbar.x = 16
	editor.toolbar.y = 80
	editor.toolbar.btn_size = 24
	editor.toolbar.w = editor.toolbar.btn_size * 2
	editor.toolbar.h = math.ceil(#editor.toolbar / 2) * editor.toolbar.btn_size

	editor.modes = {}

	editor.importObject("NONE", "")

	editor.current_mode = 1
	editor.current_object = 1
	editor.current_level = 1
	
	editor.is_moving = false
	editor.move_group   = 0 -- Type of object being moved
	editor.move_obj     = 0 -- Individual instance ^^
	editor.move_model   = edit_default -- Move object's model

	editor.levels = {}

end

function editor.init()

	editor.load()

	editor.level_w = 5
	editor.level_h = 5

	editor.initCamera()

	editor.mouse = {}
	local emouse = editor.mouse
	emouse.x = 0
	emouse.y = 0
	emouse.start_x = 0
	emouse.start_y = 0
	emouse.is_selecting = false

	instances.load()

	editor.importLevels()

end

function editor.importLevels()

	local win_color = window.color

	editor.copyLevel(main_menu)
	editor.copyLevel(game_board)

	-- Reset window color back
	window.color = win_color

end

function editor.updateMouse(dt)

	local emouse = editor.mouse
	emouse.x = math.floor(mouse.rx/48)
	emouse.y = math.floor(mouse.ry/48)

	local etool = editor.toolbar
	local toolbar_is_active = CheckCollision(mouse.x, mouse.y, 1, 1, etool.x, etool.y, etool.w, etool.h)

	local emove, egrid, etrash = editor.getActiveTools()

	if mouse_switch == _PRESS then

		if not toolbar_is_active then
			emouse.start_x, emouse.start_y = emouse.x, emouse.y
			emouse.is_selecting = true
			
			
			if emove then
				editor.checkInstanceMoveable()
			end
			
		end

	end
	
	if mouse_switch == _ON then
	
		if editor.is_moving then
		
			local this_lvl = editor.levels[editor.current_level]
			local this_obj = this_lvl[editor.move_group].data[editor.move_obj]
			local ww, hh = polygon.width(editor.move_model)/2, polygon.height(editor.move_model)/2
			
			if egrid then

				this_obj.x = math.floor(mouse.rx/48) * 48
				this_obj.y = math.floor(mouse.ry/48) * 48

			else
			
				this_obj.x = math.floor(mouse.rx - ww)
				this_obj.y = math.floor(mouse.ry - hh)
			
			end
		
		end
	
	end

	if mouse_switch == _RELEASE then

		if not toolbar_is_active then

			if emove then
				-- Do nothing
			elseif etrash then

				editor.deleteInstance()

			else
				editor.placeInstance(egrid)
			end

		end
		
		if editor.is_moving then
		
			editor.move_group = 0
			editor.move_obj = 0
			editor.move_model = edit_default
			editor.is_moving = false
		
		end

		emouse.is_selecting = false
	end

end

function editor.export()

	print("--------------------START--------------------")
	
	local this_lvl = editor.levels[editor.current_level]
	local i = 1
	while i <= #this_lvl do
	
		local this_create = editor.getExport(this_lvl[i].name)
	
		local j = 1
		while j <= #this_lvl[i].data do
		
			local this_obj = this_lvl[i].data[j]
			local exp_str = this_create .. "("
			exp_str = exp_str .. this_obj.x .. ", "
			exp_str = exp_str .. this_obj.y .. ")"
			print(exp_str)
			
			j = j + 1
		
		end
		i = i + 1
	
	end
	
	print("---------------------END---------------------")

end

function editor.checkInstanceMoveable()

	local this_lvl = editor.levels[editor.current_level]

	local move_group = -1
	local move_obj = -1
	local move_model = edit_default
	
	local i = 1
	while i <= #this_lvl do

		local this_model = editor.getModel(this_lvl[i].name)

		if this_lvl[i] ~= nil and this_lvl[i].data ~= nil then
			local j = 1
			while j <= #this_lvl[i].data do

				local this_obj = this_lvl[i]
				local xx, yy = this_obj.data[j].x, this_obj.data[j].y
				local ww, hh = polygon.width(this_model), polygon.height(this_model)
				local check_clicked = CheckCollision(xx, yy, ww, hh, mouse.rx, mouse.ry, 1, 1)

				if check_clicked then
					move_group = i
					move_obj = j
					move_model = this_model
					j = #this_lvl[i].data + 1
				end

				j = j + 1

			end
		else
			i = #this_lvl + 1
		end

		i = i + 1
	end

	if move_group ~= -1 then
		editor.is_moving = true
		editor.move_group   = move_group
		editor.move_obj     = move_obj
		editor.move_model   = move_model
	end

end

function editor.deleteInstance()

	local this_lvl = editor.levels[editor.current_level]

	local delete_group = -1
	local delete_obj = -1
	
	local i = 1
	while i <= #this_lvl do

		local this_model = editor.getModel(this_lvl[i].name)

		if this_lvl[i] ~= nil and this_lvl[i].data ~= nil then
			local j = 1
			while j <= #this_lvl[i].data do

				local this_obj = this_lvl[i]
				local xx, yy = this_obj.data[j].x, this_obj.data[j].y
				local ww, hh = polygon.width(this_model), polygon.height(this_model)
				local check_clicked = CheckCollision(xx, yy, ww, hh, mouse.rx, mouse.ry, 1, 1)

				if check_clicked then
					delete_group = i
					delete_obj = j
					j = #this_lvl[i].data + 1
				end

				j = j + 1

			end
		else
			i = #this_lvl + 1
		end

		i = i + 1
	end

	if delete_group ~= -1 then
		table.remove(this_lvl[delete_group].data, delete_obj)
	end

end

function editor.placeInstance(grid_on)

	local this_lvl = editor.levels[editor.current_level]
	
	local selected_obj = editor.modes[editor.current_mode].objects[editor.current_object]
	local selected_mdl = editor.modes[editor.current_mode].model[editor.current_object]

	local i = 1
	while i <= #this_lvl do

		if this_lvl[i].name == selected_obj then
			local obj_tbl = this_lvl[i].data
			local mf = math.floor
			local mx, my = mouse.rx, mouse.ry
			local pw, ph = polygon.width(selected_mdl)/2, polygon.height(selected_mdl)/2

			if grid_on then

				mx = math.floor(mouse.rx/48) * 48
				my = math.floor(mouse.ry/48) * 48
				pw, ph = 0, 0

			end

			editor.insertObject(obj_tbl, mf(mx - pw), mf(my - ph))
		end
		i = i + 1
	end

end

function editor.draw()

	love.graphics.setFont(smallfont)

	local emouse = editor.mouse
	local etool = editor.toolbar

	-- Draw current level

	local i = 1
	local this_lvl = editor.levels[editor.current_level]
	while i <= #this_lvl do

		-- Retrieve the model the object uses for the editor
		local this_model = editor.getModel(this_lvl[i].name)

		-- Draw all objects
		local j = 1
		while j <= #this_lvl[i].data do

			local this_obj = this_lvl[i].data[j]
			local xx, yy = this_obj.x, this_obj.y

			lg.push()
			lg.translate(xx, yy)
			lg.setColor(c_white)
			polygon.draw(this_model)
			lg.pop()

			j = j + 1

		end

		i = i + 1

	end

	-- End draw current level

	local toolbar_is_active = CheckCollision(mouse.x, mouse.y, 1, 1, etool.x, etool.y, etool.w, etool.h)

	if not toolbar_is_active then

		-- Draw mouse cursor box
		if emouse.is_selecting then
			lg.setColor({0,1,0,1})
			rect_thick(emouse.start_x*48, emouse.start_y*48, (emouse.x * 48) - (emouse.start_x*48), (emouse.y * 48) - (emouse.start_y*48), 2/camera.zoom)
		else
			lg.setColor({1,0,0,1})
			rect_thick(emouse.x*48, emouse.y*48, 48, 48, 2/camera.zoom)
		end

	end

	-- Draw level boundary
	lg.setColor({1,1,1,1})
	rect_thick(48, 48, editor.level_w*48, editor.level_h*48, 2/camera.zoom)
	
	-- Draw don't place boundary
	lg.setColor({1,0,0,0.5})
	rect_thick_topleft(48, 48, (math.abs(camera.x) + window.w)/camera.zoom, (math.abs(camera.y) + window.h)/camera.zoom, 2/camera.zoom)

end

function editor.drawUI()

	lg.push()
	lg.translate(window.x_offset, window.y_offset)
	lg.translate(16, 16)
	lg.setColor(c_white)

	local mf = math.floor

	local data_camera = mf(camera.x) .. ", " .. mf(camera.y)
	local data_mouse = mf(mouse.rx) .. ", " .. mf(mouse.ry)
	local data_grid = mf(mouse.rx/48) .. ", " .. mf(mouse.ry/48)
	local data_zoom = mf(mf(camera.zoom * 10000) / 100) .. "%"
	local data_ed = editor.modes[editor.current_mode].name .. " " .. editor.modes[editor.current_mode].objects[editor.current_object]

	lg.print("camera: "   .. data_camera, 0, 0)
	lg.print("mouse: "    .. data_mouse,  0, 11)
	lg.print("grid: "     .. data_grid,   0, 22)
	lg.print("editor: "   .. data_ed,     0, 33)
	lg.print("zoom: "     .. data_zoom,   0, 44)

	editor.drawToolbar()

	local emouse = editor.mouse

	if emouse.is_selecting then
		local select_x = emouse.x - emouse.start_x
		local select_y = emouse.y - emouse.start_y

		lg.setColor({0,1,0,1})
		lg.printf("size: " .. select_x .. ", " .. select_y, 0, 16, (window.screen_w), "center")
	end

	lg.pop()

	love.graphics.setFont(font)

end

function editor.drawToolbar()

	local etool = editor.toolbar

	local i = 1
	local xx, yy = 0, 0
	local px, py = etool.x - 16, etool.y - 16

	local button_size = etool.btn_size
	local hover_color = {234/255, 41/255, 181/255, 1}
	local press_color = {242/255, 169/255, 224/255, 1}
	local active_color = {234/255, 41/255, 181/255, 0.4}

	lg.push()
	lg.translate(px, py)

	while i <= #etool do

		lg.push()
		lg.translate(xx, yy)

		local button_color = c_white
		local is_hovered = 0
		local is_active = etool[i].active

		if CheckCollision(mouse.x, mouse.y, 1, 1, px + xx + 16, py + yy + 16, button_size, button_size) then
			button_color = hover_color
			is_hovered = 1

			if mouse_switch == _ON then
				button_color = press_color
			end

		end

		if is_active then
			lg.setColor(active_color)
			lg.rectangle("fill", 0,0,button_size - 1,button_size - 1)
		end

		lg.setColor(button_color)
		rect_thick(0,0,button_size - 1,button_size - 1,1 + is_hovered * 2)
		lg.scale(1)
		polygon.draw(etool[i].model)

		xx = xx + button_size
		if xx > button_size then
			xx = 0
			yy = yy + button_size
		end

		lg.pop()

		i = i + 1
	end

	lg.pop()

end

function editor.updateToolbar(dt)

	local etool = editor.toolbar

	local i = 1
	local xx, yy = 0, 0
	local px, py = etool.x - 16, etool.y - 16

	local button_size = etool.btn_size

	while i <= #etool do

		local button_color = c_white
		local is_hovered = 0

		if CheckCollision(mouse.x, mouse.y, 1, 1, px + xx + 16, py + yy + 16, button_size, button_size) then
			is_hovered = 1

			if mouse_switch == _PRESS then

				local tool_clicked = etool[i].name

				if tool_clicked == "RESETCAM" then
					editor.initCamera()
				elseif tool_clicked == "TRASH" then
					etool[i].active = not etool[i].active
				elseif tool_clicked == "GRID" then
					etool[i].active = not etool[i].active
				elseif tool_clicked == "MOVE" then
					etool[i].active = not etool[i].active
				elseif tool_clicked == "PRINT" then
					editor.export()
				end

			end

		end

		xx = xx + button_size
		if xx > button_size then
			xx = 0
			yy = yy + button_size
		end

		i = i + 1
	end

end

function editor.update(dt)

	editor.updateMouse(dt)
	editor.updateToolbar(dt)
	editor.updateCamera(dt)
	editor.updateScroll(dt)
	
	if f3_key == _PRESS then
		print_r(editor.levels[editor.current_level])
	end

end

function editor.updateScroll(dt)

	if mouse.wheel ~= 0 then

		if z_key == _ON then
			editor.updateZoom(dt)
		end

		local mode_switch = editor.current_object
		local mode_list = editor.modes[editor.current_mode].objects

		if lshift_key == _ON then

			mode_switch = editor.current_mode
			mode_list = editor.modes

		elseif lalt_key == _ON then

			mode_switch = editor.current_level
			mode_list = editor.levels

		end
	
		if mouse.wheel < 0 then
			mode_switch = mode_switch - 1
		end
		
		if mouse.wheel > 0 then
			mode_switch = mode_switch + 1
		end
		
		if mode_switch < 1 then
			mode_switch = #mode_list
		end
		
		if mode_switch > #mode_list then
			mode_switch = 1
		end
		
		if lshift_key == _ON then -- Change object group

			editor.current_mode = mode_switch
			editor.current_object = 1

		elseif lalt_key == _ON then -- Change level

			editor.current_level = mode_switch
			instances.clear()
			instances.list = editor.levels[editor.current_level]

		else -- Change object
			
			editor.current_object = mode_switch
		end

	end

	mouse.wheel = 0

end

function editor.updateZoom(dt)

	local old_cam_x, old_cam_y, old_zoom = camera.x, camera.y, camera.zoom

	local mx, my
	mx = (mouse.x / window.scale) - camera.x
	my = (mouse.y / window.scale) - camera.y

	local dscale = 1.1

	local k = dscale^mouse.wheel
	camera.zoom = camera.zoom * k

	camera.x = math.floor(camera.x + mx*(1-k)+0.5)
	camera.y = math.floor(camera.y + my*(1-k)+0.5)

	if camera.zoom < 0.1 or camera.zoom > 1000 then
		camera.x, camera.y, camera.zoom = old_cam_x, old_cam_y, old_zoom
	end

end

function editor.updateCamera(dt)
	local c_spd = 4

	if w_key == _ON then
		camera.y = camera.y + c_spd * dt * 60
	end

	if s_key == _ON then
		camera.y = camera.y - c_spd * dt * 60
	end

	if a_key == _ON then
		camera.x = camera.x + c_spd * dt * 60
	end

	if d_key == _ON then
		camera.x = camera.x - c_spd * dt * 60
	end

end

-- Editor helper methods

function editor.addTool(name, icon)
	local tbl = {}
	tbl.name = name
	tbl.model = icon
	tbl.active = false
	table.insert(editor.toolbar, tbl)
end

function editor.importObject(category, name, create, model)

	-- Only load editor objects if we're in the editor
	local only_load_in_editor = LEVEL_SWITCH == LEVEL_EDITOR

	if only_load_in_editor then

		if not model then
			model = edit_default
		end

		-- Look through existing categories
		-- Add the new object to the category if it exists
		local i = 1
		local add_mode = true
		while i <= #editor.modes do

			if editor.modes[i].name == category then

				local j = 1
				local object_exists = false
				while j <= #editor.modes[i].objects do

					if editor.modes[i].objects[j] == name then
						object_exists = true
					end
					j = j + 1
				end

				if object_exists == false then
					table.insert(editor.modes[i].objects, name)
					table.insert(editor.modes[i].create, create)
					table.insert(editor.modes[i].model, model)
				end

				add_mode = false

			end

			i = i + 1

		end

		-- If the category doesn't exist, make a new one
		if add_mode then
			local tbl = {}
			tbl.name = category

			tbl.create = {}
			table.insert(tbl.create, create)

			tbl.objects = {}
			table.insert(tbl.objects, name)

			tbl.model = {}
			table.insert(tbl.model, model)

			table.insert(editor.modes, tbl)
		end

	end

end

function editor.insertObject(src, x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(src, tbl)
end

function editor.copyLevel(lvl)

	lvl.level()
	local tbl = lume.sclone(instances.list)
	instances.clear()
	
	table.insert(editor.levels, tbl)

	editor.current_level = #editor.levels

end

function editor.initCamera()

	camera.x = window.half_w - 48
	camera.y = window.half_h - 48
	camera.zoom = 1

end

function editor.getActiveTools()

	local emove, egrid, etrash = false, false, false

	local i = 1
	while i <= #editor.toolbar do

		if editor.toolbar[i].name == "MOVE" and editor.toolbar[i].active then
			emove = true
		end

		if editor.toolbar[i].name == "GRID" and editor.toolbar[i].active then
			egrid = true
		end

		if editor.toolbar[i].name == "TRASH" and editor.toolbar[i].active then
			etrash = true
		end

		i = i + 1
	end

	return emove, egrid, etrash

end

function editor.getModel(object_name)

	-- Retrieve the model the object uses for the editor
	local this_model = edit_default
	local k = 1
	while k <= #editor.modes do

		local m = 1
		while m <= #editor.modes[k].objects do

			if editor.modes[k].objects[m] == object_name then
				this_model = editor.modes[k].model[m]
			end
			m = m + 1

		end

		k = k + 1
	end

	return this_model

end

function editor.getExport(object_name)

	-- Retrieve the code the object uses for the editor
	local this_create = ""
	local k = 1
	while k <= #editor.modes do

		local m = 1
		while m <= #editor.modes[k].objects do

			if editor.modes[k].objects[m] == object_name then
				this_create = editor.modes[k].create[m]
			end
			m = m + 1

		end

		k = k + 1
	end

	return this_create

end

function rect_thick(x,y,w,h,t)
	lg.rectangle("fill",x,y,w-t,t)
	lg.rectangle("fill",x+t,y+h-t,w-t,t)
	lg.rectangle("fill",x,y+t,t,h-t)
	lg.rectangle("fill",x+w-t,y,t,h-t)
end

function rect_thick_topleft(x,y,w,h,t)
	lg.rectangle("fill",x,y,w-t,t)
	lg.rectangle("fill",x,y+t,t,h-t)
end

return editor
