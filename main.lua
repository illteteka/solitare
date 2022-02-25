io.stdout:setvbuf("no")

polygon = require "engine.polygon"
input = require "engine.input"
lume = require "engine.lume"
ctrl = require "engine.ctrl"
window = require "engine.window"
dev = require "engine.dev"
ui = require "engine.ui"
instances = require "instances"
editor = require "engine.editor"
require "engine.utils"
require "solitare"

c_green = {48/255, 128/255, 90/255, 1}

lg = love.graphics
lk = love.keyboard

LEVEL_MAIN_MENU = 0
LEVEL_BOARD = 1
LEVEL_EDITOR = 2

LEVEL_SWITCH = LEVEL_MAIN_MENU

function love.load()

	GAME_NAME = "solitare"
	math.randomseed(os.time())

	polygon.init()
	dev.init()
	ctrl.init()
	
	-- Init window
	window.init()
	love.window.setTitle("solitare v1")

	ui.init()

	-- Load shaders
	shader_mask = lg.newShader("shaders/mask.frag")
	
	-- Loading models
	font = love.graphics.newFont("font.ttf", 18)
	love.graphics.setFont(font)
	
	mdl_card_back = polygon.new("soda/card_back.soda", true)
	mdl_card_front = polygon.new("soda/card_front.soda", true)
	mdl_club = polygon.new("soda/club.soda", true)
	mdl_diamond = polygon.new("soda/diamond.soda", true)
	mdl_heart = polygon.new("soda/heart.soda", true)
	mdl_spade = polygon.new("soda/spade.soda", true)

	-- load card font
	mdl_a = polygon.new("soda/font/a.soda", true)
	mdl_j = polygon.new("soda/font/j.soda", true)
	mdl_k = polygon.new("soda/font/k.soda", true)
	mdl_q = polygon.new("soda/font/q.soda", true)
	mdl_10 = polygon.new("soda/font/10.soda", true)
	mdl_9 = polygon.new("soda/font/9.soda", true)
	mdl_8 = polygon.new("soda/font/8.soda", true)
	mdl_7 = polygon.new("soda/font/7.soda", true)
	mdl_6 = polygon.new("soda/font/6.soda", true)
	mdl_5 = polygon.new("soda/font/5.soda", true)
	mdl_4 = polygon.new("soda/font/4.soda", true)
	mdl_3 = polygon.new("soda/font/3.soda", true)
	mdl_2 = polygon.new("soda/font/2.soda", true)

	-- load face cards
	mdl_bking = polygon.new("soda/bking.soda", true)
	mdl_bqueen = polygon.new("soda/bqueen.soda", true)
	mdl_bjack = polygon.new("soda/bjack.soda", true)
	mdl_rking = polygon.new("soda/rking.soda", true)
	mdl_rqueen = polygon.new("soda/rqueen.soda", true)
	mdl_rjack = polygon.new("soda/rjack.soda", true)

	-- Load levels
	main_menu = require "levels.main_menu"
	game_board = require "levels.board"

	if LEVEL_SWITCH == LEVEL_EDITOR then
		editor.init()
	else -- Load regular levels

		instances.load() -- Needs to happen before loading a level

		if LEVEL_SWITCH == LEVEL_MAIN_MENU then
			main_menu.init()
		elseif LEVEL_SWITCH == LEVEL_BOARD then
			game_board.init()
		end

	end
	
	polygon.rebuildCache()

	importCardVisual()

end

function love.update(dt)
	
	dt = dev.updateDebugMenu(dt)

	-- update keys
	input.update(dt)
	ctrl.update(dt)
	ui.update(dt)
	
	window.updateFullscreen()

	if sleep == 0 then
		if not game_paused then

			updateGame(dt)
		
		end
	else
		sleep = math.max(sleep - 60 * dt, 0)
	end

	if r_key == _RELEASE then
		gameReset()
	end

end

function updateGame(dt)

	if LEVEL_SWITCH == LEVEL_MAIN_MENU then
		main_menu.update(dt)
	elseif LEVEL_SWITCH == LEVEL_BOARD then
		game_board.update(dt)
	elseif LEVEL_SWITCH == LEVEL_EDITOR then
		editor.update(dt)
	end

end

function drawGame()

	if LEVEL_SWITCH == LEVEL_MAIN_MENU then
		main_menu.draw()
	elseif LEVEL_SWITCH == LEVEL_BOARD then
		game_board.draw()
	elseif LEVEL_SWITCH == LEVEL_EDITOR then
		editor.draw()
	end

end

function love.draw()

	window.draw()

	if LEVEL_SWITCH == LEVEL_EDITOR then
		editor.drawUI()
	end

	ui.draw()

	-- Always run this last
	dev.drawDebugMenu()

end

function love.resize(w, h)
	window.resize(w, h)
end

function love.focus(f)
	if f == false then
		game_paused = true
	end
end

function love.wheelmoved(x, y)
	mouse.wheel = y
end

function love.quit()
	polygon.clearCache()
end