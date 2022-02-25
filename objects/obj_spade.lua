local obj_spade = {}

function obj_spade.init()
	obj_spade.data = {}
	obj_spade.name = "obj_spade"
	editor.importObject("SUITS", obj_spade.name, "obj_spade.new", mdl_spade)
end

function obj_spade.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_spade.data, tbl)
end

function obj_spade.draw()
	local i = 1
	while i <= #obj_spade.data do

		local this_ent = obj_spade.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_spade)
		lg.pop()

		i = i + 1
	end
end

return obj_spade