-- better call sol
-- tare me a new one
-- solitares curse
-- solitares revenge

-- POLISH
--double tap should auto send if possible
--comment code
--highlight over selected areas
--dragging king to empty was finicky
	--bias between up and down of board problem
--add nice undo
--solitare needs to obey anemone pause
	-- release cards and disable animations

lg = love.graphics
c_white = {1,1,1,1}
c_black = {0,0,0,1}

deck = {}

-- Offset of play_area on the screen
card_offset_x = 153
card_offset_y = 90

-- Distance between cards on the screen
card_mult_x = 70
card_mult_y = 15
card_mult_w = 30

-- Functional size of the cards on the screen
CARD_W = 48
CARD_H = 64

DECK_X = 24
DECK_Y = 30

-- Offset from where the player clicks to the cards top left corner
active_offset_x = 0
active_offset_y = 0

-- The top most selected card's index in the playarea array
active_slot = 0
active_card = 0

SOURCE_PLAY = 1
SOURCE_DECK = 2
SOURCE_SORT = 3
active_source = SOURCE_PLAY

-- True if the player is dragging
active_card_drag = false

play_area = {}

RED_A = "heart"
RED_B = "diamond"
BLACK_A = "club"
BLACK_B = "spade"
suits = {RED_A, RED_B, BLACK_A, BLACK_B}
BOTTOM_CARD = "A"
TOP_CARD = "K"
CARD_AFTER_BOTTOM_CARD = 2
CARD_AFTER_TOP_CARD = "Q"
cards = {BOTTOM_CARD, TOP_CARD, CARD_AFTER_TOP_CARD, "J", 10, 9, 8, 7, 6, 5, 4, 3, 2}

card_visual_data = {}
card_visual_last = "none"

function drawCardFont(x,red)

	if red then
		lg.setColor(1, 0, 0, 1)
	else
		lg.setColor(0, 0, 0, 1)
	end

	if x==TOP_CARD then --K
		font_k.draw()
	elseif x==CARD_AFTER_TOP_CARD then --Q
		font_q.draw()
	elseif x==BOTTOM_CARD then --A
		font_a.draw()
	elseif x=="J" then
		font_j.draw()
	elseif x==10 then
		font_ten.draw()
	elseif x==9 then
		font_nine.draw()
	elseif x==8 then
		font_eight.draw()
	elseif x==7 then
		font_seven.draw()
	elseif x==6 then
		font_six.draw()
	elseif x==5 then
		font_five.draw()
	elseif x==4 then
		font_four.draw()
	elseif x==3 then
		font_three.draw()
	elseif x==2 then
		font_two.draw()
	end

	lg.setColor(c_white)

end

function addCardVisual(kind, x, y, flipped)
	flipped = flipped or false

	if kind == "NEW" then
		card_visual_data[x] = {}
		card_visual_last = x
	else
		if kind == "NUMBER" then
			local this_card = card_visual_data[card_visual_last]
			local tbl = {}
			tbl.x = x
			tbl.y = y
			tbl.flipped = flipped
			table.insert(this_card, tbl)
		elseif kind == "FACE" then
			local this_card = card_visual_data[card_visual_last]
			local tbl = {}
			tbl.face = x
			table.insert(this_card, tbl)
		end
	end
end

