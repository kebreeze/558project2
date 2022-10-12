rmarkdown::render("NPSAPI.Rmd",
                  output_format = "github_document", 
                    output_options = list(
                    toc = TRUE,
                    toc_float = TRUE,
                    df_print = "paged"),
                  output_file = "README")
