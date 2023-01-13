defmodule GlossaryWeb.WordController do
  use GlossaryWeb, :controller

  alias Glossary.Words
  alias Glossary.Words.{Word}
  use PhoenixSwagger

  action_fallback GlossaryWeb.FallbackController

  def swagger_definitions do
    %{
      Word:
        swagger_schema do
          title("Word")
          description("A word of the application")

          properties do
            id(:string, "Word ID")
            name(:string, "Word name", required: true)
            description(:text, "Word description", required: true)
            image(:string, "Word image", required: false)
            category_id(:string, "ID of category to which the word belongs", required: true)
            inserted_at(:string, "When was the activity initially inserted", format: :datetime)
            updated_at(:string, "When was the activity last updated", format: :datetime)
          end
        end,
      CreateWordRequest:
        swagger_schema do
          title("CreateWordRequest")
          description("POST body for creating a word")
          property(:word, Schema.ref(:Word), "The word details")

          example(%{
            word: %{
              name: "Operation",
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate."
            }
          })
        end,
      CreateWordResponse:
        swagger_schema do
          title("CreateWordResponse")
          description("Response schema for single word")
          property(:data, Schema.ref(:Word), "The word details created")

          example(%{
            data: %{
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              image: %{
                file_name: "operation.png",
                updated_at: "2022-12-16T15:55:28"
              },
              name: "Operation"
            }
          })
        end,
      CreateWordResponseErrors:
        swagger_schema do
          title("CreateWordResponseErrors")
          description("Response errors from create word")

          example(%{
            name: "can't be blank",
            description: "can't be blank"
          })
        end,
      ShowWordsResponse:
        swagger_schema do
          title("ShowWordsResponse")
          description("Response schema for multiple words created")
          property(:words, Schema.array(:Word), "The words details")

          example(%{
            first: 1,
            has_next: false,
            has_prev: false,
            last: 2,
            next_page: 2,
            page: 1,
            prev_page: 0,
            total_count: 2,
            words: [
              %{
                category_id: "5a10f256-51cd-4e91-844f-13d17a65ad57",
                description:
                  "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
                id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
                image: %{
                  file_name: "operation.png",
                  updated_at: "2022-12-16T15:55:28"
                },
                name: "Operation"
              },
              %{
                category_id: "5a10f256-51cd-4e91-844f-13d17a65ad57",
                description:
                  "For the ISO-9000 standard, quality is the degree to which a set of inherent characteristics meets the requirements, being: Quality characteristic: inherent characteristic of a product, process or system related to a requirement.",
                id: "df48a064-75d5-4be7-a773-7003169277e6",
                image: %{
                  file_name: "quality.png",
                  updated_at: "2022-12-16T15:55:28"
                },
                name: "Quality"
              }
            ]
          })
        end,
      ShowWordsEmptyResponse:
        swagger_schema do
          title("ShowWordsEmptyResponse")
          description("Response error words empty")

          example(%{
            error: "There are no words"
          })
        end,
      ShowWordResponse:
        swagger_schema do
          title("ShowWordResponse")
          description("Response schema of a single word")
          property(:data, Schema.ref(:Word), "The word found")

          example(%{
            data: %{
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              image: %{
                file_name: "operation.png",
                updated_at: "2022-12-16T15:55:28"
              },
              name: "Operation"
            }
          })
        end,
      UpdateWordRequest:
        swagger_schema do
          title("UpdateWordRequest")
          description("Request params to update a word")
          property(:data, Schema.array(:Word), "The word params")

          example(%{
            name: "Authority to dispose of"
          })
        end,
      UpdateWordResponse:
        swagger_schema do
          title("UpdateWordResponse")
          description("Response schema of a single word")
          property(:data, Schema.array(:Word), "The word updated")

          example(%{
            data: %{
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              image: %{
                file_name: "operation.png",
                updated_at: "2022-12-16T15:55:28"
              },
              name: "Authority to dispose of"
            }
          })
        end,
      DeleteWordRequest:
        swagger_schema do
          title("DeleteWordRequest")
          description("Request params to delete a word")
        end,
      DeleteWordResponse:
        swagger_schema do
          title("DeleteWordResponse")
          description("Response schema of a single word")
          property(:data, Schema.array(:Word), "The word deleted")

          example(%{
            data: %{
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              image: %{
                file_name: "operation.png",
                updated_at: "2022-12-16T15:55:28"
              },
              name: "Authority to dispose of"
            }
          })
        end,
      UpdateImageWordRequest:
        swagger_schema do
          title("UpdateImageWordRequest")
          description("Request params to update a word's image")
          property(:data, Schema.array(:Word), "The words params")

          example(%{
            image: "operation.png"
          })
        end,
      UpdateImageWordResponse:
        swagger_schema do
          title("UpdateImageWordResponse")
          description("Response schema of a single word")
          property(:data, Schema.array(:Word), "The word updated")

          example(%{
            data: %{
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              image: %{
                file_name: "operation.png",
                updated_at: "2022-12-16T15:55:28"
              },
              name: "Authority to dispose of"
            }
          })
        end,
      Error:
        swagger_schema do
          title("Errors")
          description("Error responses from the API")

          properties do
            error(:string, "The message of the error raised", required: true)
          end
        end
    }
  end

  # --------------

  swagger_path(:index) do
    get("/api/v1/categories/{category_id}/words?page={page}&page_size={size}")
    summary("All Words")
    description("Return JSON with all words listed in the database")
    produces("application/json")
    deprecated(false)

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      page(:path, :integer, "Page number to be displayed", required: true, example: 2)

      size(:path, :integer, "Total number of entries per page",
        required: true,
        example: 10
      )
    end

    response(200, "Success", Schema.ref(:ShowWordsResponse))
    response(204, "No words", Schema.ref(:ShowWordsEmptyResponse))
  end

  def index(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1
    category_id = params["category_id"]

    words = Words.list_words_with_pagination(:paged, page, page_size, category_id)

    case words != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", words: words)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no words"})
    end
  end

  swagger_path :create do
    post("/api/v1/categories/{category_id}/words")
    summary("Add a new word")
    description("Create a new word in the database")
    consumes("application/json")
    produces("application/json")
    deprecated(false)

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      word(:body, Schema.ref(:CreateWordRequest), "The word data", required: true)
    end

    response(201, "Created", Schema.ref(:CreateWordResponse))
    response(400, "Bad Request", Schema.ref(:CreateWordResponseErrors))
  end

  def create(conn, %{"category_id" => category_id, "word" => word_params}) do
    category = Words.get_category!(category_id)

    with {:ok, %Word{} = word} <- Words.create_word(category, word_params) do
      conn
      |> put_status(:created)
      |> render("show.json", word: word)
    end
  end

  swagger_path(:show) do
    get("/api/v1/categories/{category_id}/words/{id}")
    summary("Show a Specific Word")
    description("Return JSON with an especific word")
    produces("application/json")
    deprecated(false)

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      id(:path, :string, "Word ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )
    end

    response(200, "Word created OK", Schema.ref(:ShowWordResponse))

    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}) do
    word = Words.get_word!(id)
    render(conn, "show.json", word: word)
  end

  swagger_path(:update) do
    put("/api/v1/categories/{category_id}/words/update/{id}")

    summary("Update a word")
    description("Update all attributes of a word")
    consumes("application/json")
    produces("application/json")

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      id(:path, :string, "Word ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      word(:body, Schema.ref(:UpdateWordRequest), "The word details to update", required: true)
    end

    response(205, "Updated", Schema.ref(:UpdateWordResponse))
    response(400, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, word_params) do
    word = Words.get_word!(conn.path_params["id"])

    with {:ok, %Word{} = word} <- Words.update_word(word, word_params) do
      render(conn, "show.json", word: word)
    end
  end

  swagger_path(:delete) do
    PhoenixSwagger.Path.delete("/api/v1/categories/{category_id}/words/update/{id}")
    summary("Delete a specific word")
    description("Delete a word by ID")

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      id(:path, :string, "Word ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )
    end

    response(204, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    word = Words.get_word!(id)

    with {:ok, %Word{}} <- Words.delete_word(word) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path :upload_image do
    put("/api/v1/categories/{category_id}/words/upload_image/{id}")
    summary("Upload image of a word")
    description("Update the word's description picture")
    consumes("multipart/form-data")
    produces("multipart/form-data")

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      id(:path, :string, "Word ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      image(:file, :formData, "Browse File", required: true)
    end

    response(201, "Ok", Schema.ref(:UpdateImageWordRequest))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def upload_image(conn, params) do
    word = Words.get_word!(conn.path_params["id"])

    with {:ok, %Word{} = word} <- Words.update_word_image(word, params) do
      render(conn, "show.json", word: word)
    else
      {:error, _error} ->
        conn
        |> put_status(400)
        |> json(%{error: "Bad Request"})
        |> IO.inspect()
    end
  end

  swagger_path :show_image do
    get("/api/v1/categories/{category_id}/words/image/{image}")
    summary("Show the image of a word")
    description("Show the word's description picture")
    consumes("multipart/form-data")
    produces("multipart/form-data")

    parameters do
      category_id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      id(:path, :string, "Word ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )
    end

    response(201, "Ok", Schema.ref(:UpdateImageWordRequest))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def show_image(conn, %{"image" => image}) do
    file = File.read!("uploads/#{image}")

    conn
    |> put_status(200)
    |> send_resp(:ok, file)
  end

  swagger_path(:search_word) do
    get("/api/v1/categories/{category_id}/words/search?page={page}&page_size={size}&name={name}")
    summary("All Words in the search")
    description("Returns JSON with all words matching listed in the database")
    produces("application/json")
    deprecated(false)

    parameters do
      page(:path, :integer, "Page number to be displayed", required: true, example: 2)

      size(:path, :integer, "Total number of entries per page",
        required: true,
        example: 10
      )

      name(:path, :string, "The field you want to find", required: true)
    end

    response(200, "Success", Schema.ref(:ShowWordsResponse))
    response(204, "No users", Schema.ref(:ShowWordsEmptyResponse))
  end

  def search_word(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1
    category_id = params["category_id"]
    term = params["name"]
    words = Words.list_search_words(:paged, page, page_size, category_id, term)

    case words != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", words: words)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no words"})
    end
  end
end
