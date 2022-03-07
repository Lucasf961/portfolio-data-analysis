library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(scales)
library(ggplot2)
library(plotly)
library(leaflet)
library(bslib)
library(DT)
library(plyr)
library(dplyr)
library(tidyr)
library(readxl)

area_chart <- read.csv("data/area_chart.csv")
ataques_grupo <- read.csv("data/ataques_grupo.csv")
ataques_paises <- read.csv("data/ataques_paises.csv")
tipo_alvo <- read.csv("data/tipo_alvo.csv")
tipo_arma <- read.csv("data/tipo_arma.csv")
tipo_ataque <- read.csv("data/tipo_ataque.csv")
dados_clean <- read.csv("data/dados_clean.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  
  # Cor de Fundo
  shinyWidgets::setBackgroundColor(
    color = c("#DCDCDC", "#FFFFFF"),
    gradient = "linear",
    direction = 'top'),
  setSliderColor(c("#151515", "#151515", "#151515"), c(1, 2, 3)),
  
  # NavBarPage
  navbarPage(
    title = "Terrorism Worldwide",
    collapsible = TRUE,
    position = "fixed-top",
    tags$style("body {padding-top: 85px;}"),
    theme = bs_theme(
      base_font = font_google("Staatliches"),
      bg = "#FFFFFF",fg = "Black", primary = 'Black',
      "font-size-base" = "0.95rem"),
    
    
    
    # Primeira Página
    tabPanel(
      "DashBoard",
      # Layout da barra lateral
      sidebarLayout(
        # Barra lateral
        sidebarPanel(width = 3,
                     
                     # Input 1
                     selectInput("dataset", "Selecione a Categoria de Análise:",
                                 choices = c("Análise por País Alvo",
                                             "Análise por Tipo do Ataque",
                                             "Análise por Alvo do Ataque",
                                             "Análise por Organização Criminosa",
                                             "Análise por Tipo de Arma Utilizada")),
                     # Input 2
                     sliderInput("ano",
                                 "Selecione o Ano ou clique no play:",
                                 min = 1975,
                                 max = 2019,
                                 value = 2019,
                                 animate = animationOptions(interval = 1500),
                                 sep = ""),
                     
                     #Input 3
                     sliderInput("kills",
                                 "Número Mínimo de Mortes:",
                                 min = 1,
                                 max = 500,
                                 value = 20,
                                 step = 1),
                     
                     #Input 4
                     sliderInput("ataques",
                                 "Número Mínimo de Ataques:",
                                 min = 1,
                                 max = 100,
                                 value = 1,
                                 step = 1),
                     
                     #Input 6
                     actionButton("update",
                                  "Atualizar")),
        
        # Área de plotagem
        
        #Bubble plot
        mainPanel(tabsetPanel(type = 'tabs',
                              
                              tabPanel('Análise por Categoria',
                                       box(plotlyOutput("bubblePlot", height = "450px"), width = NULL)),
                              
                              
                              # Bar plot
                              tabPanel('Casos ao Longo dos Anos',
                                       box(plotlyOutput("areachart", height = "450px"),width = NULL)))
        )
      )
    ),
    
    
    # Segunda Página
    tabPanel(
      "Mapa",
      
      # Layout da barra lateral
      sidebarLayout(
        # Barra lateral
        sidebarPanel(width = 3,
                     
                     # Input 1
                     selectizeInput("pais", "País (Até 5 Opcões):",
                                    choices = sort(unlist(unique(dados_clean$country_txt))),
                                    multiple = TRUE,
                                    options = list(maxItems = 5),
                                    selected = c('United States',"Brazil")),
                     tags$style(type='text/css', ".selectize-dropdown-content {max-height: 400px; }"),
                     
                     
                     # Input 2
                     dateRangeInput("date",
                                    label = 'Data (AAAA-MM-DD):',
                                    start = '1970-01-01',
                                    end = '2019-12-31',
                                    format = "yyyy-mm-dd"),
                     
                     #Input 4
                     actionButton("update2",
                                  "Atualizar")),
        
        # Área de plotagem
        
        # Mapa
        mainPanel(box(leafletOutput("map", height = '510px', width = '925px'), width = NULL))
      )
    ),
    
    
    # Terceira Página          
    tabPanel(
      "Dados",
      dataTableOutput("table")
    ),
    
    # Quarta Página
    tabPanel(
      "Detalhes",includeMarkdown("README.md")
    )
  )
  
)


