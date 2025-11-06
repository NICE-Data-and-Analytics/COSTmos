library(rmarkdown)
library(rprojroot)

devtools::load_all()

# Render about page
render(find_package_root_file("inst", "about_dashboard.Rmd"),
       output_format = "md_document")
