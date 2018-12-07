
#' Play the RPG in a Shiny App
#' @export
play <- function() {

  library(shiny)
  library(nessy)

  ui <- cartridge(
    title = "rpg",
    subtitle = "a (r)ole playing game",
    tagList(
      container_with_title(
        title = "Start",
        button("new_game", "New Game"),
        button("continue", "Continue")
      ),
      uiOutput("game")
    )
  )

  server <- function(input, output, session) {

    rv <- reactiveValues(log = NULL)

    # Create a character
    observeEvent( input$new_game , {
      output$game <- renderUI({
        container_with_title(
          "Create",
          text_input("name", "Name", placeholder = "who are you?"),
          button("create", "Create")
        )
      })
    })

    # Start game
    observeEvent( input$create , {
      output$game <- renderUI({
        container_with_title(
          "Journal",
          container_with_title(
            "Stats",
            input$name,
            div(heart(), "10 / 10"),
            div(star(), "23")
          ),
          container_with_title(
            "Game",
            balloon("What do you want to do?"),
            button("fight", "Fight"),
            button("rest", "Rest"),
            button("save", "Save & Quit")
          ),
          uiOutput("battle")
        )
      })
    })

    # Battle
    observeEvent( input$fight, {
      output$battle <- renderUI({
        container_with_title(
          "Battle",
          container_with_title(
            "Actions",
            radio_buttons("action", NULL, c("attack", "defend", "item", "run")),
            button("submit", "Submit")
          ),
          container_with_title(
            "Messages",
            HTML(paste(rv$log, collapse = "<br/>"))
          )
        )
      })
    })

    # log battle actions
    observeEvent(input$submit, {
      msg <- dplyr::case_when(
        input$action %in% c("attack", "defend", "run") ~ paste0(input$name, " ", input$action, "s..."),
        input$action == "item" ~ paste(input$name, "uses as item...")
      )
      rv$log <- c(rv$log, msg)
    })
  }

  shinyApp(ui, server)

}
