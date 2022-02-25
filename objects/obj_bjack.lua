local obj_bjack = {}

function obj_bjack.init()
	obj_bjack.data = {}
	obj_bjack.name = "obj_bjack"
	editor.importObject("FACES", obj_bjack.name, "obj_bjack.new", mdl_bjack)
end

function obj_bjack.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_bjack.data, tbl)
end

function obj_bjack.draw()
	local i = 1
	while i <= #obj_bjack.data do

		local this_ent = obj_bjack.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_bjack)
		lg.pop()

		i = i + 1
	end
end

return obj_bjack