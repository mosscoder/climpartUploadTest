ui <- fluidPage(
  useShinyalert(),
  sidebarLayout(
    sidebarPanel(width=2,
                 fluidRow(
                   img(src="./usgs.log.png", height=81, width=180),
                   
                   conditionalPanel("!output.loading", 
                                    HTML('<b><font color="red">App may take a minute or more to initialize, please wait.</font></b>')),
                   
                   selectInput("boundSelect", label = ("How would you like to define your area of interest?"), 
                               choices = list("Lat/Long Slider Bars" = "slider", 
                                              "Spatial Polygon" = "poly"),
                               selected = "slider"),
                   
                   conditionalPanel( condition = "input.boundSelect == 'poly'",             
                                     fileInput("boundFile2", 
                                               label = "Upload spatial polygon files (.shp, .shx, .prj, and .dbf) compressed into a .zip format:")),
                   
                   conditionalPanel(condition = "input.boundSelect == 'slider'",
                                    sliderInput("lat.range",
                                                label = "Latitude Extent", 
                                                min = 15, max = 60,
                                                value=c(32,42))),
                   
                   conditionalPanel(condition = "input.boundSelect == 'slider'",  
                                    sliderInput("lon.range",
                                                label = "Longitude Extent", 
                                                min =-135, max = -45,
                                                value=c(-115,-105))),
                   
                   sliderInput("cluster.num", label = "Number of climate paritions:", 
                               ticks = F, value=5, min = 1, max = 50, step = 1),
                   
                   actionButton("goButton", label=HTML("<b>Generate Partitions</b>"), 
                                style = "background-color: #18B66A; color: #fff; border-color: #ffffff; width: 190px"),
                   
                   downloadButton('downloadData', 'Download Data', style = ' width: 190px;'),
                   
                   helpText("Click above to download underlying rasters and summary data. Note that clicking will open a new tab."),
                   
                   actionButton('moreInfo', label = HTML("<b>Contact Info & Disclaimer</b>"),
                                style = 'background-color: #008CBA; color: #fff;border-color: #ffffff; width: 190px'))), 
    
    mainPanel(width = 10,
              tabsetPanel(id = "tabs",
                          tabPanel("Map", id="map", leafletOutput("leaf",width="100%", height = "700px") %>% withSpinner(size = 3)),
                          tabPanel("Climate Center Data", dataTableOutput("centerTable")),
                          tabPanel("Within-Assignment Distributions", id="box", plotOutput("boxPlot", height=2000) %>% withSpinner( size = 20)),
                          tabPanel("Background and Use", id="background", includeText("instruct.txt"))
              ))
    
  )
)