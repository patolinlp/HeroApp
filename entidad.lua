local ent = {}
ent.cuadColi =
	{
		x = 0,
		y = 0,
		w = 0,
		h = 0,
	}

	ent.minusX = 0
	ent.minusY = 0

	ent.tipo = 0
	ent.quad = 0
	ent.vx = 350
	ent.vy = 600
	ent.aceX = 100
	ent.aceY = 1600

	ent.vxReal = ent.vx
	ent.vyReal = 0

	ent.tiempoSalto = 0.07
	ent.saltando = 0

	ent.estado = "normal"
	ent.lugar = "tierra"

	ent.sprite = new("spriteAnim")
	ent.tiempoSpt = 0.1
	ent.tiempoSptReal = 0
	ent.orientacion = 1

	ent.fisica = true

function ent:init(x, y, ancho, alto, tipo, quad)
	print("ooo1")
	ent.sprite:init()
	print("ooo2")

	ent.cuadColi.x = x
	ent.cuadColi.y = y
	ent.cuadColi.w = ancho
	ent.cuadColi.h = alto
	ent.tipo = tipo
	ent.quad = quad
end

function ent:update( dt )
	if ent.fisica then
		local coliser = mapa:colisiona(ent.cuadColi.x, ent.cuadColi.y +4, ent.cuadColi.w, ent.cuadColi.h)
		local estado = ent.estado
		if not coliser and (ent.estado == "normal" or ent.lugar == "tierra") then
			ent.estado = "cayendo"
			ent.lugar = "aire"
		end

		if ent.estado == "saltando" and ent.lugar == "aire" then
			local coli, cuad = mapa:colisiona(ent.cuadColi.x, ent.cuadColi.y - ent.vyReal*dt, ent.cuadColi.w, ent.cuadColi.h)
			if  not coli and ent.saltando <= ent.tiempoSalto then
				ent.cuadColi.y = ent.cuadColi.y - ent.vyReal*dt
				ent.saltando = ent.saltando + dt
			elseif not coli and ent.saltando > ent.tiempoSalto and ent.vyReal >= 0 then
				ent.cuadColi.y = ent.cuadColi.y - ent.vyReal*dt
				ent.vyReal = ent.vyReal - ent.aceY * dt
			else
				ent.estado = "cayendo"
				ent.saltando = 0
				ent.vyReal = 0
			end
		end


		if ent.estado == "cayendo" and ent.lugar == "aire" then
			local coli, cuad = mapa:colisiona(ent.cuadColi.x, ent.cuadColi.y + ent.vyReal*dt, ent.cuadColi.w, ent.cuadColi.h)
			if  not coli then
					ent.cuadColi.y = ent.cuadColi.y + ent.vyReal*dt
					ent.vyReal = ent.vyReal + ent.aceY * dt
			else
				ent.cuadColi.y = cuad.cuadColi.y - ent.cuadColi.h - 1
				ent.lugar = "tierra"
				ent.estado = "normal"
				ent.vyReal = 0
			end
		end



		if love.keyboard.isDown(" ") and ent.lugar == "tierra" then
			ent.estado = "saltando"
			ent.lugar = "aire"
			ent.vyReal = ent.vy
		end

		--if love.keyboard.isDown(" ") and ent.lugar == "aire" and ent.estado == "saltando" then
		--	ent.vyReal = 0
		--	ent.estado = "cayendo"
		--end		

		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			local coli, cuad = mapa:colisiona(ent.cuadColi.x - ent.vx*dt, ent.cuadColi.y, ent.cuadColi.w, ent.cuadColi.h)
			if  not coli then
				ent.cuadColi.x = ent.cuadColi.x - ent.vx*dt
				ent.orientacion = -1
				if ent.lugar == "tierra" then
					ent.estado = "corriendo"
				end
			else
				if ent.lugar == "tierra" then
					ent.estado = "normal"
				end
			end

		end

		if love.keyboard.isDown("d") or love.keyboard.isDown("right")then
			local coli, cuad = mapa:colisiona(ent.cuadColi.x + ent.vx*dt, ent.cuadColi.y, ent.cuadColi.w, ent.cuadColi.h)
			if  not coli then
				ent.cuadColi.x = ent.cuadColi.x + ent.vx*dt
				ent.orientacion = 1
				if ent.lugar == "tierra" then
					ent.estado = "corriendo"
				end
			else
				if ent.lugar == "tierra" then
					ent.estado = "normal"
				end
			end
		end

		if ent.lugar == "tierra" and not love.keyboard.isDown("right") and not love.keyboard.isDown("left") 
			and not love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
			ent.estado = "normal"
		end
		if estado ~= ent.estado then
			ent.tiempoSptReal = ent.tiempoSpt+1
		end

		
	else
		ent.estado = "normal"
		if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
			ent.cuadColi.x = ent.cuadColi.x - 400*dt
		end
		if love.keyboard.isDown("d") or love.keyboard.isDown("right")then
			ent.cuadColi.x = ent.cuadColi.x + 400*dt
		end
		if love.keyboard.isDown("w") or love.keyboard.isDown("up")  then
			ent.cuadColi.y = ent.cuadColi.y - 400*dt
		end
		if love.keyboard.isDown("s") or love.keyboard.isDown("down")  then
			ent.cuadColi.y = ent.cuadColi.y + 400*dt
		end
	end


	if ent.tiempoSptReal >= ent.tiempoSpt then
		ent.sprite:siguiente(ent.estado, ent.orientacion)
		ent.tiempoSptReal = 0
	end

	ent.tiempoSptReal = ent.tiempoSptReal + dt

	if ent.cuadColi.x < 0 then
		ent.cuadColi.x = 0
	end
	if ent.cuadColi.y < 0 then
		ent.cuadColi.y = 0
	end
end




function ent:draw()
	gfx.draw(ent.sprite.batchs[ent.sprite.estado], ent.cuadColi.x, ent.cuadColi.y)
end

return ent