local font_eight = {}

function font_eight.init()
	font_eight.data = {}
	font_eight.name = "font_eight"
	editor.importObject("FONT", font_eight.name, "font_eight.new", mdl_8)
end

function font_eight.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_eight.data, tbl)
end

function font_eight.draw()
	local i = 1
	while i <= #font_eight.data do

		local this_ent = font_eight.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_8)
		lg.pop()

		i = i + 1
	end
end

return font_eight