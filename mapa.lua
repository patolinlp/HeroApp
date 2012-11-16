local mapa = {}
	mapa.matrizObjetos = {}		--la matriz de objetos colisionable
	mapa.w = 100				--ancho de la matrizObjeto
	mapa.h = 100				--alto de la matrizObjeto
	mapa.size = 100				--tamaño de cada celda de la matrizObjeto

	mapa.objetos = {}
	mapa.enemigos = {}			--enemigos del mapa
	mapa.movibles = {}			--objetos que se mueven en el mapa 
	mapa.jugadores = {}			--jugadores del mapa

	mapa.texs = {}				--texturas

	mapa.tipoTex = {}			--tipo de texturas
	mapa.batch = nil			--batch donde se cargan las texturas
	mapa.rangoVision = 2		--rango agregado de vision desde donde se cargan las texturas

function mapa:ubicarObjeto( objeto ) --ubica un objeto en el mapa, lo incluye en la matrizObjetos y Objetos

	local iniX = math.floor(objeto.cuadColi.x/mapa.sizeCelda)
	local finX = math.floor((objeto.cuadColi.x + objeto.cuadColi.w)/mapa.sizeCelda)
	local iniY = math.floor(objeto.cuadColi.y/mapa.sizeCelda)
	local finY = math.floor((objeto.cuadColi.y + objeto.cuadColi.h)/mapa.sizeCelda)

	for i = iniX, finX do
		for j = iniY, finY do
			local n = table.getn(mapa.matrizObjetos[i][j])
			mapa.matrizObjetos[i][j][objeto] = objeto
		end
	end

	mapa.objetos[iniX][iniY][table.getn(dir)+1] = objeto
end

function mapa:eliminarObjeto( x, y ) --elimina un objeto en la posicion x,y. Busca el primero que encuentra y lo elimina

	for f = 0, table.getn(mapa.objetos) do
		for j = 0,  table.getn(mapa.objetos[f]) do
			for i=table.getn(mapa.objetos[f][j]) , 1,-1 do
				local obj = mapa.objetos[f][j][i]
				if colision(obj.cuadColi, {x = x, y = y, w = 1, h = 1}) then
					for k = i, table.getn(mapa.objetos[f][j]) do
						mapa.objetos [f][j][k] = mapa.objetos[f][j][k+1]
						mapa.objetos [f][j][k+1] = nil
					end
					for i=math.floor(obj.cuadColi.x/mapa.sizeCelda), ((obj.cuadColi.x + obj.cuadColi.w)/mapa.sizeCelda) do
						for j=math.floor(obj.cuadColi.y/mapa.sizeCelda), ((obj.cuadColi.y + obj.cuadColi.h)/mapa.sizeCelda) do
							mapa.matrizObjetos[math.floor(i)][math.floor(j)][obj] = nil
						end
					end
					return
				end
			end
		end
	end
end

function mapa:colisiona( x, y, w, h )
	if x >= 0 and y >= 0 then
		for i = math.floor(x/mapa.sizeCelda), math.floor((x+w)/mapa.sizeCelda) do
			for j = math.floor(y/mapa.sizeCelda), math.floor((y+h)/mapa.sizeCelda)  do
				local q = {x = x, y = y, w = w, h = h}
				for k, v in pairs(mapa.matrizObjetos[i][j]) do
					if colision(q, v.cuadColi) then
						return true, v
					end
				end
			end	
		end
	end
	return false
end

function mapa:borrarMapa(  )
	mapa.matrizObjetos = {} 
	mapa.objetos = {}
	mapa:init()
end

function mapa:update()

	mapa.batch:bind()
    mapa.batch:clear()

    for i = math.floor(((mono.cuadColi.x - wt/2)/mapa.size)-mapa.rangoVision), math.floor(((mono.cuadColi.x + wt/2)/mapa.size)+mapa.rangoVision) do
    	if i>=0 then
    		for j = math.floor(((mono.cuadColi.y - ht/2)/mapa.size)-mapa.rangoVision), math.floor(((mono.cuadColi.y + ht/2)/mapa.size)+mapa.rangoVision) do
    			if j >=0 then
    				for a, v in pairs(mapa.objetos[i][j]) do
    					mapa.batch:addq(mapa.tipoTex[v.tipo], v.cuadColi.x - v.cuadColi.desX, v.cuadColi.y - v.cuadColi.desY)
    				end
				end
    		end
    	end
  	end
    mapa.batch:unbind()
end

function mapa:update( )
	
end

function mapa:draw( )
	gfx.draw(mapa.batch, 0, 0)
end

return mapa