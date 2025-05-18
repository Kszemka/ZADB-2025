# config/initializers/swagger_docs.rb
Swagger::Docs::Config.register_apis({
  "1.0" => {
    api_file_path: "public/api-docs",
    base_path:     "http://localhost:3000",
    clean_directory: true,
]    attributes: {
      info: {
        title:       "My Rails API",
        description: "Automatically generated Swagger docs"
      }
    }
  }
})
