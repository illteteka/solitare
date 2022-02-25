local card_back = {}

function card_back.init()
	card_back.data = {}
	card_back.name = "card_back"
	editor.importObject("CARDS", card_back.name, "card_back.new", mdl_card_back)
end

function card_back.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(card_back.data, tbl)
end

function card_back.draw()
	local i = 1
	while i <= #card_back.data do

		local this_ent = card_back.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_card_back)
		lg.pop()

		i = i + 1
	end
end

return card_back