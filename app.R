library(shinydashboard)
library(data.table)
library(dygraphs)
library(lubridate)
library(DT)
library(dplyr)
library(ggpubr)
library(scales)
library(plotly) 
library(glue)

theme_algoritma <- theme(legend.key = element_rect(fill="white"),
                         legend.background = element_rect(color="white", fill="#FFFFFF"),
                         plot.subtitle = element_text(size=6, color="grey"),
                         panel.background = element_rect(fill="#dddddd"),
                         panel.border = element_rect(fill=NA),
                         panel.grid.minor.x = element_blank(),
                         panel.grid.major.x = element_blank(),
                         panel.grid.major.y = element_line(color="white", linetype=2),
                         panel.grid.minor.y = element_blank(),
                         plot.background = element_rect(fill="#FFFFFF"),
                         text = element_text(color="black"),
                         axis.text = element_text(color="black")
                         
)


#setwd('C:/Users/ejhas/OneDrive/Documents/BIMTEK/PASUT/caps/capscaps/Capstone_Project/')
covid <- fread('covid_19_clean_complete.csv')

# rename columns and sort rows
setnames(covid, c("state", "country", "lat", "long", "date", "confirmed", "deaths", "recovered", "active", "region"))
setorder(covid, country, date)

# calculate daily values for each country
covid[, daily_confirmed := c(diff(confirmed), NA), by=country]
covid[, daily_recovered := c(diff(recovered), NA), by=country]
covid[, daily_deaths := c(diff(deaths), NA), by=country]


# dygraph(covid[country=="Afghanistan", .(date, daily_confirmed)])
# dygraph(covid[country=="Afghanistan", .(date, active)])
# 
# covid[, date := ymd(date)]

covid[, month := month(date)]
covid[, month := month.name[month]]

covid  %>% 
    group_by()

# get ui choices list
county_list <- covid[, unique(country)]
column_list <- c("confirmed", "deaths", "recovered", "active", 
                 "daily_confirmed", "daily_recovered", "daily_deaths")

month_list <- covid[, unique(month)]


selected_month <- "June"
df <- subset(covid, covid$month == selected_month) 
setnames(df, "daily_confirmed", "value")

top5 <- df %>% 
    group_by(country) %>%
    summarise(total=sum(value)) %>%
    data.table

top5 <- top5[order(-top5$total)][1:5]

ui <- dashboardPage(skin = "red",
                    dashboardHeader(title = "COVID-19 Cases Worldwide"),
                    
                    dashboardSidebar(
                        sidebarMenu(
                            menuItem("Trends", tabName = "dashboard", icon = icon("arrow-trend-up")),
                            menuItem("Worldwide Cases", tabName = "widgets", icon = icon("globe")),
                            menuItem("Top 5 Cases", tabName = "top5", icon = icon("virus-covid"))
                        )
                    ),
                    
                    dashboardBody(
                        tabItems(
                            # First tab content
                            tabItem(tabName = "dashboard",
                                    fluidRow(
                                        column(6, selectInput("tab1_country_dropwdown", "Country", choices=county_list)),
                                        column(6, selectInput("tab1_column_dropwdown", "Options", choices=column_list))
                                    ),
                                    fluidRow(
                                        column(12, dygraphOutput("plot1"))
                                    )
                            ),
                            
                            # Second tab content
                            tabItem(tabName = "widgets",
                                    fluidRow(
                                        column(6, selectInput("tab2_country_dropwdown", "Country", choices=county_list))                    ),
                                    fluidRow(
                                        column(12, dataTableOutput("tab2_table"))
                                    )
                            ),
                            
                            # thrid tab content
                            tabItem(tabName = "top5",
                                    fluidRow(
                                        column(6, selectInput("tab3_month_dropwdown", "Month", choices=month_list)),
                                        column(6, selectInput("tab3_column_dropwdown", "Options", choices=c("daily_confirmed", "daily_recovered", "daily_deaths")))
                                    ),
                                    fluidRow(
                                        column(12, plotlyOutput("tab3_table"))
                                    )
                            )
                            
                        )    
                        
                    )
)


# subset(covid, covid$month == selected_month)

server <- function(input, output) {
    
    output$plot1 <- renderDygraph({
        df <- covid[country == input$tab1_country_dropwdown]
        select_columns <- c("date", input$tab1_column_dropwdown)
        dygraph(df[, ..select_columns]) %>% dyRangeSelector()
    })
    
    output$tab2_table <- renderDataTable({
        covid[country == input$tab2_country_dropwdown]
    })
    
    output$tab3_table <- renderPlotly({
        
        df <- subset(covid, covid$month == input$tab3_month_dropwdown)
        setnames(df, input$tab3_column_dropwdown, "value")
        
        top5 <- df %>% 
            group_by(country) %>%
            summarise(total=sum(value)) %>%
            data.table
        
        top5 <- top5[order(-top5$total)][1:5] %>% 
            mutate(label=glue("Total: {total} Cases"))
        
        top5_plot <- top5 %>% 
            ggplot(mapping = aes(x=total,
                                 y=reorder(country, total), 
                                 text=label))+
            geom_col(fill="#182587")+
            labs(title = "Top 5 Covid Cases",
                 x=NULL,
                 y="Country")+
            scale_y_discrete(labels=wrap_format(30))+
            theme_algoritma
        
        ggplotly(top5_plot, tooltip="text")
    })
    
}

shinyApp(ui, server)