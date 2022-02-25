local font_two = {}

function font_two.init()
	font_two.data = {}
	font_two.name = "font_two"
	editor.importObject("FONT", font_two.name, "font_two.new", mdl_2)
end

function font_two.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_two.data, tbl)
end

function font_two.draw()
	local i = 1
	while i <= #font_two.data do

		local this_ent = font_two.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_2)
		lg.pop()

		i = i + 1
	end
end

return font_two