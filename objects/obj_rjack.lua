local obj_rjack = {}

function obj_rjack.init()
	obj_rjack.data = {}
	obj_rjack.name = "obj_rjack"
	editor.importObject("FACES", obj_rjack.name, "obj_rjack.new", mdl_rjack)
end

function obj_rjack.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_rjack.data, tbl)
end

function obj_rjack.draw()
	local i = 1
	while i <= #obj_rjack.data do

		local this_ent = obj_rjack.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_rjack)
		lg.pop()

		i = i + 1
	end
end

return obj_rjack