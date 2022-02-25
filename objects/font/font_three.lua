local font_three = {}

function font_three.init()
	font_three.data = {}
	font_three.name = "font_three"
	editor.importObject("FONT", font_three.name, "font_three.new", mdl_3)
end

function font_three.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_three.data, tbl)
end

function font_three.draw()
	local i = 1
	while i <= #font_three.data do

		local this_ent = font_three.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_3)
		lg.pop()

		i = i + 1
	end
end

return font_three