
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

    rv <- reactiveValues(log = NULL, player = NULL)

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
      rv$player <- Player$new(input$name)
      rv$log <- paste0("Hello ", input$name, ". Welcome to rpg.")
      output$game <- renderUI(uiOutput("gameplay"))
    })

    # Main Gameplay Screen
    output$gameplay <- renderUI({
      container_with_title(
        "Gameplay",
        container_with_title(
          rv$player$name,
          div(heart(), hp()),
          div(star(), rv$player$xp)
        ),
        container_with_title(
          "World Map",
          balloon("What do you want to do?"),
          button("fight", "Fight"),
          button("rest", "Rest"),
          button("save", "Save & Quit")
        ),
        container_with_title(
          "Journal",
          HTML(paste(rv$log, collapse = "<br/>"))
        )
      )
    })

    hp <- eventReactive(rv$log, {
      rv$player$attributes$hp
    })

    # Battle
    output$battle <- renderUI({
      container_with_title(
        "Battle",
        container_with_title(
          "Actions",
          radio_buttons("action", NULL, c("attack", "defend", "item", "run")),
          button("submit", "Submit")
        ),
        container_with_title(
          "Enemy",
          octocat_animate()
        ),
        container_with_title(
          "Journal",
          HTML(paste(rv$log, collapse = "<br/>"))
        )
      )
    })

    # FIGHT (world map) === Load battle screen
    observeEvent( input$fight, {
      rv$player$fight("slime")
      output$game <- renderUI(uiOutput("battle"))
    })

    # REST (world map) == Heal player
    observeEvent( input$rest, {
      rv$player$rest()
      rv$log <- c(rv$log, paste(rv$player$name, "rests."))
    })

    # RUN (battle) === Load gameplay screen (TODO: or defeat monster!!)
    observeEvent( input$submit, {
      if (input$action == "run")
        output$game <- renderUI(uiOutput("gameplay"))
    })


    # Journal -- Log battle actions
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
