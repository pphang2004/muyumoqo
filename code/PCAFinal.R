#Step 1: Open the libraries

install.packages("readxl")

library(readxl)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(FactoMineR)
library(factoextra)
library(psych)
library(writexl)
library(plotly)


#Step 2: Load the spreadsheet

obsidian <- "/Users/patrickphang/Downloads/Sourcing.xlsx"

#Step 3: Export the Geochemical Info to match the Subset

geochemistry <- openxlsx::read.xlsx(obsidian, sheet = "geochemistry")
context      <- openxlsx::read.xlsx(obsidian, sheet = "context")

geochemistry <- geochemistry %>%
  filter(!(File %in% c(3088, 1337)))

#Step 4: Doing the PCA

pca_data <- geochemistry %>%
  dplyr::select(mn_cal, fe_cal, th_cal, rb_cal, sr_cal, zr_cal)

pca_result <- PCA(pca_data, scale.unit = TRUE, graph = FALSE)

#Step 5: Visualize the EIGENVALUES:

eigenvalues <- pca_result$eig
print(eigenvalues)
View(eigenvalues)

#Step 6: Visualize the EIGENVECTORS

eigenvectors <- pca_result$var$coord

eigenvectors_table <- as.data.frame(eigenvectors)

eigenvectors_table <- eigenvectors_table %>%
  mutate(across(everything(), ~ round(.x, 3)))

eigenvectors_table <- tibble::rownames_to_column(eigenvectors_table, 
                                                 var = "Variable")
print(eigenvectors_table)
View(eigenvectors_table)

#Step 7: Rotate for VARIMAX

rotation_result <- principal(pca_data, 
                             nfactors = 5,      # Number of components
                             rotate = "varimax", # Varimax rotation
                             scores = FALSE) # Do not compute scores

rotated_loadings <- as.data.frame(rotation_result$loadings[])

rotated_loadings <- round(rotated_loadings, 5)

View(rotated_loadings)




#Path A: PCA Plot with 2 COMPONENTS

scores <- as.data.frame(pca_result$ind$coord)

scores$Source <- geochemistry$Name

scores$HoverInfo <- paste(
  "Source:", scores$Source, "<br>",
  "ID:", geochemistry$File, "<br>",
  "PC1:", round(scores$Dim.1, 2), "<br>",
  "PC2:", round(scores$Dim.2, 2)
)

p <- ggplot() +
  # 1) Plot the big cloud (Muyumoqo) first, small + transparent
  geom_point(
    data = subset(scores, Source == "Muyumoqo"),
    aes(x = Dim.1, y = Dim.2, color = Source, text = HoverInfo),
    size = 2,
    alpha = 0.75
  ) +
  # 2) Plot the reference sources on top, bigger + opaque + outlined
  geom_point(
    data = subset(scores, Source != "Muyumoqo"),
    aes(x = Dim.1, y = Dim.2, color = Source, text = HoverInfo),
    size = 2,
    alpha = 1,
    stroke = 0.8
  ) +
  labs(
    title = "Obsidian Sources at Muyumoqo",
    x = "PC1",
    y = "PC2",
    color = "Source"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c(
    "Muyumoqo" = "grey",
    "Alca-1"   = "blue",
    "Chivay"   = "orange",
    "Quispisisa" = "purple"
  ))

plotly::ggplotly(p, tooltip = "text")






#Path B: PCA Plot with 3 COMPONENTS

pca_coordinates <- as.data.frame(pca_result$ind$coord)

pca_coordinates$Source <- geochemistry$Name

plot_ly(
  data = pca_coordinates,
  x = ~Dim.1,
  y = ~Dim.2,
  z = ~Dim.3,
  type = "scatter3d",
  mode = "markers",
  color = ~Source,
  colors = c("Alca-1" = "blue",
             "Chivay" = "orange",
             "Quispisisa" = "purple",
             "Muyumoqo" = "grey"),
  marker = list(
    size = ifelse(pca_coordinates$Source == "Alca-1", 2, 6),
    opacity = ifelse(pca_coordinates$Source == "Alca-1", 0.25, 1)
  ),
  text = ~paste(
    "ID:", geochemistry$File, "<br>",
    "Source:", Source, "<br>"
  ),
  hoverinfo = "text"
) %>%
  layout(
    title = "Obsidian Sources at Muyumoqo",
    scene = list(
      xaxis = list(title = "PC1"),
      yaxis = list(title = "PC2"),
      zaxis = list(title = "PC3")
    )
  )



