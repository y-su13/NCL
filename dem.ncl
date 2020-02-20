begin

    plot = new(2, graphic) ; 绘制两张子图
    wks  = gsn_open_wks("png", "dem") ; 输出图片格式png，文件名dem

    ; ------ set the resources ------

    lnres                  = True
    lnres@gsLineColor      = "black" ; 线的颜色为黑色
    lnres@gsLineThicknessF = 5.0 ; 线的宽度为5.0
    lnres@PanelPlot        = True

    res = True

    res@cnFillOn          = True
    res@cnLinesOn         = False
    res@cnLineLabelsOn    = False
    
    res@txFontHeightF            = 0.04
    res@txFont                   = "times-roman"
    res@tmXBLabelFontHeightF     = 0.035
    res@tmXBLabelFont            = "times-roman"
    res@tmYLLabelFontHeightF     = 0.035
    res@tmYLLabelFont            = "times-roman" ; 设置各类字体

    res@gsnMaximize = True
    res@cnFillPalette = "OceanLakeLandSnow" ; colormap
    
    ; 自定义刻度
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnMinLevelValF    = -500
    res@cnMaxLevelValF    = 5000
    res@cnLevelSpacingF   = 500 ; 自定义colormap的interval
    ; 自定义经纬度范围
    res@gsnAddCyclic      = False
    res@lbLabelBarOn      = True

    res@mpMinLatF         = 10
    res@mpMaxLatF         = 55
    res@mpMinLonF         = 39.5
    res@mpMaxLonF         = 140 ; 定义x的绘制范围

    res@lbLabelBarOn      = False
    
    ;绘制图1
    f = addfile("DEM025.nc","r")

    x    = f->temp
    lat  = f->latitude
    lon  = f->longitude
    
    x!0 = "lat"
    x!1 = "lon"
    x&lon = lon ; 定义x的经纬度
    x&lat = lat
    x@_FillValue = 0
    replace_ieeenan(x, -9999.0, 0) ; 将0值赋值为-9999.0
    x@_FillValue = -9999.0 ; 将-9999.0赋值为nan值，小细节：ncl直接将0赋值为nan会出问题

    plot(0) = gsn_csm_contour_map(wks, x, res)
    
    ;绘制图2
    g = addfile("DEM01.nc","r")

    x1    = g->temp
    lat1  = g->latitude
    lon1  = g->longitude

    x1!0 = "lat"
    x1!1 = "lon"
    x1&lon = lon1 ; 定义x1的经纬度
    x1&lat = lat1

    res@mpMinLatF         = 30
    res@mpMaxLatF         = 45
    res@mpMinLonF         = 71.5
    res@mpMaxLonF         = 105 ; 定义x1的绘制范围，其他参数同x
    
    res@txFontHeightF     = 0

    plot(1) = gsn_csm_contour_map(wks, x1, res)
    
    ;绘制边界 
    filename ="研究区域边界.shp"
    line = gsn_add_shapefile_polylines(wks,plot,filename,lnres)

    pres = True
    pres@gsnPanelLabelBar = True
    pres@lbLabelStride      = 1
    pres@lbLabelFontHeightF = 0.04
    pres@lbLabelFont        = "times-roman" ; 定义colorbar
    gsn_panel(wks, plot, (/2, 1/), pres)
    frame(wks)

end