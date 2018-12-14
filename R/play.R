
#' Play the RPG in a Shiny App
#' @export
play <- function() {

  library(shiny)
  library(nessy)

  ui <- cartridge(
    title = "rpg",
    subtitle = "a (r)ole playing game",
    tagList(
      uiOutput("menu"),
      uiOutput("game")
    )
  )

  server <- function(input, output, session) {

    rv <- reactiveValues(log = NULL, player = NULL, battle = NULL)

    # UI CREATION --------------------

    # Main Menu UI
    output$menu <- renderUI({
      container_with_title(
        title = "Start",
        button_primary("new_game", "New Game"),
        button_warning("continue", "Continue")
      )
    })

    # Character Creation UI
    output$create <- renderUI({
      container_with_title(
        "Create",
        text_input("name", "Name", placeholder = "who are you?"),
        button("create", "Create")
      )
    })

    # Player Info (Health & Stats & Journal)
    output$hud <- renderUI({
      container_with_title(
        "HUD",
        container_simple(
          strong(rv$player$name),
          div(heart(), rv$player$attributes$hp),
          div(star(), rv$player$xp),
          div(paste("Lvl", rv$player$level, "Warrior"))
        ),
        container_with_title(
          "Bag",
          snes_logo(),
          snes_logo()
        ),
        container_with_title(
          "Journal",
          HTML(paste(tail(journal()), collapse = "<br/>"))
        )
      )
    })

    # Main Gameplay Screen UI
    output$gameplay <- renderUI({
      container_with_title(
        "Gameplay",
        container_with_title(
          "World Map",
          balloon("What do you want to do?"),
          button("fight", "Fight"),
          button("rest", "Rest"),
          button("save", "Save & Quit")
        )
      )
    })

    # Battle UI
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
        )
      )
    })


    # UI LOGIC ---------------------

    # Create a character
    observeEvent( input$new_game , {
      output$menu <- renderUI(uiOutput("create"))
    })

    # Start game
    observeEvent( input$create , {
      rv$player <- Player$new(input$name)
      rv$log <- paste0("Hello ", input$name, ". Welcome to rpg.")
      output$menu <- renderUI(uiOutput("hud"))
      output$game <- renderUI(uiOutput("gameplay"))
    })

    # Fight (world map) === Load battle screen
    observeEvent( input$fight, {
      rv$battle <- rv$player$fight("slime", auto = FALSE)
      output$game <- renderUI(uiOutput("battle"))
    })

    # Rest (world map) == Heal player
    observeEvent( input$rest, {
      rv$player$rest()
      rv$log <- c(rv$log, paste(rv$player$name, "rests."))
    })

    # Attack (battle)
    observeEvent(input$submit, {
      switch(input$action,
        attack = rv$battle$attack(),
        run = rv$battle$run()
        )
      # if the battle is over, return to the main screen
      if (rv$battle$is_over()) {
        rv$player <- rv$battle$player
        output$game <- renderUI(uiOutput("gameplay"))
      }
    })


    # REACTIVES ---------------

    # Journal -- Log battle actions
    journal <- reactive({
      invalidateLater(1000, session)
      rv$player$journal
    })

  }

  shinyApp(ui, server)

}
