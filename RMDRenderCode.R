rmarkdown::render("NPSAPI.Rmd",
                  output_format = "github_document", 
                    output_options = list(
                    toc = TRUE,
                    df_print = "default"),
                  output_file = "README")
