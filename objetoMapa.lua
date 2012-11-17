local obj = {}
obj.cuadColi = {}

function obj:init(tipo, x, y, ancho, alto, desX, desY)

	obj.cuadColi.x = x
	obj.cuadColi.y = y
	obj.cuadColi.w = ancho
	obj.cuadColi.h = alto
	obj.tipo = tipo
	obj.cuadColi.desX = desX
	obj.cuadColi.desY = desY
end

return obj