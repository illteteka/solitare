local mm = {}

function mm.level()
	window.color = c_green
end

function mm.init()
	LEVEL_SWITCH = LEVEL_MAIN_MENU
	instances.clear()
	mm.level()
end

function mm.update(dt)

	if space_key == _PRESS then
		game_board.init()
	end

end

function mm.draw()
	
	lg.setColor(c_white)
	lg.printf("solitare! press space to start", 0, 100, window.w, "center")

end

return mm