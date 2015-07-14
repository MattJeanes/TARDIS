--[[
	
3D2D VGUI Wrapper
Copyright (c) 2013 Alexander Overvoorde, Matt Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

if SERVER then
	AddCSLuaFile()
	return
end

local origin = Vector(0, 0, 0)
local angle = Vector(0, 0, 0)
local normal = Vector(0, 0, 0)
local scale = 0

-- Helper functions

local function planeLineIntersect( lineStart, lineEnd, planeNormal, planePoint )
	local t = planeNormal:Dot( planePoint - lineStart ) / planeNormal:Dot( lineEnd - lineStart )
	return lineStart + t * ( lineEnd - lineStart )
end

local matex,matey=0,0
local function testdraw(x,y)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawLine( x, y-16, x, y+16 )
	surface.DrawLine( x-16, y, x+16, y )
end
local function testdraw2(x,y)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawLine(x,-10000,x,10000)
	surface.DrawLine(-10000,y,10000,y)
end


local function getCursorPos()
	local p = planeLineIntersect( LocalPlayer():EyePos(), LocalPlayer():EyePos() + LocalPlayer():GetAimVector() * 16000, normal, origin )
	local offset = origin - p
	
	local angle2 = angle:Angle()
	angle2:RotateAroundAxis( normal, -90 )
	angle2 = angle2:Forward()
	
	local offsetp = Vector(offset.x, offset.y, offset.z)
	offsetp:Rotate(-normal:Angle())

	local x = -offsetp.y
	local y = offsetp.z

	return x, y
end

local function getParents( pnl )
	local parents = {}
	local parent = pnl.Parent
	while ( parent ) do
		table.insert( parents, parent )
		parent = parent.Parent
	end
	return parents
end

local function absolutePanelPos( pnl )
	local x, y = pnl:GetPos()
	local parents = getParents( pnl )
	
	for _, parent in ipairs( parents ) do
		local px, py = parent:GetPos()
		x = x + px
		y = y + py
	end
	return x, y
end

local function pointInsidePanel( pnl, x, y )
	local px, py = absolutePanelPos( pnl )
	local sx, sy = pnl:GetSize()

	x = x / scale
	y = y / scale
	
	return (x >= px and y >= py and x <= px + sx and y <= py + sy), x, y
end

local function drawCrosshair( pnl, size )
	local x,y=getCursorPos()
	local inside,x,y=pointInsidePanel(pnl,x,y)
	if inside then		
		surface.SetDrawColor(0,0,0)
		surface.DrawLine( x, y-size, x, y+size )
		surface.DrawLine( x-size, y, x+size, y )
	end
end

-- Input

local inputWindows = {}

--[[ Breaks context menu and other stuff probably, also doesn't seem to do much
if not guiMouseX then guiMouseX = gui.MouseX end
if not guiMouseY then guiMouseY = gui.MouseY end
function gui.MouseX()
	local x, y = getCursorPos()
	return x
end
function gui.MouseY()	
	local x, y = getCursorPos()
	return y
end
]]--

local function isMouseOver( pnl )
	return pointInsidePanel( pnl, getCursorPos() )
end

local curpnl={}
local function postPanelEvent( pnl, event, ... )
	if ( not pnl:IsValid() or not isMouseOver( pnl ) or not pnl:IsVisible() ) then return false end	
	local handled = false
	for i,child in ipairs( pnl.Childs or {} ) do
		if ( postPanelEvent( child, event, ... ) ) then
			handled = true
			break
		end
	end
	
	if ( not handled and pnl[ event ] ) then
		pnl[ event ]( pnl, ... )
		if event=="OnMousePressed" and not curpnl[pnl] then
			curpnl[pnl]=true
		end
		return true
	else
		return false
	end
end

local function checkHover( pnl, x, y )
	pnl.WasHovered = pnl.Hovered
	if not (x and y) then
		x,y=getCursorPos()
	end
	pnl.Hovered = pointInsidePanel( pnl, x, y )
	if not pnl.WasHovered and pnl.Hovered then
		if pnl.OnCursorEntered then pnl:OnCursorEntered() end
	elseif pnl.WasHovered and not pnl.Hovered then
		if pnl.OnCursorExited then pnl:OnCursorExited() end
	end

	for i, child in ipairs( pnl.Childs or {} ) do
		if ( child:IsValid() and child:IsVisible() ) then checkHover( child, x, y ) end
	end
end

--[[
hook.Add("Think", "3d2dasd", function()
	for k,v in pairs(curpnl) do
			matex,matey=absolutePanelPos(k)
			local x,y=k:CursorPos()
			matex=matex+x
			matey=matey+y
		if k.Hovered and k.OnCursorMoved then
			local px,py=getCursorPos()
			--k:OnCursorMoved(5,0)
		end
	end
end)
]]--

local function facingPanel( pnl )
	local vec = GetViewEntity():GetPos() - pnl.Origin

	if pnl.Normal:Dot( vec ) > 0 then
		return true
	end
end

-- Mouse input

hook.Add( "KeyPress", "VGUI3D2DMousePress", function( _, key )
	if ( key == IN_USE ) then
		for pnl in pairs( inputWindows ) do
			if ( pnl:IsValid() and facingPanel( pnl ) ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal
				
				postPanelEvent( pnl, "OnMousePressed", MOUSE_LEFT )
			end
		end
	end
end )

hook.Add( "KeyRelease", "VGUI3D2DMouseRelease", function( _, key )
	if ( key == IN_USE ) then
		local fnd=false
		for pnl in pairs( inputWindows ) do
			if ( pnl:IsValid() and facingPanel( pnl ) ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal
				
				postPanelEvent( pnl, "OnMouseReleased", MOUSE_LEFT )
			end
		end
		if not fnd then
			for k,v in pairs(curpnl) do
				if k:IsValid() and k.OnMouseReleased then
					k:OnMouseReleased( MOUSE_LEFT )
				end
				curpnl={}
			end
		end
	end
end )

-- Key input

--[[
local textpnl
function vgui.TextInput( pnl )
	textpnl=pnl
	input.StartKeyTrapping()
end

hook.Add("StartCommand", "VGUI3D2DTextInput", function(ply,cmd)
	if IsValid(textpnl) then
		cmd:ClearMovement()
	end
end)

hook.Add("SetupMove", "VGUI3D2DTextInput", function(ply,mv,cmd)
	if IsValid(textpnl) then
		mv:SetButtons(0)
	end
end)

local lastkey
hook.Add("Think", "VGUI3D2DTextInput", function()
	if IsValid(textpnl) then
		local key=input.CheckKeyTrapping()
		if key then
			local text=textpnl:GetText()
			if key==KEY_ESCAPE or key==KEY_ENTER then
				if key==KEY_ENTER then
					textpnl:OnEnter()
				end
				textpnl=nil
				return
			elseif key==KEY_BACKSPACE then
				text=text:sub(1,-2)
			else
				local char=""
				if key>=1 and key<=36 then
					char=input.GetKeyName(key)
				end
				text=text..char
			end
			textpnl:SetText(text)
			input.StartKeyTrapping()
		end
	end
end)
]]--

-- Drawing:

function vgui.Start3D2D( pos, ang, res )
	origin = pos
	scale = res
	angle = ang:Forward()
	
	normal = Angle( ang.p, ang.y, ang.r )
	normal:RotateAroundAxis( ang:Forward(), -90 )
	normal:RotateAroundAxis( ang:Right(), 90 )
	normal = normal:Forward()
	
	cam.Start3D2D( pos, ang, res )
end

local _R = debug.getregistry()
function _R.Panel:Paint3D2D()
	if not self:IsValid() then return end
	
	-- Add it to the list of windows to receive input
	inputWindows[ self ] = true
	
	-- Override think of DFrame's to correct the mouse pos by changing the active orientation
	if self.Think then
		if not self.OThink then
			self.OThink = self.Think
			
			self.Think = function()
				origin = self.Origin
				scale = self.Scale
				angle = self.Angle
				normal = self.Normal
				
				self:OThink()
			end
		end
	end
	
	-- Update the hover state of controls
	checkHover( self )
	
	-- Store the orientation of the window to calculate the position outside the render loop
	self.Origin = origin
	self.Scale = scale
	self.Angle = angle
	self.Normal = normal
	
	-- Draw it manually
	self:SetPaintedManually( false )
		self:PaintManual()
		if self.crosshair then 
			drawCrosshair(self,self.crosshair)
		end
		--testdraw(matex,matey)
	self:SetPaintedManually( true )
end

function vgui.End3D2D()
	cam.End3D2D()
end

function vgui.SetParent3D2D(pnl,parent) -- todo: find way to do this automatically
	pnl:SetParent(parent)
	if pnl.Parent then
		table.RemoveByValue(pnl.Parent.Childs, pnl)
	end
	pnl.Parent = parent
	if parent then
		if not parent.Childs then parent.Childs = {} end
		table.insert(parent.Childs,1,pnl)
	end
end

-- Keep track of child controls

if not vguiCreate then vguiCreate = vgui.Create end
function vgui.Create( class, parent )
	local pnl = vguiCreate( class, parent )
	if not pnl then return end
	pnl.Class = class
	vgui.SetParent3D2D(pnl, parent)
	
	return pnl
end