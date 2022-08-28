-- Scanner

hook.Add("RenderScene", "TARDISI_Scanner", function(pos,ang)
    local int=LocalPlayer():GetTardisData("interior")
    local ext=LocalPlayer():GetTardisData("exterior")
    if IsValid(ext) then
        local scanners = {}
        local screens=TARDIS:ScreenActive("Scanner")
        if screens then
            for k,v in pairs(screens) do
                table.insert(scanners, {enabled=true, rt=v.scanner, ang=v.scannerang, fov=v.scannerfov, width=v.width*v.res, height=v.height*v.res})
            end
        end
        if IsValid(int) and int.scanners then
            local enabled = int:CallHook("ShouldDrawScanners")~=false
            for k,v in pairs(int.scanners) do
                table.insert(scanners, {enabled=enabled, rt=v.rt, ang=v.ang, fov=v.fov, width=v.width, height=v.height})
            end
        end
        for k,v in pairs(scanners) do
            local oldRT = render.GetRenderTarget()
            render.SetRenderTarget( v.rt )
                render.Clear( 0, 0, 0, 255 )
                render.ClearDepth()
                render.ClearStencil()

                if v.enabled then
                    local offset = ext.metadata.Exterior.ScannerOffset
                    local vec=Vector(offset.x, offset.y, offset.z)
                    vec:Rotate(v.ang)
                    local camOrigin = ext:LocalToWorld(vec)
                    local camAngle = ext:LocalToWorldAngles(v.ang)
                    if IsValid(int) then
                        int.scannerrender=true
                        int:CallHook("PreScannerRender")
                    end
                    render.RenderView({
                        x = 0,
                        y = 0,
                        w = v.width,
                        h = v.height,
                        fov = v.fov,
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
                end
            render.SetRenderTarget( oldRT )
        end
    end
end)