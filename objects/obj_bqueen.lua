local obj_bqueen = {}

function obj_bqueen.init()
	obj_bqueen.data = {}
	obj_bqueen.name = "obj_bqueen"
	editor.importObject("FACES", obj_bqueen.name, "obj_bqueen.new", mdl_bqueen)
end

function obj_bqueen.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_bqueen.data, tbl)
end

function obj_bqueen.draw()
	local i = 1
	while i <= #obj_bqueen.data do

		local this_ent = obj_bqueen.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_bqueen)
		lg.pop()

		i = i + 1
	end
end

return obj_bqueen