function importCardVisual()
	-- A
	addCardVisual("NEW", cards[1])
	addCardVisual("NUMBER",19,27)
	-- K
	addCardVisual("NEW", cards[2])
	addCardVisual("FACE","K")
	-- Q
	addCardVisual("NEW", cards[3])
	addCardVisual("FACE","Q")
	-- J
	addCardVisual("NEW", cards[4])
	addCardVisual("FACE","J")
	-- 10
	addCardVisual("NEW", cards[5])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",19,14)
	addCardVisual("NUMBER",11,21)
	addCardVisual("NUMBER",27,21)
	addCardVisual("NUMBER",11,33,true)
	addCardVisual("NUMBER",27,33,true)
	addCardVisual("NUMBER",19,40,true)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 9
	addCardVisual("NEW", cards[6])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",11,21)
	addCardVisual("NUMBER",27,21)
	addCardVisual("NUMBER",19,27)
	addCardVisual("NUMBER",11,33,true)
	addCardVisual("NUMBER",27,33,true)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 8
	addCardVisual("NEW", cards[7])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",19,17)
	addCardVisual("NUMBER",11,27)
	addCardVisual("NUMBER",27,27)
	addCardVisual("NUMBER",19,37,true)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 7
	addCardVisual("NEW", cards[8])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",19,17)
	addCardVisual("NUMBER",11,27)
	addCardVisual("NUMBER",27,27)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 6
	addCardVisual("NEW", cards[9])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",11,27)
	addCardVisual("NUMBER",27,27)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 5
	addCardVisual("NEW", cards[10])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",19,27)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 4
	addCardVisual("NEW", cards[11])
	addCardVisual("NUMBER",11,7)
	addCardVisual("NUMBER",27,7)
	addCardVisual("NUMBER",11,47,true)
	addCardVisual("NUMBER",27,47,true)
	-- 3
	addCardVisual("NEW", cards[12])
	addCardVisual("NUMBER",19,7)
	addCardVisual("NUMBER",19,27)
	addCardVisual("NUMBER",19,47,true)
	-- 2
	addCardVisual("NEW", cards[13])
	addCardVisual("NUMBER",19,7)
	addCardVisual("NUMBER",19,47,true)
end

