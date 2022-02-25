local card_front = {}

function card_front.init()
	card_front.data = {}
	card_front.name = "card_front"
	editor.importObject("CARDS", card_front.name, "card_front.new", mdl_card_front)
end

function card_front.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(card_front.data, tbl)
end

function card_front.draw()
	local i = 1
	while i <= #card_front.data do

		local this_ent = card_front.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_card_front)
		lg.pop()

		i = i + 1
	end
end

return card_front