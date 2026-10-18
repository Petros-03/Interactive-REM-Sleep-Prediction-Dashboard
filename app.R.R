#REM Sleep Calculator App

library(shiny)
library(bslib)
library(ggplot2)
library(plotly)

data<-read.csv("04_sleep.csv",sep="-")

#μετατροπή μεταβλητών
data$age<-as.numeric(data$age)
data$sbp<-as.numeric((data$sbp))
data$gender<-factor(data$gender)
data$alcohol<-factor(data$alcohol)
data$caffeine<-factor(data$caffeine)


#κατηγορικες μεταβλητές               
gender<-as.factor(ifelse(data$gender==1,'Woman'
                         ,ifelse(data$gender==0,'Man',0)))
summary(gender)

alcohol<-as.factor(ifelse(data$alcohol==1,'Yes'
                          ,ifelse(data$alcohol==0,'No',0)))
summary(alcohol)

caffeine<-as.factor(ifelse(data$caffeine==1,'Yes'
                           ,ifelse(data$caffeine==0,'No',0)))
summary(caffeine)

necksize<-as.factor(ifelse(data$necksize>=37.50,'1'
                           ,ifelse(data$necksize<37.50,'0',0)))


REM_model<-lm(REM~age+necksize+AI+alcohol,data = data) 
summary(REM_model)

data3<-data[-c(70,29,14,79),]
#removing the 4 outliers

#Final Model
REM_model1.2<-lm(REM~age+necksize+AI+alcohol,data = data3) 
summary(REM_model1.2) 
res1.2<-rstandard(REM_model1.2)
fit1.2<-fitted(REM_model1.2)
resDF1.2<-data.frame(res1.2)



#######################################################################################################

# UI

ui<-navbarPage(title = "REM Sleep Analysis",
               theme = bs_theme(bootswatch = "flatly"),
               tabPanel("REM Sleep Calculator",
               sidebarLayout(
                 sidebarPanel(
                   h4("Patient Data"), 
                          sliderInput(inputId="Age_val", label="Select your Age", min=13, max=90, value=49),
                          sliderInput(inputId="AI_val", label="Select your AI (Awakening Index)", min=0, max=30, value=12,step = 0.1),
                          helpText("Note: AI is defined as the number of times a person wakes up per hour of sleep. The average is 12."),
                        
                          sliderInput(inputId="Neck_val", label="Select Neck Circumference (cm)", min=30, max=50, value=37.5, step=0.5),
                          helpText("Note: In this model, an increase in neck circumference mathematically predicts a higher REM sleep percentage. This occurs because the clinical negative effects of a larger neck (such as sleep apnea) are fully absorbed by the Awakening Index (AI)."),
                          selectInput(inputId="Alcohol_val", label="Do you drink alcohol?", choices = c("Yes"=1, "No"=0)),
                          ),mainPanel(h2("Prediction Result", align = "center"),
                                      br(),
                                      h3("Predicted Percentage of REM Sleep:", align = "center"),
                                      h1(textOutput("Result"), align = "center", style = "color: #2c3e50;") )
                          )),
                 tabPanel("Data Analysis", h3("Relation between REM sleep and AI"),
                          p("The following plot illustrates how the percentage of REM sleep decreases as the Awakening Index (AI) increases. Hover above the dots for details."),
                          plotlyOutput("plotAI")),
                 tabPanel("Model Evaluation", h3("Variable Selection"), p("The model initially had an adjusted R-squared of 0.11, 
                                                where neck circumference was not considered a statistically significant variable.
                                                With the removal of the 4 most extreme outliers, 
                                                the adjusted R-squared improved to 0.16, and neck circumference became
                                                statistically significant. While data for more variables was available,
                                                the combination of variables that yielded the best results for predicting
                                                REM sleep percentage was Age, Neck Circumference, the Awakening Index (AI),
                                                and Alcohol Consumption."),
                          
                          p("As previously noted, while a larger neck circumference clinically tends
                            to lead to an increase in AI (e.g., due to sleep apnea), 
                            this model mathematically evaluates an increase in neck circumference
                            while assuming AI remains constant. Thus, the negative clinical effects of a 
                            larger neck size are embedded within the AI variable, 
                            leaving the neck circumference variable to capture a different, isolated effect."),
                          h3("Diagnostic Plots"),
                          fluidRow(column(width = 6, plotOutput("plot_resid")), column(width = 6, plotOutput("qq_norm"))),
                          p("As demonstrated by the plots, the model satisfies the assumptions of normality (QQ plot) 
                            and linearity (Residuals vs Fitted plot) while also meeting the requirements
                            of homoscedasticity and independence."))
)

# Server
server<-function(input,output) {
  
  output$Result<-renderText({
    
    ilikia<-input$Age_val
    afypniseis<-input$AI_val
    neck<-input$Neck_val
    alcoholl<-as.numeric(input$Alcohol_val)
    
    new_data <- data.frame(
      age = ilikia,
      necksize = neck, 
      AI = afypniseis,
      alcohol = factor(alcoholl, levels = c('0', '1'))
    )
    
    rem_prediction <- predict(REM_model1.2, newdata = new_data)
    
    rem_percentage <- round(rem_prediction * 100, 2)
    
    if(rem_percentage<0) {
      rem_percentage<-0
    }
   
    paste(rem_percentage, "%")
    
  })
  output$plotAI <- renderPlotly({
    my_plot <- ggplot(data3, aes(x = AI, y = REM, 
                                 
                                 text = paste("Age:", age, "year old",
                                              "<br>Neck Circumference:", necksize, "cm",
                                              "<br>Alcohol:", alcohol,
                                              "<br>AI:", AI,
                                              "<br>REM:", round(REM * 100, 1), "%"))) +
      geom_point(color = "dodgerblue", size = 2, alpha = 0.8) +         
      geom_smooth(method = "lm", color = "red", se = FALSE) +           
      labs(x = "Awakening Index (AI)", y = "REM (%)") +                  
      theme_minimal()                                                    
    
    ggplotly(my_plot, tooltip = "text")
  })
  
  output$qq_norm<-renderPlot({qqnorm(res1.2,main="Q-Q plot for Residuals",col = "dodgerblue")
  qqline(res1.2)})
  output$plot_resid <- renderPlot({
    plot(REM_model1.2, which = 1, main = "Residuals vs Fitted", col = "dodgerblue")
  })
  
}

# Run the App
shinyApp(ui=ui,server=server)


