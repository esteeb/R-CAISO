library(ggplot2)
library(ggthemes)

avg_plot <- ggplot(tidy_avg_df, aes(x = variable, y = value, color = Year,
                                    )) + 
  geom_point() + 
  geom_smooth() + 
  scale_color_fivethirtyeight() + 
  theme_fivethirtyeight()

avg_plot