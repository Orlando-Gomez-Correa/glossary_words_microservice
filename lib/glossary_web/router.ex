defmodule GlossaryWeb.Router do
  use GlossaryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", GlossaryWeb do
    pipe_through :api

    get "/search", CategoryController, :search_category

    resources "/categories", CategoryController, except: [:new, :edit] do
      get "/words", WordController, :index

      get "/words/:id", WordController, :show
      post "/words", WordController, :create
      put "/words/update/:id", WordController, :update
      delete "/words/:id", WordController, :delete
      put "/words/upload_image/:id", WordController, :upload_image
      get "/words/image/:image", WordController, :show_image
      get "/words/search", WordController, :search_word
    end
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Words GreenHouse API",
        description: "API Documentation for GreenHouse API v1",
        termsOfService: "Open for public",
        contact: %{
          name: "Orlando Gomez",
          email: "orlando@cordage.io"
        }
      }
    }
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :glossary,
      swagger_file: "swagger.json"
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
