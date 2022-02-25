local font_six = {}

function font_six.init()
	font_six.data = {}
	font_six.name = "font_six"
	editor.importObject("FONT", font_six.name, "font_six.new", mdl_6)
end

function font_six.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_six.data, tbl)
end

function font_six.draw()
	local i = 1
	while i <= #font_six.data do

		local this_ent = font_six.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_6)
		lg.pop()

		i = i + 1
	end
end

return font_six