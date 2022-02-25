local obj_heart = {}

function obj_heart.init()
	obj_heart.data = {}
	obj_heart.name = "obj_heart"
	editor.importObject("SUITS", obj_heart.name, "obj_heart.new", mdl_heart)
end

function obj_heart.new(x, y)
	local tbl = {}
	tbl.x = x
	tbl.y = y
	table.insert(obj_heart.data, tbl)
end

function obj_heart.draw()
	local i = 1
	while i <= #obj_heart.data do

		local this_ent = obj_heart.data[i]

		lg.push()
		lg.translate(this_ent.x, this_ent.y)
		polygon.draw(mdl_heart)
		lg.pop()

		i = i + 1
	end
end

return obj_heart