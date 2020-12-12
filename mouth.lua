-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua

t=0
extra = {E={x=72}, X={x=2}, T={x=3}} 
niveau = {num=1, nbFruits=0}
score=0

function initniv1()
	x=96
	y=24
	etat=""
	table.insert(sprites, {type="enemi", sprite=4, x=80, y=30, vx=0, vy=0.5, nspr=3, spridx=0, trsp=15})
	table.insert(sprites, {type="enemi", sprite=4, x=160, y=30, vx=0, vy=0.5, nspr=3, spridx=0, trsp=15})
	niveau.nbEnemis=2
	niveau.nbFruits=0
	for x = 10,50,40 do
			for y = 30,100,30 do
				table.insert(sprites, {type="fruit", sprite=2, x=x, y=y, vx=0, vy=0, nspr=1, spridx=0, trsp=12})
				table.insert(sprites, {type="fruit", sprite=2, x=240-(x+16), y=y, vx=0, vy=0, nspr=1, spridx=0, trsp=12})
				niveau.nbFruits = niveau.nbFruits+2
			end 
	end 
end

function init()
	local pommex = 120-8
	sprites = {
		{type="bouche", sprite=10, x=120-8, y=50, vx=0, vy=0, nspr=3, spridx=0, trsp=15},
		{type="pommeE", sprite=38, x=72, y=4, vx=0, vy=0, nspr=1, spridx=0, trsp=15},
		{type="pommeX", sprite=40, x=92, y=4, vx=0, vy=0, nspr=1, spridx=0, trsp=15},
		{type="pommeT", sprite=42, x=112, y=4, vx=0, vy=0, nspr=1, spridx=0, trsp=15},
		{type="pommeR", sprite=44, x=132, y=4, vx=0, vy=0, nspr=1, spridx=0, trsp=15},
		{type="pommeA", sprite=46, x=152, y=4, vx=0, vy=0, nspr=1, spridx=0, trsp=15},
	}
	if niveau.num == 1 then initniv1() 
	elseif niveau.num == 2 then initniv2()
	end
end

function collision()
	bouche = sprites[1]
	for num = 2, #sprites do
		sprite = sprites[num]
		for x = 0, 15, 15 do
			for y = 0, 15, 15 do
				if (sprite.x < bouche.x+x and bouche.x+x < sprite.x+16) and
					(sprite.y < bouche.y+y and bouche.y+y < sprite.y+16) and 
					pix(bouche.x+x, bouche.y+y) ~= sprite.trsp then
						return num
				end
			end
		end
	end
	return -1
end

function dessinerSprites()
	for num = 1, #sprites do
		sprite = sprites[num]
		spr(sprite.sprite+(sprite.spridx*2), sprite.x, sprite.y, sprite.trsp,1,0,0,2,2)		
		sprite.x = sprite.x + sprite.vx
		sprite.y = sprite.y + sprite.vy
		if sprite.x < 0+8 or
		sprite.x+16 > 240-8  or 
		((sprite.x+16 > 65 and sprite.x < 176) and sprite.y < 22 )
		then
			sprite.vx = sprite.vx * -1
			if num==1 then print("x: "..sprites[1].x .. " y: "..sprites[1].y, 10, 130, 12) end
		end
		
		--if (sprite.x+16 > 240-8 or sprite.x < 0+8) then sprite.vx = sprite.vx * -1 end
		if sprite.y+16 > 136-8 or  
		(sprite.y < 11 and sprite.x < 65) or 
		(sprite.y < 24 and sprite.x > 65 and sprite.x < 176) or
		(sprite.y < 11 and sprite.x > 176) 
		then
			sprite.vy = sprite.vy * -1
		end
		if t%10==0 then
			if sprite.spridx+1 < sprite.nspr then 
				sprite.spridx = sprite.spridx + 1 
			else
				sprite.spridx = 0
			end
		end
	end
	--print("x: "..sprites[1].x .. " y: "..sprites[1].y, 10, 130, 12)
	--rect(176, 11, 5, 5,12)
end

etat="pause"

