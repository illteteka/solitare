local font_k = {}

function font_k.init()
	font_k.data = {}
	font_k.name = "font_k"
	editor.importObject("FONT", font_k.name, "font_k.new", mdl_k)
end

function font_k.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_k.data, tbl)
end

function font_k.draw()
	local i = 1
	while i <= #font_k.data do

		local this_ent = font_k.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_k)
		lg.pop()

		i = i + 1
	end
end

return font_k