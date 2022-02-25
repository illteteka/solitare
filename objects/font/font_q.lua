local font_q = {}

function font_q.init()
	font_q.data = {}
	font_q.name = "font_q"
	editor.importObject("FONT", font_q.name, "font_q.new", mdl_q)
end

function font_q.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(font_q.data, tbl)
end

function font_q.draw()
	local i = 1
	while i <= #font_q.data do

		local this_ent = font_q.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_q)
		lg.pop()

		i = i + 1
	end
end

return font_q