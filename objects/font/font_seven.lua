local font_seven = {}

function font_seven.init()
	font_seven.data = {}
	font_seven.name = "font_seven"
	editor.importObject("FONT", font_seven.name, "font_seven.new", mdl_7)
end

function font_seven.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_seven.data, tbl)
end

function font_seven.draw()
	local i = 1
	while i <= #font_seven.data do

		local this_ent = font_seven.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_7)
		lg.pop()

		i = i + 1
	end
end

return font_seven