gfx = love.graphics
new = function (nombre)
	return fsy.load(nombre .. ".lua")()
end

wt = gfx.getWidth()
ht = gfx.getHeight()

require(mapa1)

function love.load( ... )
	
end

function love.update( ... )
	-- body
end

function love.draw( ... )
	-- body
end