function TIC()
	if etat=="pause" and not btnp(4,60,6) then
		cls()
		local width=print("NIVEAU "..niveau.num, 50,-50,10,0,2)
		print("NIVEAU "..niveau.num, (240-width)//2,50,10,0,2)
		return
	elseif etat=="pause" and btnp(4,60,6) then
		init()
		etat=""
	end
	bouche=sprites[1]
	if btn(0) then bouche.vy=math.max(bouche.vy-0.05, -3) end
	if btn(1) then bouche.vy=math.min(bouche.vy+0.05, 3) end
	if btn(2) then bouche.vx=math.max(bouche.vx-0.05, -3) end
	if btn(3) then bouche.vx=math.min(bouche.vx+0.05, 3) end
	cls(13)
	--map(30,0)
	map(0,0)
	map(60,0,30,17,0,0,0) -- Score + EXTRA
	dessinerSprites()
	idx=collision()
	if idx > 0 then
		sprite=sprites[idx]
		if sprite.type=="fruit" then
			table.remove(sprites, idx)
			score = score + 100
			niveau.nbFruits = niveau.nbFruits -1
			if niveau.nbFruits == 0 then
				niveau.num = niveau.num + 1
				init()
			end
		elseif sprite.type=="enemi" then
			etat="pause"
		end
	end
	print(score, 5, 3, 12)
	-- PROVISOIRE
	spr(17, 72+4, 0, 0) -- flche dessus pomme
	-- FIN PROVISOIRE
	t=t+1
end

-- <TILES>
-- 002:cccccccccccccccccccc0000ccc06660cc066603c0666030c0660306c0603066
-- 003:cccccccc00000ccc333330cc30000ccc066660cc6066660c0306660c603060cc
-- 004:ff0000fff0cccc0ff0ccccc00cc99cc0099b999cf0999990f0999904ff000044
-- 005:ff0000fff0cccc0f0ccccc0f0cc99cc0c99b99900999990f4099990f440000ff
-- 006:ff0000fff0cccc0f0cc99cc00c9b99c00c9999c0f0c99c0ff0cccc00ff000040
-- 007:ff0000fff0cccc0f0cc99cc00c9b99c00c9999c0f0c99c0f00cccc0f040000ff
-- 008:ff0000fff09b990f0c9999c00cc99cc00cccccc0f0cccc0cf0cccc00ff000040
-- 009:ff0000fff09b990f0c9999c00cc99cc00cccccc0c0cccc0f00cccc0f040000ff
-- 010:fff00000f00222220220cc0c0cc0cc0c0cc000f0f00fffffffffffffffffffff
-- 011:00000fff2222200fc0cc0220c0cc0cc00f000cc0fffff00fffffffffffffffff
-- 012:fffffffffff00000f00222220220cc0c0cc0cc0c0cc000f0f00fffffffffffff
-- 013:ffffffff00000fff2222200fc0cc0220c0cc0cc00f000cc0fffff00fffffffff
-- 014:fffffffffffffffffff00000f00222220220cc0c0cc0cc0c0cc000f0f00fffff
-- 015:ffffffffffffffff00000fff2222200fc0cc0220c0cc0cc00f000cc0fffff00f
-- 017:000000000cccccc000cccc00000cc00000000000000000000000000000000000
-- 018:cc033066cc030c00c02220cc02c2220c0222220c0222220cc02220cccc000ccc
-- 019:0c030cccccc000cccc02220cc02c2220c0222220c0222220cc02220cccc000cc
-- 020:fff04442ffff020cffff0200fff03442f00343300334300f03330ffff000ffff
-- 021:24440fffc020ffff0020ffff24430fff0334300ff0034330fff03330ffff000f
-- 022:ff033444fff03342fff0332cff034420f0344442f0344440f033330fff0000ff
-- 023:444330ff24330fffc2330fff0244f0ff2444430f0444430ff033330fff0000ff
-- 024:fff03444ffff0342ffff0320ffff0342ffff0344ffff0344fffff033ffffff00
-- 025:44430fff2430ffff0230ffff2430ffff4430ffff4430ffff330fffff00ffffff
-- 026:fffffffffffffffff00fffff0cc000f00cc0cc0c0220cc0cf0022222fff00000
-- 027:fffffffffffffffffffff00f0f000cc0c0cc0cc0c0cc02202222200f00000fff
-- 028:fffffffff00fffff0cc000f00cc0cc0c0220cc0cf0022222fff00000ffffffff
-- 029:fffffffffffff00f0f000cc0c0cc0cc0c0cc02202222200f00000fffffffffff
-- 030:f00fffff0cc000f00cc0cc0c0220cc0cf0022222fff00000ffffffffffffffff
-- 031:fffff00f0f000cc0c0cc0cc0c0cc02202222200f00000fffffffffffffffffff
-- 032:4444444400400000004000004444444400000400000004004444444400400000
-- 034:5665656656665666666655666566566656666656666666656656666566656566
-- 035:3434343333333334434333333333434333433333433343333343334343333333
-- 036:ccccccccccc00ccccc0440ccc04430cc0443040c0403ee40c0434ee4c04334ee
-- 037:cccccccccccccccccccccccccccccccccccccccc0ccccccc300ccccce430000c
-- 038:fffffffffffffffffffffff0ffffff03ff000003f0222200022cc22202cc22cc
-- 039:ffffffff00ffffff30ffffff0fffffff0f0000ff0022220f22222220cc222220
-- 040:fffffffffffffffffffffff0ffffff03ff000003f0222200022cc22202cc22c2
-- 041:ffffffff00ffffff30ffffff0fffffff0f0000ff0022220f222222202c222220
-- 042:fffffffffffffffffffffff0ffffff03ff000003f0222200022cc22202cc22cc
-- 043:ffffffff00ffffff30ffffff0fffffff0f0000ff0022220f22222220ccc22220
-- 044:fffffffffffffffffffffff0ffffff03ff000003f0222200022cc22202cc22cc
-- 045:ffffffff00ffffff30ffffff0fffffff0f0000ff0022220f22222220cc222220
-- 046:fffffffffffffffffffffff0ffffff03ff000003f0222200022cc22202cc22cc
-- 047:ffffffff00ffffff30ffffff0fffffff0f0000ff0022220f22222220cc222220
-- 048:8888888833333333333333333333333333333333333333333333333333333333
-- 049:3333333333333333333333338888888800000000000000000000000000000000
-- 050:8883333377783333777783337777783377777733777777337777773377777733
-- 051:3333388833338777333877773387777733777777337777773377777733777777
-- 052:c04ee34ec034ee34cc03eee3cc034eeeccc0344ecccc0333ccccc000cccccccc
-- 053:eeee433044ee440c3344e0cc3333440ceee4433044ee430c334400cc0000cccc
-- 054:02c222c2022222cc022222c2f02222ccf0ee2222ff0eeeeefff0eeeeffff0000
-- 055:22222220c222222022222220cc22220f2222ee0feeeee0ffeeee0fff0000ffff
-- 056:02c222c20222222c022222c2f02222c2f0ee2222ff0eeeeefff0eeeeffff0000
-- 057:2c222220c22222202c2222202c22220f2222ee0feeeee0ffeeee0fff0000ffff
-- 058:02c222220222222202222222f0222222f0ee2222ff0eeeeefff0eeeeffff0000
-- 059:c2222220c2222220c2222220c222220f2222ee0feeeee0ffeeee0fff0000ffff
-- 060:02c222c2022222cc022222c2f02222c2f0ee2222ff0eeeeefff0eeeeffff0000
-- 061:2c222220cc222220c22222202c22220f2222ee0feeeee0ffeeee0fff0000ffff
-- 062:02c222c2022222cc022222c2f02222c2f0ee2222ff0eeeeefff0eeeeffff0000
-- 063:2c222220cc2222202c2222202c22220f2222ee0feeeee0ffeeee0fff0000ffff
-- 064:7777773877777838777783387778333888833338333333883333380088888800
-- 065:7777777777777777777777777777777777777777888888883333333388888888
-- 066:8377777783877777833877778333877783333888883333330883333300888888
-- 067:3377777733777777337777773377777783777777837777778377777783777777
-- 068:7777773377777733777777337777773377777738777777387777773877777738
-- 069:7777777777777777777777777777777777777777777777777777777777777777
-- 070:8888888877777777777777777777777777777777777777777777777777777777
-- </TILES>

-- <MAP>
-- 000:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232030303030303030333646464646464646464646464230303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232131313131313131334545454545454545454545454441313131313131313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000024141414141414141414141414040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:222222222222222222222222222222222222222222222222222222222222323232323232323232323232323232323232323232323232323232323232000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 134:000000000000000000001010100010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 135:101010101010101010101010101010101010101010101010000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <FLAGS>
-- 000:00000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000008080808000000000000000000000000080808080808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </FLAGS>

-- <PALETTE>
-- 000:1a1c2c5d275dff0000b27134ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2ffff00333c57
-- </PALETTE>

