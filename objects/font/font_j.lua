local font_j = {}

function font_j.init()
	font_j.data = {}
	font_j.name = "font_j"
	editor.importObject("FONT", font_j.name, "font_j.new", mdl_j)
end

function font_j.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_j.data, tbl)
end

function font_j.draw()
	local i = 1
	while i <= #font_j.data do

		local this_ent = font_j.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_j)
		lg.pop()

		i = i + 1
	end
end

return font_j