server <- function(input, output){
  
  # Primeira Página
  
  # Input Update Bubble plot
  BubblePlotInput <- eventReactive(
    input$update, {switch(input$dataset,
                          "Análise por País Alvo" = ataques_paises[!(ataques_paises$Mortes < input$kills | ataques_paises$Ataques < input$ataques),],
                          
                          "Análise por Tipo do Ataque" = tipo_ataque[!(tipo_ataque$Mortes < input$kills | tipo_ataque$Ataques < input$ataques),],
                          
                          "Análise por Alvo do Ataque" = tipo_alvo[!(tipo_alvo$Mortes < input$kills | tipo_alvo$Ataques < input$ataques),],
                          
                          "Análise por Organização Criminosa" = ataques_grupo[!(ataques_grupo$Mortes < input$kills | ataques_grupo$Ataques < input$ataques),],
                          
                          "Análise por Tipo de Arma Utilizada" = tipo_arma[!(tipo_arma$Mortes < input$kills | tipo_arma$Ataques < input$ataques),])},
    ignoreNULL = FALSE
  )
  
  # Input Update Area Chart
  AreaInput <- eventReactive(
    input$update, {area_chart[!(area_chart$Mortes < input$kills | area_chart$Ataques < input$ataques), ]},
    ignoreNULL = FALSE
  )
  
  
  # Gráfico de Bolhas
  
  output$bubblePlot <- renderPlotly({
    
    filtered_df <- BubblePlotInput()
    
    filtered_df$Ano <- as.integer(filtered_df$Ano)
    
    filtered_data <- filtered_df[!(filtered_df$Ano > input$ano), ]
    
    ymin <- min(filtered_data$Mortes)
    ymax <- max(filtered_data$Mortes)
    
    bplot <- ggplot(filtered_data, aes(x = Ano,
                                       y = Mortes,
                                       Ataques = Ataques,
                                       size = Media,
                                       color = .data[[names(filtered_data)[1]]])) +
      geom_point(alpha = 0.6) +
      ylab("Total de Mortos (Escala de Log)") +
      xlab("Ano") +
      labs(size = '', color = '') +
      scale_x_continuous(breaks = seq(min(filtered_df$Ano),max(filtered_df$Ano) + 1, by = 5)) +
      scale_y_log10(limits = c(ymin, ymax)) +
      theme_gray() +
      theme(plot.title = element_blank(),
            axis.title.x = element_text(size=10),
            axis.title.y = element_text(size=10),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent", color = NA),
            legend.background = element_rect(fill = "transparent", color = NA))
    
    bplot2 <- bplot + 
      scale_colour_hue(l = 15, c = 85, h = c(0,360) + 15)
    
    
    ggplotly(bplot2)
    
    
    
  })
  
  
  # Gráfico de Area
  
  output$areachart <- renderPlotly({
    
    filtered_df2 <- AreaInput()
    
    filtered_df2 <- filtered_df2[!(filtered_df2$Ano > input$ano), ]
    
    aplot <- ggplot(filtered_df2, aes(x = Ano)) +
      geom_bar(aes(y = Mortes, Media = Media, colour = 'Mortes'), fill = 'darkred', stat = 'identity', alpha = 0.6)+
      geom_area(aes(y = Ataques, Media = Media, colour = 'Ataques'), fill = 'yellow', alpha = 0.5) +
      labs(y="Mortes e Ataques", x='Ano') +
      theme_gray() +
      scale_x_continuous(breaks = seq(min(filtered_df2$Ano),max(filtered_df2$Ano) + 1, by = 10)) +
      scale_y_continuous(breaks = seq(0 ,max(filtered_df2$Mortes), by = 2000)) +
      scale_colour_manual("", 
                          breaks = c("Mortes", "Ataques"),
                          values = c("darkred", "yellow")) +
      theme(plot.title = element_blank(),
            axis.title.x = element_text(size=10),
            axis.title.y = element_text(size=10),
            panel.background = element_rect(fill = "transparent"),
            plot.background = element_rect(fill = "transparent", color = NA),
            legend.background = element_rect(fill = "transparent", color = NA))
    
    ggplotly(aplot, tooltip = c('x', 'y', 'Ano', 'Media'))
    
    
  })
  
  # ---------------------------------------------
  
  # Segunda Página do Dashboard
  
  # Mapa
  
  datasetInputMap <- eventReactive(
    input$update2, {dados_clean[dados_clean$country_txt %in% input$pais & dados_clean$Data > input$date[1] & dados_clean$Data < input$date[2], ]},
    ignoreNULL = FALSE
  )
  
  output$map <- renderLeaflet({
    
    dados_mapa <- datasetInputMap()
    
    # Cor do Icone do Mapa
    getColor <- function(color) {
      
      sapply(
        dados_mapa$nkill, function(nkill) {
          if(nkill == 1){
            "blue"
          } else if(nkill <= 9 & nkill > 1){
            "cadetblue"
          } else{
            "black"
          }
        }
      )
    }
    
    # Icone do Mapa
    icons <- awesomeIcons(
      icon = 'ios-close',
      iconColor = 'white',
      library = 'ion',
      markerColor = getColor(dados_mapa)
    )
    
    # Textos Popup
    dados_mapa$popup_label <- paste0('Data: ','<strong>', dados_mapa$Data, '</strong>',
                                     '<br/>','Estado: ','<strong>', dados_mapa$provstate, '</strong>',
                                     '<br/>','Cidade: ','<strong>', dados_mapa$city, '</strong>',
                                     '<br/>', 'Número de Mortos: ', '<strong>', dados_mapa$nkill, '</strong>',
                                     '<br/>','Alvo: ','<strong>', dados_mapa$target1, '</strong>',
                                     '<br/>','Grupo Crimonoso: ','<strong>', dados_mapa$gname, '</strong>',
                                     '<br/>','Detalhes: ','<strong>', dados_mapa$weapdetail, '</strong>') %>% 
      lapply(htmltools::HTML)
    
    
    dados_mapa$popup_text <- paste0('<strong>', 'Motivação:', '</strong>',
                                    '<br/>', dados_mapa$motive, '</strong>') %>% 
      lapply(htmltools::HTML)
    
    
    dados_mapa %>%
      leaflet(options = leafletOptions(minZoom = 2, maxZoom = 12)) %>%
      addAwesomeMarkers(lng= ~longitude, lat= ~latitude, icon=icons, label = dados_mapa$popup_label,
                        clusterOptions = markerClusterOptions(),
                        popup = dados_mapa$popup_text,
                        labelOptions = labelOptions(textsize = "11px")) %>%
      addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
      addLegend("topright", 
                colors =c("#539edb",  "#31465d", "black"),
                labels= c("1", "2 - 9","> 9"),
                title= "Número de Mortes",
                opacity = 3)
    
    
  })
  
  # Terceira Página
  
  # Dados
  output$table<- renderDataTable({
    
    dados <- dados_clean[, c('Data','country_txt','provstate','city',"targtype1_txt","attacktype1_txt","gname","weaptype1_txt",'nkill')]
    
    colnames(dados) <- c('Date','Country','State/Region','City','Target_Type','Attack_Type','Group_Name','Weapon','N_Kills')
    
    datatable(dados, class = 'cell-border stripe',filter = 'top', rownames = FALSE,
              options = list(autoWidth = TRUE))
    
  })
  
}

shinyApp(ui, server)