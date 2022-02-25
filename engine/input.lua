local input = {}

-- Used when pausing the game
input.throw_away = false
input.throw_away_timer = 0

_OFF = 0
_ON = 1
_PRESS = 2
_RELEASE = 3

lalt_key = _OFF
ralt_key = _OFF
enter_key = _OFF
space_key = _OFF
lshift_key = _OFF

r_key = _OFF
z_key = _OFF

up_key = _OFF
down_key = _OFF
left_key = _OFF
right_key = _OFF

w_key = _OFF
s_key = _OFF
a_key = _OFF
d_key = _OFF

escape_key = _OFF
f3_key = _OFF
f4_key = _OFF

minus_key = _OFF
plus_key = _OFF
grave_key = _OFF

mouse_switch = _OFF

function input.combo(a, b)
	return (a == _ON and b == _PRESS) or (a == _PRESS and b == _ON) or (a == _PRESS and b == _PRESS)
end

function input.ctrlCombo(a)
	return input.combo(lctrl_key, a) or input.combo(rctrl_key, a)
end

function input.altCombo(a)
	return input.combo(lalt_key, a) or input.combo(ralt_key, a)
end

function input.pullSwitch(a, b, ignore)

	local output = b

	if input.throw_away and not ignore then
		output = _OFF
	else
	
		-- Main input code
		if a then

			if b == _OFF or b == _RELEASE then
				output = _PRESS
			elseif b == _PRESS then
				output = _ON
			end

		else

			if b == _ON or b == _PRESS then
				output = _RELEASE
			elseif b == _RELEASE then
				output = _OFF
			end

		end
		-- End main input code
	
	end

	return output

end

function input.update(dt)

	input.throw_away_timer = math.max(input.throw_away_timer - 60 * dt, 0)
	if input.throw_away_timer == 0 then
		input.throw_away = false
	end

	mouse_switch = input.pullSwitch(love.mouse.isDown(1), mouse_switch)
	
	r_key = input.pullSwitch(love.keyboard.isDown("r"), r_key)
	z_key = input.pullSwitch(love.keyboard.isDown("z"), z_key)
	lshift_key = input.pullSwitch(love.keyboard.isDown("lshift"), lshift_key)
	lalt_key = input.pullSwitch(love.keyboard.isDown("lalt"), lalt_key)
	ralt_key = input.pullSwitch(love.keyboard.isDown("ralt"), ralt_key)
	enter_key = input.pullSwitch(love.keyboard.isDown("return"), enter_key)
	space_key = input.pullSwitch(love.keyboard.isDown("space"), space_key)
	escape_key = input.pullSwitch(love.keyboard.isDown("escape"), escape_key)
	f3_key = input.pullSwitch(love.keyboard.isDown("f3"), f3_key)
	f4_key = input.pullSwitch(love.keyboard.isDown("f4"), f4_key)
	
	up_key = input.pullSwitch(love.keyboard.isDown("up"), up_key)
	down_key = input.pullSwitch(love.keyboard.isDown("down"), down_key)
	left_key = input.pullSwitch(love.keyboard.isDown("left"), left_key)
	right_key = input.pullSwitch(love.keyboard.isDown("right"), right_key)
	
	w_key = input.pullSwitch(love.keyboard.isDown("w"), w_key)
	s_key = input.pullSwitch(love.keyboard.isDown("s"), s_key)
	a_key = input.pullSwitch(love.keyboard.isDown("a"), a_key)
	d_key = input.pullSwitch(love.keyboard.isDown("d"), d_key)

	-- Debug and editor keys
	minus_key = input.pullSwitch(love.keyboard.isDown("-"), minus_key)
	plus_key = input.pullSwitch(love.keyboard.isDown("="), plus_key)
	grave_key = input.pullSwitch(love.keyboard.isDown("`"), grave_key)
	
end

return input
