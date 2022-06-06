library(raster)
library(rasterVis)
library(rgdal)
library(lattice)

library(ggplot2)
library(ggthemes)

library(zoo)
library(sf)
library(sp)

#请参考：https://pjbartlein.github.io/REarthSysSci/rasterVis01.html
#请参考：https://its301.com/article/qq_32832803/110788532

#设定⼯作空间
setwd('D:\\新建文件夹')

#加入字体
windowsFonts(myFont = windowsFont("Times New Roman"))

# set path and shape file name
Boundary_shp_path <- "Boundary/"
Boundary_shp_name <- "boundary_line.shp"
Boundary_shp_file <- paste(Boundary_shp_path, Boundary_shp_name, sep="")

# read the shapefile
Boundary_shp <- read_sf(Boundary_shp_file)
Boundary_outline <- as(st_geometry(Boundary_shp), Class="Spatial")

# plot the outline
#plot(Boundary_outline, col="gray50", lwd=1)

#读取⽂件夹中格式为tif的文件
files = list.files(pattern ='.tif$', full.names = T)

#raster_1 <- raster(files[1], band = 1)
#unique(values(raster_1))

#将前n个⽂件导⼊stack
RasterData <- stack(files[1:31])

#修剪文件的名字
names(RasterData)
RasterDataNames <- gsub("CLCD_v01_","", names(RasterData))
RasterDataNames <- gsub("_clip","", RasterDataNames)
RasterDataNames

#设置Colorbar,很复杂，要做实验。
Color <- colorRampPalette(c("#FFFFFF","#FAE39C","#446F33", "#33A02C", "#ABD37B", "#1E69B4", "#A6CEE3","#CFBDA3","#E24290", "#289BE8"))
labelPosition <- c(-1,0,1,2,3,4,5,6,7,8,9)
label <- c("","Cropland","Forest","Shrub","Grassland","Water","Snow/Ice","Barren","Impervious","Wetland")

MyColorKey <- list(at = labelPosition,
                   labels = list(labels = label,
                                 at = labelPosition + 0.5)
                  )

#使用levelplot进行绘图
plt <- levelplot(RasterData,
          
          col.regions = Color,
          at = labelPosition,
          cut = 11,
          colorkey = MyColorKey,
          
          xlab = NULL,
          ylab = NULL,
          
          #方框透明,注意虚逗号的问题。
          par.settings = list(
            strip.border = list(col = 'transparent'),
            strip.background = list(col = 'transparent'),
            axis.line = list(col = "transparent"),
            
            par.main.text = list(fontsize=12, fontfamily = 'myFont'),
            par.strip.text = list(fontsize=12, fontfamily = 'myFont')
            ),
          
          scales=list(col = 'black'), #小短线
          #layout=c(6, 6), #调整列与行数
          names.attr = RasterDataNames, #重命名
          
          main = "Land cover in the\nMt.Qomolangma National Nature Preserve and surrounding areas", #图名
          #colorkey=list(space="bottom"),
          
          maxpixels = 2e5
         )

#叠加绘图
plt + latticeExtra::layer(sp.lines(Boundary_outline, col="gray50", lwd=0.5))