function updateSolitare(dt)

	local win_1, win_2, win_3, win_4 = false, false, false, false
	if play_area.pile[1][1] ~= nil and play_area.pile[2][2] ~= nil and play_area.pile[3][3] ~= nil and play_area.pile[4][4] ~= nil then
		win_1 = play_area.pile[1][#play_area.pile[1]].card == TOP_CARD
		win_2 = play_area.pile[2][#play_area.pile[2]].card == TOP_CARD
		win_3 = play_area.pile[3][#play_area.pile[3]].card == TOP_CARD
		win_4 = play_area.pile[4][#play_area.pile[4]].card == TOP_CARD
	end
	
	if win_1 and win_2 and win_3 and win_4 then
		game_win = true
	end
	
	if game_win then
	
		if mouse_switch == _PRESS then
			gameReset()
		end
	
	else
	
		if mouse_switch == _PRESS then
			checkCardClicked()
			checkDeckClicked()
		end
		
		if mouse_switch == _RELEASE then
			checkCardReleased()
		end
		
	end

end

function drawSolitare()

	lg.setColor(c_white)
	--lg.print(mouse.rx .. ", " .. mouse.ry, 10, 10)
	
	lg.push()
	
	-- Draw face down card
	lg.push()
	lg.translate(DECK_X, DECK_Y)
	
	lg.setColor(c_white)
	lg.rectangle("line", 0, 0, CARD_W,CARD_H)

	if #deck ~= 0 then
		card_front.draw()
		card_back.draw()
	end
	lg.pop()
	
	local draw_last = {}
	
	-- Draw deck cards
	if #active_deck ~= 0 then
		
		local i = 1
		while i <= #active_deck do
		
			local deck_card = active_deck[i]
			local card_x, card_y = DECK_X + card_mult_x + (card_mult_w * (i-1)), DECK_Y
			if deck_card.active == false then
				drawCard(card_x, card_y, deck_card)
			else
				card_x = mouse.rx - card_offset_x + active_offset_x
				card_y = mouse.ry - card_offset_y + active_offset_y
				table.insert(draw_last, {x=card_x, y=card_y, card=deck_card})
			end
			
			i = i + 1
		end
	
	end
	
	-- Draw piles
	local i = 1
	while i <= 4 do
		
		lg.push()
		local card_x, card_y = card_offset_x + (card_mult_x * i) + (card_mult_x * 3), DECK_Y
		lg.translate(card_x, card_y)
		lg.setColor(c_white)
		lg.rectangle("line", 0,0,CARD_W,CARD_H)
		
		if #play_area.pile[i] ~= 0 then
			if play_area.pile[i][#play_area.pile[i]-1] ~= nil then
				drawCard(0, 0, play_area.pile[i][#play_area.pile[i]-1])
			end
			
			local pile_card = play_area.pile[i][#play_area.pile[i]]
			if pile_card.active == false then
				drawCard(0, 0, pile_card)
			else
				card_x = mouse.rx - card_offset_x + active_offset_x
				card_y = mouse.ry - card_offset_y + active_offset_y
				table.insert(draw_last, {x=card_x, y=card_y, card=pile_card})
			end
		end
		
		lg.pop()
		
		i = i + 1
	end
	
	-- Draw play area
	lg.push()
	lg.translate(card_offset_x, card_offset_y)
	
	local i = 1
	
	while i <= 7 do
	
		local j = 1
		
		local active_trigger = false
		local active_y = 0
		local active_y_steps = 0
		
		if mouse.rx + active_offset_x + CARD_W >= (i * card_mult_x) + card_offset_x and mouse.rx + active_offset_x <= (i * card_mult_x) + CARD_W + card_offset_x then
			lg.setColor({0,0,1,0.4})
			lg.rectangle("fill", (i * card_mult_x), 0, CARD_W, 1000)
		end
		
		local card_x, card_y = (i * card_mult_x), (j * card_mult_y)
			
		if j == 1 then
			lg.setColor(c_white)
			lg.rectangle("line", card_x, card_y, CARD_W,CARD_H)
		end
		
		while j <= #play_area[i] do

			local this_card = play_area[i][j]
			local card_x, card_y = (i * card_mult_x), (j * card_mult_y)
			
			if active_trigger and this_card.active then
				active_y_steps = active_y_steps + 1
				card_x = mouse.rx - card_offset_x + active_offset_x
				card_y = active_y + (active_y_steps * card_mult_y)
				table.insert(draw_last, {x=card_x, y=card_y, card=this_card})
			elseif this_card.active then
				card_x = mouse.rx - card_offset_x + active_offset_x
				card_y = mouse.ry - card_offset_y + active_offset_y
				active_trigger = true
				active_y = card_y
				table.insert(draw_last, {x=card_x, y=card_y, card=this_card})
			else
				drawCard(card_x, card_y, this_card)
			end
			
			j = j + 1
		end
		
		j = j + 1
		i = i + 1
		
	end
	
	if #draw_last ~= 0 then
	
		local i = 1
		while i <= #draw_last do
			drawCard(draw_last[i].x, draw_last[i].y, draw_last[i].card)
			i = i + 1
		end
	
	end
	
	lg.pop()
	
	lg.pop()
	
	if game_win then
		lg.setColor(c_white)
		lg.print("We have a winner!", 300, 30)
	end

end

function drawCard(x, y, card)

	lg.push()
	lg.translate(x, y)
	
	if card.flipped then
	
		card_front.draw()
		card_back.draw()
	
	else
		
		card_front.draw()
		
		local is_black = true
		local col = c_black
		if card.suit == RED_A or card.suit == RED_B then
			col = {1,0,0,1}
			is_black = false
		end

		local drawable = obj_diamond
		if card.suit == RED_A then
			drawable = obj_heart
		elseif card.suit == BLACK_A then
			drawable = obj_club
		elseif card.suit == BLACK_B then
			drawable = obj_spade
		end

		local i = 1
		while i <= #card_visual_data[card.card] do
			local inst = card_visual_data[card.card][i]
			if inst.face == nil then

				lg.push()
				lg.translate(inst.x, inst.y)
				if inst.flipped then
					lg.scale(1,-1)
					lg.translate(0, -12)
				end
				drawable.draw()
				lg.pop()

			else

				lg.push()
				lg.translate(12,6)
				lg.scale(0.5,0.5)

				if inst.face == "K" then

					if is_black then
						obj_bking.draw()
						lg.translate(48,103)
						lg.scale(-1,-1)
						obj_bking.draw()
					else
						obj_rking.draw()
						lg.translate(48,103)
						lg.scale(-1,-1)
						obj_rking.draw()
					end

				elseif inst.face == "Q" then

					if is_black then
						obj_bqueen.draw()
						lg.translate(48,103)
						lg.scale(-1,-1)
						obj_bqueen.draw()
					else
						obj_rqueen.draw()
						lg.translate(48,103)
						lg.scale(-1,-1)
						obj_rqueen.draw()
					end

				elseif inst.face == "J" then

					if is_black then
						obj_bjack.draw()
						lg.translate(48,103)
						lg.scale(-1,-1)
						obj_bjack.draw()
					else
						obj_rjack.draw()
						lg.translate(48,103)
						lg.scale(-1,-1)
						obj_rjack.draw()
					end

				end

				lg.pop()
					
			end
			i = i + 1
		end

		lg.push()
		lg.translate(2,3)
		lg.scale(0.7,0.7)
		drawCardFont(card.card,not is_black)
		lg.translate(0,14)
		drawable.draw()
		lg.pop()

		lg.push()
		
		lg.translate(48,64)
		lg.translate(-2,-3)
		lg.scale(0.7,0.7)
		lg.scale(-1,-1)
		drawCardFont(card.card,not is_black)
		lg.translate(0,14)
		drawable.draw()
		lg.pop()
		
	end
	
	lg.pop()

end

function generateCards()

	local tbl = {}
	
	local i = 1
	while i <= #cards do
	
		-- Add one of each 'suit' to each type of 'cards'
		local tbl_2 = {card = cards[i], suit = suits[1], flipped=true, active=false}
		table.insert(tbl, tbl_2)
		local tbl_2 = {card = cards[i], suit = suits[2], flipped=true, active=false}
		table.insert(tbl, tbl_2)
		local tbl_2 = {card = cards[i], suit = suits[3], flipped=true, active=false}
		table.insert(tbl, tbl_2)
		local tbl_2 = {card = cards[i], suit = suits[4], flipped=true, active=false}
		table.insert(tbl, tbl_2)
		
		i = i + 1
	end
	
	deck = tbl

end

function randomizeDeck()
	local i = 1
	while i <= #deck do
		local swap = math.random(#deck)
		deck[swap], deck[i] = deck[i], deck[swap]
		i = i + 1
	end
end

function generatePlayArea()
	
	local tbl = {}
	
	-- Set up the seven play areas
	local i = 1
	while i <= 7 do
		tbl[i] = {}
		i = i + 1
	end
	
	-- Set up the 4 ace spaces
	tbl.pile = {}
	tbl.pile[1] = {}
	tbl.pile[2] = {}
	tbl.pile[3] = {}
	tbl.pile[4] = {}
	
	-- Generate the play area and flip cards
	local i = 1
	local amt = 1
	
	while i <= 7 do
	
		local j = 1
		while j <= amt do
			
			-- Flip over first active cards
			if j == amt then
				deck[#deck].flipped = false
			end
			
			table.insert(tbl[i], deck[#deck])
			table.remove(deck)
			j = j + 1
		end
		
		amt = amt + 1
		i = i + 1
		
	end
	
	play_area = tbl
end

function gameReset()
	game_win = false
	discard = {}
	active_deck = {}
	generateCards()
	
	math.randomseed(os.time())
	math.randomseed(os.time())
	randomizeDeck()
	randomizeDeck()
	
	generatePlayArea()
end

function checkDeckClicked()

	if mouse.rx >= DECK_X and mouse.rx <= DECK_X + CARD_W and mouse.ry >= DECK_Y and mouse.ry <= DECK_Y + CARD_H then
	
		-- Reverse cards back into deck
		if #active_deck ~= 0 then
			local i = #active_deck
			while i >= 1 do
				table.insert(discard, active_deck[#active_deck])
				table.remove(active_deck)
				i = i - 1
			end
		end
	
		local skip_flip = false
		if #deck >= 3 then
			deck[#deck].flipped = false
			deck[#deck-1].flipped = false
			deck[#deck-2].flipped = false
			table.insert(active_deck, deck[#deck-2])
			table.insert(active_deck, deck[#deck-1])
			table.insert(active_deck, deck[#deck])
			table.remove(deck)
			table.remove(deck)
			table.remove(deck)
			skip_flip = true
		elseif #deck == 2 then
			deck[#deck].flipped = false
			deck[#deck-1].flipped = false
			table.insert(active_deck, deck[#deck-1])
			table.insert(active_deck, deck[#deck])
			table.remove(deck)
			table.remove(deck)
			skip_flip = true
		elseif #deck == 1 then
			deck[#deck].flipped = false
			table.insert(active_deck, deck[#deck])
			table.remove(deck)
			skip_flip = true
		end
		
		-- Flip deck over if empty
		if #deck == 0 and skip_flip == false then
			local i = 0
			while i <= #discard - 1 do
				deck[i + 1] = discard[#discard - i]
				deck[i + 1].flipped = true
				i = i + 1
			end
			discard = {}
		end
		
	end

end

function checkCardClicked()

	local i = 1
		
	-- Loop through playarea and see if a card was clicked
	while i <= 7 do
	
		local card_active_flag = false -- Once set all following cards will be set to active
		local j = 1
		while j <= #play_area[i] do

			-- Calculate card's position on screen
			local xx, yy = (i * card_mult_x) + card_offset_x, (j * card_mult_y) + card_offset_y
			local ww, hh = xx + CARD_W, yy
			
			-- Shorten the card's hitbox if it is partially covered
			if j == #play_area[i] then
				hh = hh + CARD_H          -- Full size
			else
				hh = hh + card_mult_y - 1 -- Half size (check card_mult_y value)
			end
			
			local this_card = play_area[i][j]
			
			-- Check if a card was clicked on
			if mouse.rx >= xx and mouse.rx <= ww and mouse.ry >= yy and mouse.ry <= hh then

				-- Pick up the card if it's visible
				if this_card.flipped == false then
					card_active_flag = true
					
					-- Update offset
					active_offset_x = xx - mouse.rx
					active_offset_y = yy - mouse.ry
					
					-- Update card's index
					active_slot = i
					active_card = j
					active_source = SOURCE_PLAY
					
					-- Set game state to dragging
					active_card_drag = true
				end
				
			end
			
			-- Once a card is set to active, set all following cards as active
			if card_active_flag then
				this_card.active = true
			end
			
			j = j + 1
		end
		
		i = i + 1
		
	end
	
	-- Loop through deck cards and see if one was clicked
	if #active_deck ~= 0 then
		local card_x, card_y = DECK_X + card_mult_x + (card_mult_w * (#active_deck-1)), DECK_Y
		local xx, yy, ww, hh = card_x, card_y, CARD_W, CARD_H
		
		if mouse.rx >= xx and mouse.rx <= xx + ww and mouse.ry >= yy and mouse.ry <= yy + hh then
			
			-- Update offset
			active_offset_x = xx - mouse.rx
			active_offset_y = yy - mouse.ry
			
			-- Update card's index
			active_source = SOURCE_DECK
			active_card = active_deck[#active_deck]
			active_deck[#active_deck].active = true
			
			-- Set game state to dragging
			active_card_drag = true
			
		end
	end
	
	-- Loop through piles and see if a card was clicked
	local i = 1
	while i <= 4 do
		local j = play_area.pile[i][#play_area.pile[i]]
		if j ~= nil then
		
			-- Calculate card's position on screen
			local xx, yy = card_offset_x + (card_mult_x * i) + (card_mult_x * 3), DECK_Y
			local ww, hh = xx + CARD_W, yy + CARD_H
			
			local this_card = j
			
			-- Check if a card was clicked on
			if mouse.rx >= xx and mouse.rx <= ww and mouse.ry >= yy and mouse.ry <= hh then

				-- Pick up the card if it's visible
				if this_card.flipped == false then
					
					-- Update offset
					active_offset_x = xx - mouse.rx
					active_offset_y = yy - mouse.ry
					
					-- Update card's index
					active_slot = i
					active_card = j
					active_source = SOURCE_SORT
					
					this_card.active = true
					
					-- Set game state to dragging
					active_card_drag = true
				end
				
			end
			
		end
		
		i = i + 1
		
	end

end

function checkCardStandard()
	-- Get the new index the cards should be dropped to in the play area 1-7
	local move_to = -1
	local aa = (mouse.rx + active_offset_x + CARD_W - card_offset_x) / card_mult_x --floor
	local bb = (mouse.rx + active_offset_x - CARD_W - card_offset_x) / card_mult_x --ceil
	local fa, cb = math.floor(aa), math.ceil(bb)
	local cc = math.abs(aa - fa)
	local dd = math.abs(bb - cb)
	if cc >= dd then
		move_to = fa
	else
		move_to = cb
	end
	-- move_to is the index where the player dragged to
	move_to = math.max(1, math.min(7, move_to))
	
	-- When the cards are moved they are duplicated and then deleted from their old stack
	-- This flags if the cards need to be removed from their original stack
	local delete_old_copy = false
	
	-- Get the top card from the player's drag
	local get_top_card = nil
	
	if active_source == SOURCE_PLAY then
		get_top_card = play_area[active_slot][active_card]
	elseif active_source == SOURCE_DECK then
		get_top_card = active_card
		active_slot = 0
	elseif active_source == SOURCE_SORT then
		get_top_card = active_card
	end
	
	-- Get the bottom card the player is trying to drag to
	local get_bot_card_new_slot = play_area[move_to][#play_area[move_to]]
	
	local search_to = get_top_card.card
	local search = 1
	local other_needs_to_be = -1
	while search <= #cards do
		-- If the card is not a K or A
		-- Get the player's card value in the array 'cards'
		-- Set other_needs_to_be to the value of the card the player is dragging to
		if search_to ~= BOTTOM_CARD and search_to ~= TOP_CARD then
			if cards[search] == search_to then
				other_needs_to_be = cards[search - 1]
			end
		end
		search = search + 1
	end
	
	-- Get if the dragged cards are opposite suit colors
	local first_red = get_top_card.suit == RED_A or get_top_card.suit == RED_B
	local second_red = first_red
	local slot_empty = false
	local cards_in_order = false
	
	-- Check if the card can be dragged to an empty slot
	if get_bot_card_new_slot ~= nil then
		second_red = get_bot_card_new_slot.suit == RED_A or get_bot_card_new_slot.suit == RED_B
		cards_in_order = get_bot_card_new_slot.card == other_needs_to_be
	else
		slot_empty = true
	end
	
	-- True if opposite
	local suits_ok = (first_red == true and second_red == false) or (first_red == false and second_red == true)
	
	if active_source == SOURCE_PLAY then
		
		-- Loop through all cards the player is dragging
		local j = active_card
		while j <= #play_area[active_slot] do
			
			-- Make the dragged cards no longer active
			play_area[active_slot][j].active = false
			
			-- If the player moved the cards to a valid slot
			if move_to ~= -1 and move_to ~= active_slot then
				-- If the suits are opposite colors and the new top card is the next higher value
				-- (If the solitare rules for card stacking are correct)
				local king_in_empty = get_top_card.card == TOP_CARD and slot_empty
				
				if (cards_in_order and suits_ok) or king_in_empty then
					-- Copy all cards to the new playarea slot
					table.insert(play_area[move_to],play_area[active_slot][j])
					delete_old_copy = true
				end
			end
			
			j = j + 1
		
		end
	
	elseif active_source == SOURCE_DECK or active_source == SOURCE_SORT then
		
		-- Make the dragged cards no longer active
		active_card.active = false
		
		-- If the suits are opposite colors and the new top card is the next higher value
		-- (If the solitare rules for card stacking are correct)
		local king_in_empty = get_top_card.card == TOP_CARD and slot_empty
		
		if (cards_in_order and suits_ok) or king_in_empty then
			-- Copy all cards to the new playarea slot
			table.insert(play_area[move_to],active_card)
			delete_old_copy = true
		end
		
	end
	
	-- If the cards were moved and now there are duplicate cards
	if delete_old_copy then
	
		if active_source == SOURCE_PLAY then
	
			-- Remove all the cards that were just moved from their old slot
			local total_remove = #play_area[active_slot]
			local j = active_card
			while j <= total_remove do

				table.remove(play_area[active_slot])
					
				j = j + 1
			
			end
			
			-- Unflip the new bottom card
			if #play_area[active_slot] ~= 0 then
				local bottom_card = play_area[active_slot][#play_area[active_slot]]
				bottom_card.flipped = false
			end
			
		elseif active_source == SOURCE_DECK then
			table.remove(active_deck)
		elseif active_source == SOURCE_SORT then
			table.remove(play_area.pile[active_slot])
		end
		
	end
end

function checkCardPile()
	-- Get the new index the cards should be dropped to in the play area 1-7
	local move_to = -1
	local aa = (mouse.rx + active_offset_x + CARD_W - card_offset_x) / card_mult_x --floor
	local bb = (mouse.rx + active_offset_x - CARD_W - card_offset_x) / card_mult_x --ceil
	local fa, cb = math.floor(aa), math.ceil(bb)
	local cc = math.abs(aa - fa)
	local dd = math.abs(bb - cb)
	if cc >= dd then
		move_to = fa
	else
		move_to = cb
	end
	-- move_to is the index where the player dragged to
	move_to = math.max(1, math.min(7, move_to))
	
	-- When the cards are moved they are duplicated and then deleted from their old stack
	-- This flags if the cards need to be removed from their original stack
	local delete_old_copy = false
	
	-- Get the top card from the player's drag
	local get_top_card = nil
	
	if active_source == SOURCE_PLAY then
		get_top_card = play_area[active_slot][active_card]
	elseif active_source == SOURCE_DECK then
		get_top_card = active_card
		active_slot = 0
	elseif active_source == SOURCE_SORT then
		get_top_card = active_card
	end
	
	-- Get the bottom card the player is trying to drag to
	local get_bot_card_new_slot = nil
	
	local pile_correct_spot = true
	if move_to - 3 < 1 then
		pile_correct_spot = false
	else
	
		if #play_area.pile[move_to - 3] ~= nil then
			get_bot_card_new_slot = play_area.pile[move_to - 3][#play_area.pile[move_to - 3]]
		end
	
	end
	
	local cards_in_order = false
	local suits_ok = false
	local other_needs_to_be = -1
	local search_to = get_top_card.card
	
	if pile_correct_spot then
		local search = 1
		
		if get_bot_card_new_slot == nil then
			other_needs_to_be = "EMPTY"
		else
			
			if get_bot_card_new_slot.card == BOTTOM_CARD and search_to == CARD_AFTER_BOTTOM_CARD then
				cards_in_order = true
			elseif get_bot_card_new_slot.card == CARD_AFTER_TOP_CARD and search_to == TOP_CARD then
				cards_in_order = true
			else
			
				while search <= #cards do
					-- If the card is not a K or A
					-- Get the player's card value in the array 'cards'
					-- Set other_needs_to_be to the value of the card the player is dragging to
					if search_to ~= BOTTOM_CARD and search_to ~= TOP_CARD then
						if cards[search] == search_to then
							other_needs_to_be = cards[search + 1]
						end
					end
					search = search + 1
				end
				
				cards_in_order = get_bot_card_new_slot.card == other_needs_to_be
				
			end
			
		end
	
		if other_needs_to_be ~= "EMPTY" then
			suits_ok = get_top_card.suit == get_bot_card_new_slot.suit
		end
		
	end
		
	if active_source == SOURCE_PLAY then
		
		local player_holding_multiple_cards = active_card ~= #play_area[active_slot]
		
		if player_holding_multiple_cards == false then
			-- Loop through all cards the player is dragging
			local j = active_card
			while j <= #play_area[active_slot] do
				
				-- Make the dragged cards no longer active
				play_area[active_slot][j].active = false
				
				-- If the player moved the cards to a valid slot
				if pile_correct_spot then
					-- If the suits are opposite colors and the new top card is the next higher value
					-- (If the solitare rules for card stacking are correct)
					local ace_in_empty = other_needs_to_be == "EMPTY" and search_to == BOTTOM_CARD
					
					if (cards_in_order and suits_ok) or ace_in_empty then
						-- Copy all cards to the new playarea slot
						table.insert(play_area.pile[move_to - 3],play_area[active_slot][j])
						delete_old_copy = true
					end
				end
				
				j = j + 1
			
			end
		else
			-- Loop through all cards the player is dragging
			local j = active_card
			while j <= #play_area[active_slot] do
				
				-- Make the dragged cards no longer active
				play_area[active_slot][j].active = false
				
				j = j + 1
			
			end
		end
	
	elseif active_source == SOURCE_DECK or active_source == SOURCE_SORT then
		-- Make the dragged cards no longer active
		active_card.active = false
		
		-- If the suits are opposite colors and the new top card is the next higher value
		-- (If the solitare rules for card stacking are correct)
		local ace_in_empty = other_needs_to_be == "EMPTY" and search_to == BOTTOM_CARD
		if (cards_in_order and suits_ok) or ace_in_empty then
			-- Copy all cards to the new playarea slot
			table.insert(play_area.pile[move_to - 3],active_card)
			delete_old_copy = true
		end
		
	end
	
	-- If the cards were moved and now there are duplicate cards
	if delete_old_copy then
	
		if active_source == SOURCE_PLAY then
	
			-- Remove all the cards that were just moved from their old slot
			local total_remove = #play_area[active_slot]
			local j = active_card
			while j <= total_remove do

				table.remove(play_area[active_slot])
					
				j = j + 1
			
			end
			
			-- Unflip the new bottom card
			if #play_area[active_slot] ~= 0 then
				local bottom_card = play_area[active_slot][#play_area[active_slot]]
				bottom_card.flipped = false
			end
			
		elseif active_source == SOURCE_DECK then
			table.remove(active_deck)
		elseif active_source == SOURCE_SORT then
			table.remove(play_area.pile[active_slot])
		end
		
	end
end

function checkCardReleased()

	-- If a drag is currently happenning
	if active_card_drag then
	
		local aa = (CARD_H + DECK_Y + (DECK_Y / 2)) - mouse.ry + active_offset_y
		local bb = (CARD_H + DECK_Y + (DECK_Y / 2)) - mouse.ry + active_offset_y + CARD_H
		
		-- Put it in the sort pile
		local is_pile = false
		if aa >= 0 or bb >= 0 then
			is_pile = true
		end
	
		if is_pile then
			checkCardPile()
		else
			checkCardStandard()
		end
		
		-- Deactivate dragging
		active_card_drag = false
		
	end

end