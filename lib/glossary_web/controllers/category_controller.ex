defmodule GlossaryWeb.CategoryController do
  use GlossaryWeb, :controller

  alias Glossary.Words
  alias Glossary.Words.Category
  use PhoenixSwagger

  action_fallback GlossaryWeb.FallbackController

  def swagger_definitions do
    %{
      Category:
        swagger_schema do
          title("Category")
          description("A category of the application")

          properties do
            id(:string, "Category ID")
            name(:string, "Category name", required: true)
            description(:text, "Category description", required: true)
            code(:string, "Category code", required: true)
            inserted_at(:string, "When was the activity initially inserted", format: :datetime)
            updated_at(:string, "When was the activity last updated", format: :datetime)
          end
        end,
      CreateCategoryRequest:
        swagger_schema do
          title("CreateCategoryRequest")
          description("POST body for creating a category")
          property(:category, Schema.ref(:Category), "The category details")

          example(%{
            name: "ISO 9000",
            description:
              "ISO 9000 is a set of quality control and quality management standards established by the International Organization for Standardization. They can be applied in any type of organization or activity oriented to the production of goods or services.",
            code: "AR900"
          })
        end,
      CreateCategoryResponse:
        swagger_schema do
          title("CreateCategoryResponse")
          description("Response schema for single category")
          property(:data, Schema.ref(:Category), "The category details created")

          example(%{
            data: %{
              code: "AR900",
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              name: "Operation",
              words: []
            }
          })
        end,
      CreateCategoryResponseErrors:
        swagger_schema do
          title("CreateCategoryResponseErrors")
          description("Response errors from create category")

          example(%{
            name: "can't be blank",
            description: "can't be blank",
            code: "can't be blank"
          })
        end,
      ShowCategoriesResponse:
        swagger_schema do
          title("ShowCategoriesResponse")
          description("Response schema for multiple categories created")
          property(:categories, Schema.array(:Category), "The categories details")

          example(%{
            first: 1,
            has_next: false,
            has_prev: false,
            last: 2,
            next_page: 2,
            page: 1,
            prev_page: 0,
            total_count: 2,
            categories: [
              %{
                code: "AR900",
                description:
                  "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
                id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
                name: "Operation",
                words: [
                  %{
                    category_id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
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
                    category_id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
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
      ShowCategoriesEmptyResponse:
        swagger_schema do
          title("ShowCategoriesEmptyResponse")
          description("Response error categories empty")

          example(%{
            error: "There are no categories"
          })
        end,
      ShowCategoryResponse:
        swagger_schema do
          title("ShowCategoryResponse")
          description("Response schema of a single category")
          property(:data, Schema.ref(:Category), "The category found")

          example(%{
            data: %{
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
          })
        end,
      UpdateCategoryRequest:
        swagger_schema do
          title("UpdateCategoryRequest")
          description("Request params to update a category")
          property(:data, Schema.array(:Word), "The category params")

          example(%{
            name: "ISO 26000"
          })
        end,
      UpdateCategoryResponse:
        swagger_schema do
          title("UpdateCategoryResponse")
          description("Response schema of a single category")
          property(:data, Schema.array(:Word), "The category updated")

          example(%{
            data: %{
              code: "AR900",
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              name: "Operation",
              words: [
                %{
                  category_id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
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
            }
          })
        end,
      DeleteCategoryRequest:
        swagger_schema do
          title("DeleteCategoryRequest")
          description("Request params to delete a category")
        end,
      DeleteCategoryResponse:
        swagger_schema do
          title("DeleteCategoryResponse")
          description("Response schema of a single category")
          property(:data, Schema.array(:Category), "The category deleted")

          example(%{
            data: %{
              code: "AR900",
              description:
                "The Operation in ISO 9001 2015 Clause 8 of the 2015 revision of the ISO 9001 standard seeks to improve the operational control of your organization's production processes. In short, it asks you to effectively define the criteria and processes for the products and services to be delivered to customers, as well as the documentation and resources to ensure that the products and services you offer are adequate.",
              id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
              name: "Operation",
              words: [
                %{
                  category_id: "e9bd02f8-f81a-4e4b-b67c-86df37b4ff1a",
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

  # ----------

  swagger_path(:index) do
    get("/api/v1/categories?page={page}&page_size={size}")
    summary("All Categories")
    description("Return JSON with all categories listed in the database")
    produces("application/json")
    deprecated(false)

    parameters do
      page(:path, :integer, "Page number to be displayed", required: true, example: 2)

      size(:path, :integer, "Total number of entries per page",
        required: true,
        example: 10
      )
    end

    response(200, "Success", Schema.ref(:ShowCategoriesResponse))
    response(204, "No Categories", Schema.ref(:ShowCategoriesEmptyResponse))
  end

  def index(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1

    categories = Words.list_categories_with_pagination(:paged, page, page_size)

    case categories != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", categories: categories)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no categories"})
    end
  end

  swagger_path :create do
    post("/api/v1/categories")
    summary("Add a new category")
    description("Create a new category in the database")
    consumes("application/json")
    produces("application/json")
    deprecated(false)

    parameter(:word, :body, Schema.ref(:CreateCategoryRequest), "The category data",
      required: true
    )

    response(201, "Created", Schema.ref(:CreateCategoryResponse))
    response(400, "Bad Request", Schema.ref(:CreateCategoryResponseErrors))
  end

  def create(conn, category_params) do
    with {:ok, %Category{} = category} <- Words.create_category(category_params) do
      conn
      |> put_status(:created)
      |> render("show.json", category: category)
    end
  end

  swagger_path(:show) do
    get("/api/v1/categories/{id}")
    summary("Show a specific category")
    description("Return JSON with an especific category")
    produces("application/json")
    deprecated(false)

    parameters do
      id(:path, :string, "Category ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )
    end

    response(200, "Category created OK", Schema.ref(:ShowCategoryResponse))

    response(404, "Not found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}) do
    category = Words.get_category!(id)
    render(conn, "show.json", category: category)
  end

  swagger_path(:update) do
    put("/api/v1/categories/{id}")

    summary("Update a category")
    description("Update all attributes of a category")
    consumes("application/json")
    produces("application/json")

    parameters do
      id(:path, :string, "Category ID",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )

      category(:body, Schema.ref(:UpdateCategoryRequest), "The category details to update",
        required: true
      )
    end

    response(205, "Updated", Schema.ref(:UpdateCategoryResponse))
    response(400, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, category_params) do
    category = Words.get_category!(conn.path_params["id"])

    with {:ok, %Category{} = category} <- Words.update_category(category, category_params) do
      render(conn, "show.json", category: category)
    end
  end

  swagger_path(:delete) do
    PhoenixSwagger.Path.delete("/api/v1/categories/{id}")
    summary("Delete a specific category")
    description("Delete a category by ID")

    parameters do
      id(:path, :string, "The ID of the category",
        required: true,
        example: "1b1716bd-1875-44c4-8c4b-6f969fc5fdbd"
      )
    end

    response(204, "No Content - Deleted Successfully")
  end

  def delete(conn, %{"id" => id}) do
    category = Words.get_category!(id)

    with {:ok, %Category{}} <- Words.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path(:search_category) do
    get("/api/v1/search")
    summary("All categories in the search")
    description("Returns JSON with all categories matching listed in the database")
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

    response(200, "Success", Schema.ref(:ShowCategoriesResponse))
    response(204, "No users", Schema.ref(:ShowCategoriesEmptyResponse))
  end

  def search_category(conn, params) do
    page = params["page"] || 1
    page_size = params["page_size"] || 1
    term = params["name"]
    categories = Words.list_search_categories(:paged, page, page_size, term)

    case categories != [] do
      true ->
        conn
        |> put_status(:ok)
        |> render("index.json", categories: categories)

      false ->
        conn
        |> put_status(200)
        |> json(%{error: "There are no categories"})
    end
  end
end