#Path A2: Bivariate Plot with LOADING ARROWS

ggplot() +
  geom_point(data = scores, aes(x = Dim.1, y = Dim.2, color = Source), size = 3, alpha = 0.7) +
  geom_segment(data = eigenvectors_table, 
               aes(x = 0, y = 0, xend = Dim.1, yend = Dim.2), 
               arrow = arrow(length = unit(0.2, "cm")), color = "blue") +
  geom_text(data = eigenvectors_table, 
            aes(x = Dim.1 * 1.2, y = Dim.2 * 1.2, label = Variable), 
            color = "blue", size = 4) +
  labs(
    title = "Obsidian Sources at Muyumoqo",
    x = "PC1",
    y = "PC2",
    color = "Source"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("Muyumoqo" = "grey", "Alca-1" = "orange", 
                                "Chivay" = "green", "Quispisisa" = "purple"))


#Path C: Varimax 3D Plot

rotation_result <- principal(
  pca_data,
  nfactors = 4,      # Number of components (adjust as needed)
  rotate = "varimax", # Varimax rotation
  scores = TRUE       # Compute scores
)

varimax_scores <- as.data.frame(rotation_result$scores)

varimax_scores$Source <- geochemistry$Name
varimax_scores$File <- geochemistry$File

plot_ly(
  data = varimax_scores,
  x = ~RC1,  # Rotated Component 1
  y = ~RC2,  # Rotated Component 2
  z = ~RC3,  # Rotated Component 3
  color = ~Source,
  colors = c("blue", "orange", "grey", "purple"),
  type = "scatter3d",
  mode = "markers",
  text = ~paste(
    "ID:", File, "<br>",
    "Source:", Source, "<br>",
    "RC1:", round(RC1, 2), "<br>",
    "RC2:", round(RC2, 2), "<br>",
    "RC3:", round(RC3, 2)
  ),  # Hover information
  hoverinfo = "text"
) %>%
  layout(
    title = "3D Plot of Varimax-Rotated PCA Scores",
    scene = list(
      xaxis = list(title = "RC1"),
      yaxis = list(title = "RC2"),
      zaxis = list(title = "RC3")
    )
  )

#Path C2: 2D Varimax

ggplot(varimax_scores, aes(x = RC1, y = RC2, color = Source, label = File)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(
    title = "2D Plot of Varimax-Rotated PCA Scores (RC1 vs RC2)",
    x = "Rotated Component 1 (RC1)",
    y = "Rotated Component 2 (RC2)",
    color = "Source"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c("Muyumoqo" = "grey", "Alca-1" = "blue", 
                                "Chivay" = "orange", "Quispisisa" = "purple"))


#Circle:

scores <- as.data.frame(pca_result$ind$coord)
scores$Source <- geochemistry$Name

scores$HoverInfo <- paste(
  "Source:", scores$Source, "<br>",
  "ID:", geochemistry$File, "<br>",
  "PC1:", round(scores$Dim.1, 2), "<br>",
  "PC2:", round(scores$Dim.2, 2)
)

p <- ggplot() +
  # Background cloud: Muyumoqo
  geom_point(
    data = subset(scores, Source == "Muyumoqo"),
    aes(x = Dim.1, y = Dim.2, color = Source, text = HoverInfo),
    size = 2,
    alpha = 0.70
  ) +
  # Reference sources on top
  geom_point(
    data = subset(scores, Source != "Muyumoqo"),
    aes(x = Dim.1, y = Dim.2, color = Source, text = HoverInfo),
    size = 2,
    alpha = 1,
    stroke = 0.8
  ) +
  # 90% confidence ellipse for Alca-1 only
  stat_ellipse(
    data = subset(scores, Source == "Quispisisa"),
    aes(x = Dim.1, y = Dim.2),
    type  = "norm",   # assumes approx multivariate normal
    level = 0.90,
    linetype = "dashed",
    linewidth = 0.7,
    color = "purple"
  ) +
  labs(
    title = "Obsidian Sources at Muyumoqo",
    x = "PC1",
    y = "PC2",
    color = "Source"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  scale_color_manual(values = c(
    "Muyumoqo"   = "grey",
    "Alca-1"     = "blue",
    "Chivay"     = "orange",
    "Quispisisa" = "purple"
  ))

plotly::ggplotly(p, tooltip = "text")

