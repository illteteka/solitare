local font_five = {}

function font_five.init()
	font_five.data = {}
	font_five.name = "font_five"
	editor.importObject("FONT", font_five.name, "font_five.new", mdl_5)
end

function font_five.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_five.data, tbl)
end

function font_five.draw()
	local i = 1
	while i <= #font_five.data do

		local this_ent = font_five.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_5)
		lg.pop()

		i = i + 1
	end
end

return font_five