# Load necessary libraries
library(dplyr)
library(ggplot2)
library(shadowtext)
library(covid19.analytics)
library(cowplot)

# Fetch data
res <- query()
y <- res$historical
d <- y[["global"]]

# Subset data to the relevant date
time <- as.Date("2021-01-10")
dd <- d %>% 
  filter(date == time) %>% 
  arrange(desc(cases)) %>% 
  head(40)

# Add angle
dd <- dd %>% 
  mutate(angle = 1:40 * 360/40)

# Calculate median
k <- median(dd$cases)

# Create ggplot object
p <- ggplot(dd, aes(country, cases, fill = cases)) + 
  geom_col(width = 1, color = "grey90") + 
  geom_col(aes(y = I(5)), width = 1, fill = "grey90", alpha = 0.2) + 
  geom_col(aes(y = I(3)), width = 1, fill = "grey90", alpha = 0.2) + 
  geom_col(aes(y = I(2)), width = 1, fill = "white") +
  scale_y_log10() + 
  scale_fill_gradientn(colors = c("darkgreen", "green", "orange", "firebrick", "red"), trans = "log") + 
  geom_text(aes(label = paste(country, cases, sep = "\n"), 
                y = cases * 0.8, angle = angle), 
            data = function(d) d[d$cases > k,], 
            size = 2, color = "white", fontface = "bold", vjust = 1) + 
  geom_text(aes(label = paste0(cases, " cases ", country), 
                y = max(cases) * 2, angle = angle + 90), 
            data = function(d) d[d$cases < k,], 
            size = 3, vjust = 0) + 
  coord_polar(direction = -1) + 
  theme_void() + 
  theme(legend.position = "none") +
  ggtitle("COVID19 global trend", time)

# Create second ggplot object
breaks <- c(1000, 10000, 20000, 50000, 500000, 500000, 5000000, 20000000)
p2 <- ggplot(dd, aes(days_since_1m, cases, color = country)) +
  geom_smooth(method = "lm", aes(group = 1), color = "grey10", linetype = "dashed") +
  geom_line(size = 0.8) +
  geom_point(pch = 21, size = 1) +
  scale_y_log10(expand = expansion(add = c(0, 0.1)), breaks = breaks, labels = breaks) +
  scale_x_continuous(expand = expansion(add = c(0, 1))) +
  theme_minimal(base_size = 14) +
  theme(panel.grid.minor = element_blank(),
        legend.position = "none",
        plot.margin = margin(3, 15, 3, 3, "mm")) +
  coord_cartesian(clip = "off") +
  geom_shadowtext(aes(label = paste0(" ", country)), hjust = 0, vjust = 0, 
                  data = . %>% group_by(country) %>% top_n(1, days_since_1m),
                  bg.color = "white") +
  labs(x = "Number of days since 1,000,000th case", y = "", subtitle = "Total number of cases")

# Combine plots
pp <- plot_grid(p, p2, ncol = 2, labels = c("A", "B"), rel_heights = c(0.7, 1))

# Save plot
ggsave(pp, filename = "nCov2019.jpg", width = 12, height = 8)