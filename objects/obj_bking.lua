local obj_bking = {}

function obj_bking.init()
	obj_bking.data = {}
	obj_bking.name = "obj_bking"
	editor.importObject("FACES", obj_bking.name, "obj_bking.new", mdl_bking)
end

function obj_bking.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_bking.data, tbl)
end

function obj_bking.draw()
	local i = 1
	while i <= #obj_bking.data do

		local this_ent = obj_bking.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_bking)
		lg.pop()

		i = i + 1
	end
end

return obj_bking