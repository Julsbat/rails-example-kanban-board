# README

This is the 'Kanban Board' example app.
See https://backend-development.github.io/rails_view_and_controller.html

=== Study the Models ===

This Application already has two models: boards and cards.
Create the database and load the seed data by running
`rails db:setup`

=== Replace the Homepage === 

Redirect home to the list of kanban boards.

=== dependent models ===

Cards depend on their board and are deleted when the board
is deleted.  Delete a board and study the log file: how are the
cards deleted? Does Rails use referential integrity in the
database?

### Answer

    Started DELETE "/boards/1" for ::1 at 2016-12-21 11:04:32 +0100
    Processing by BoardsController#destroy as HTML
      Parameters: {"authenticity_token"=>"zKgw/3njMZqr/Sdz0/QMFar09uwgdGeuiGttKeTd5KvIRtdGtLQCtratzxf+wAremomYLbvM6n54Fcc0vo5bSg==", "id"=>"1"}
      [1m[36mBoard Load (0.0ms)[0m  [1m[34mSELECT  "boards".* FROM "boards" WHERE "boards"."id" = ? LIMIT ?[0m  [["id", 1], ["LIMIT", 1]]
      [1m[35m (0.0ms)[0m  [1m[36mbegin transaction[0m
      [1m[36mCard Load (0.0ms)[0m  [1m[34mSELECT "cards".* FROM "cards" WHERE "cards"."board_id" = ?[0m  [["board_id", 1]]
      [1m[35mSQL (0.0ms)[0m  [1m[31mDELETE FROM "cards" WHERE "cards"."id" = ?[0m  [["id", 1]]
      [1m[35mSQL (0.0ms)[0m  [1m[31mDELETE FROM "cards" WHERE "cards"."id" = ?[0m  [["id", 2]]
      [1m[35mSQL (0.0ms)[0m  [1m[31mDELETE FROM "boards" WHERE "boards"."id" = ?[0m  [["id", 1]]
      [1m[35m (12.0ms)[0m  [1m[36mcommit transaction[0m
    Redirected to http://localhost:3000/boards
    Completed 302 Found in 152ms (ActiveRecord: 12.0ms)
    
    
    Started GET "/boards" for ::1 at 2016-12-21 11:04:32 +0100
    Processing by BoardsController#index as HTML
      Rendering boards/index.html.erb within layouts/application
      [1m[36mBoard Load (0.0ms)[0m  [1m[34mSELECT "boards".* FROM "boards"[0m
      Rendered boards/index.html.erb within layouts/application (4.0ms)
    Completed 200 OK in 320ms (Views: 252.4ms | ActiveRecord: 0.0ms)
    

Rails allows us to easily set up these implied relationships, but does nothing to help us enforce referential integrity. It’s very simple to accidentally or intentionally break referential integrity in most Rails applications.


=== Nested Ressources === 

Study the URLs, controllers and actions by running `rails 
routes`. Now change `config/routes.rb` to 

    resources :boards do
      resources :cards
    end

How do the URLs change?

### Answer:
#### with:

      Prefix Verb   URI Pattern                                Controller#Action
               root GET    /                                          boards#index
        board_cards GET    /boards/:board_id/cards(.:format)          cards#index
                    POST   /boards/:board_id/cards(.:format)          cards#create
     new_board_card GET    /boards/:board_id/cards/new(.:format)      cards#new
    edit_board_card GET    /boards/:board_id/cards/:id/edit(.:format) cards#edit
         board_card GET    /boards/:board_id/cards/:id(.:format)      cards#show
                    PATCH  /boards/:board_id/cards/:id(.:format)      cards#update
                    PUT    /boards/:board_id/cards/:id(.:format)      cards#update
                    DELETE /boards/:board_id/cards/:id(.:format)      cards#destroy
             boards GET    /boards(.:format)                          boards#index
                    POST   /boards(.:format)                          boards#create
          new_board GET    /boards/new(.:format)                      boards#new
         edit_board GET    /boards/:id/edit(.:format)                 boards#edit
              board GET    /boards/:id(.:format)                      boards#show
                    PATCH  /boards/:id(.:format)                      boards#update
                    PUT    /boards/:id(.:format)                      boards#update
                    DELETE /boards/:id(.:format)                      boards#destroy
    
#### without:

        Prefix Verb   URI Pattern                Controller#Action
          root GET    /                          boards#index
         cards GET    /cards(.:format)           cards#index
               POST   /cards(.:format)           cards#create
      new_card GET    /cards/new(.:format)       cards#new
     edit_card GET    /cards/:id/edit(.:format)  cards#edit
          card GET    /cards/:id(.:format)       cards#show
               PATCH  /cards/:id(.:format)       cards#update
               PUT    /cards/:id(.:format)       cards#update
               DELETE /cards/:id(.:format)       cards#destroy
        boards GET    /boards(.:format)          boards#index
               POST   /boards(.:format)          boards#create
     new_board GET    /boards/new(.:format)      boards#new
    edit_board GET    /boards/:id/edit(.:format) boards#edit
         board GET    /boards/:id(.:format)      boards#show
               PATCH  /boards/:id(.:format)      boards#update
               PUT    /boards/:id(.:format)      boards#update
               DELETE /boards/:id(.:format)      boards#destroy


=== Changes in `cards_controller` ===

Change the card_controller to
always read `params[:board_id]`.  You can use
a `before_action` to do that!

The index-action should
only show cards of this board.  

When creating or updating a card
there should be no input-field for `board_id` in the form,
the `board_id` is already specified by the url.


=== Display the Kanban Board ===

Research what a kanban board shold look like.
Change the show-view of board to look like this.





