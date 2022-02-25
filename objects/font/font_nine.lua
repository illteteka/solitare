local font_nine = {}

function font_nine.init()
	font_nine.data = {}
	font_nine.name = "font_nine"
	editor.importObject("FONT", font_nine.name, "font_nine.new", mdl_9)
end

function font_nine.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_nine.data, tbl)
end

function font_nine.draw()
	local i = 1
	while i <= #font_nine.data do

		local this_ent = font_nine.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_9)
		lg.pop()

		i = i + 1
	end
end

return font_nine