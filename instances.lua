local instances = {}

--[[
	Load all instances into the game
	Should only happen once
]]
function instances.load()
	
	card_back = require "objects.card_back"
	card_back.init()

	card_front = require "objects.card_front"
	card_front.init()

	obj_diamond = require "objects.obj_diamond"
	obj_diamond.init()

	obj_heart = require "objects.obj_heart"
	obj_heart.init()

	obj_spade = require "objects.obj_spade"
	obj_spade.init()

	obj_club = require "objects.obj_club"
	obj_club.init()

	font_a = require "objects.font.font_a"
	font_a.init()
	font_k = require "objects.font.font_k"
	font_k.init()
	font_q = require "objects.font.font_q"
	font_q.init()
	font_j = require "objects.font.font_j"
	font_j.init()
	font_ten = require "objects.font.font_ten"
	font_ten.init()
	font_nine = require "objects.font.font_nine"
	font_nine.init()
	font_eight = require "objects.font.font_eight"
	font_eight.init()
	font_seven = require "objects.font.font_seven"
	font_seven.init()
	font_six = require "objects.font.font_six"
	font_six.init()
	font_five = require "objects.font.font_five"
	font_five.init()
	font_four = require "objects.font.font_four"
	font_four.init()
	font_three = require "objects.font.font_three"
	font_three.init()
	font_two = require "objects.font.font_two"
	font_two.init()

	obj_bking = require "objects.obj_bking"
	obj_bking.init()

	obj_rking = require "objects.obj_rking"
	obj_rking.init()

	obj_bqueen = require "objects.obj_bqueen"
	obj_bqueen.init()

	obj_rqueen = require "objects.obj_rqueen"
	obj_rqueen.init()

	obj_bjack = require "objects.obj_bjack"
	obj_bjack.init()

	obj_rjack = require "objects.obj_rjack"
	obj_rjack.init()

	--[[
		Add every instance that needs to be cleared to this list
		Switching levels will destroy all non persistent objects
	]]
	instances.list = {card_back, card_front, obj_diamond, obj_heart, obj_spade,
	obj_club, font_a, font_k, font_q, font_j, font_ten, font_nine, font_eight,
	font_seven, font_six, font_five, font_four, font_three, font_two,
	obj_bking, obj_rking, obj_bqueen, obj_rqueen, obj_bjack, obj_rjack}

end

--[[
	Remove all active objects from the scene
]]
function instances.clear()

	local i = 1
	while i <= #instances.list do
		instances.list[i].init()
		i = i + 1
	end

end

return instances