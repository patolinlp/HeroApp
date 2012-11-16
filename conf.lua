function love.conf( t )
	t.modules.joystick = false --Habilita el uso del joystick (boolean)
	t.modules.audio = true
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = true
	t.modules.sound = true
	t.modules.thread = true
	t.modules.physics = false
	t.console = true			--habilita la consola
	t.title = "HeroApp"
	t.author = "Diegolas&Patolinlp&PinguinDark"
	t.screen.fullscreen = false
	t.screen.vsync = true
	t.screen.fsaa = 0
	t.screen.width = 800
	t.screen.height = 600
	--t.version = 0.8.0
end