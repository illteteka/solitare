local font_a = {}

function font_a.init()
	font_a.data = {}
	font_a.name = "font_a"
	editor.importObject("FONT", font_a.name, "font_a.new", mdl_a)
end

function font_a.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_a.data, tbl)
end

function font_a.draw()
	local i = 1
	while i <= #font_a.data do

		local this_ent = font_a.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_a)
		lg.pop()

		i = i + 1
	end
end

return font_a