-- Scanner

local mat = CreateMaterial(
	"UnlitGeneric",
	"GMODScreenspace",
	{
		["$basetexturetransform"] = "center .5 .5 scale -1 -1 rotate 0 translate 0 0",
		["$texturealpha"] = "0",
		["$vertexalpha"] = "1",
	}
)

local uid=0
TARDIS:AddScreen("Scanner", {id="scanner", menu=false, order=3}, function(self,ext,int,frame,screen)
	screen.scanner=GetRenderTarget("tardisi_scanner-"..uid.."-"..screen.id,
		screen.width*screen.res,
		screen.height*screen.res,
		false
	)
	uid=uid+1
	screen.scannerang=Angle()
	
	local scanner=vgui.Create("DImage",frame)
	scanner:SetSize(frame:GetWide()-screen.gap2,frame:GetTall()-screen.gap2)
	scanner:SetPos(screen.gap,screen.gap)
	scanner:SetMaterial(mat)
	scanner.OldPaint=scanner.Paint
	scanner.Paint=function()
		mat:SetTexture( "$basetexture", screen.scanner )
		scanner:OldPaint()
	end
	
	local label = vgui.Create("DLabel",frame)
	label:SetFont(TARDIS:GetScreenFont(screen, "Med"))
	label.DoLayout = function()
		label:SizeToContents()
		label:SetPos(frame:GetWide()/2-label:GetWide()/2-screen.gap,frame:GetTall()-label:GetTall()-screen.gap)
	end
	label:SetText("Front")
	label:DoLayout()
	
	local function updatetext(y)
		local text
		if y==-180 or y==180 then
			text="Back"
		elseif y==-90 then
			text="Right"
		elseif y==0 then
			text="Front"
		elseif y==90 then
			text="Left"
		end
		label:SetText(text)
		label:DoLayout()
	end
	
	local back=vgui.Create("DButton",frame)
	back:SetSize(frame:GetTall()*0.2-screen.gap,frame:GetTall()*0.15-screen.gap)
	back:SetPos(screen.gap+1,frame:GetTall()-back:GetTall()-screen.gap-1)
	back:SetText("<")
	back:SetFont(TARDIS:GetScreenFont(screen, "Med"))
	back.DoClick = function()
		screen.scannerang.y=screen.scannerang.y+90
		if screen.scannerang.y>=180 then
			screen.scannerang.y=-180
		end
		updatetext(screen.scannerang.y)
	end
	
	local nxt=vgui.Create("DButton",frame)
	nxt:SetSize(frame:GetTall()*0.2-screen.gap,frame:GetTall()*0.15-screen.gap)
	nxt:SetPos(frame:GetWide()-nxt:GetWide()-screen.gap-1,frame:GetTall()-nxt:GetTall()-screen.gap-1)
	nxt:SetText(">")
	nxt:SetFont(TARDIS:GetScreenFont(screen, "Med"))
	nxt.DoClick = function()
		screen.scannerang.y=screen.scannerang.y-90
		if screen.scannerang.y<=-180 then
			screen.scannerang.y=180
		end
		updatetext(screen.scannerang.y)
	end
end)

hook.Add("RenderScene", "TARDISI_Scanner", function(pos,ang)
	local int=LocalPlayer():GetTardisData("interior")
	local ext=LocalPlayer():GetTardisData("exterior")
	if IsValid(ext) then
		local screens=TARDIS:ScreenActive("Scanner")
		if screens then
			for k,v in pairs(screens) do
				local oldRT = render.GetRenderTarget()
				render.SetRenderTarget( v.scanner )
					render.Clear( 0, 0, 0, 255 )
					render.ClearDepth()
					render.ClearStencil()
					
					local offset = ext.metadata.Exterior.ScannerOffset
					local vec=Vector(offset.x, offset.y, offset.z)
					vec:Rotate(v.scannerang)
					local camOrigin = ext:LocalToWorld(vec)
					local camAngle = ext:LocalToWorldAngles(v.scannerang)
					if IsValid(int) then
						int.scannerrender=true
						int:CallHook("PreScannerRender")
					end
					render.RenderView({
						x = 0,
						y = 0,
						w = v.width*v.res,
						h = v.height*v.res,
						fov = 120,
						origin = camOrigin,
						angles = camAngle,
						drawpostprocess = true,
						drawhud = false,
						drawmonitors = false,
						drawviewmodel = false,
						--zfar = 1500
					})
					if IsValid(int) then
						int.scannerrender=false
						int:CallHook("PostScannerRender")
					end
				render.SetRenderTarget( oldRT )
			end
		end
	end
end)