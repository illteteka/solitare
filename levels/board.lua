local b = {}

function b.level()
	window.color = c_green
	card_back.new(0, 0)
	card_front.new(0, 0)
	obj_diamond.new(0, 0)
	obj_heart.new(0, 0)
	obj_spade.new(0, 0)
	obj_club.new(0, 0)
	font_a.new(0, 0)
	font_k.new(0, 0)
	font_q.new(0, 0)
	font_j.new(0, 0)
	font_ten.new(0, 0)
	font_nine.new(0, 0)
	font_eight.new(0, 0)
	font_seven.new(0, 0)
	font_six.new(0, 0)
	font_five.new(0, 0)
	font_four.new(0, 0)
	font_three.new(0, 0)
	font_two.new(0, 0)
	obj_bking.new(0, 0)
	obj_rking.new(0, 0)
	obj_bqueen.new(0, 0)
	obj_rqueen.new(0, 0)
	obj_bjack.new(0, 0)
	obj_rjack.new(0, 0)
	gameReset()
end

function b.init()
	LEVEL_SWITCH = LEVEL_BOARD
	instances.clear()
	b.level()
end

function b.update(dt)

	updateSolitare(dt)

end

function b.draw()
	
	drawSolitare()
	
end

return b