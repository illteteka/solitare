local font_ten = {}

function font_ten.init()
	font_ten.data = {}
	font_ten.name = "font_ten"
	editor.importObject("FONT", font_ten.name, "font_ten.new", mdl_10)
end

function font_ten.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_ten.data, tbl)
end

function font_ten.draw()
	local i = 1
	while i <= #font_ten.data do

		local this_ent = font_ten.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_10)
		lg.pop()

		i = i + 1
	end
end

return font_ten