local font_four = {}

function font_four.init()
	font_four.data = {}
	font_four.name = "font_four"
	editor.importObject("FONT", font_four.name, "font_four.new", mdl_4)
end

function font_four.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_four.data, tbl)
end

function font_four.draw()
	local i = 1
	while i <= #font_four.data do

		local this_ent = font_four.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_4)
		lg.pop()

		i = i + 1
	end
end

return font_four