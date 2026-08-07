########################################
#                                     #
#         R helper functions          #
#                                     #
#######################################

##############################################################################
# Author: Nathaniel Cole (nc564@cornell.edu)                                 #
# Date:                                                                      #
# License: MIT                                                               #
# Version: 1.0                                                               #
#                                                                            #
# Last updated: 25-04-25                                                       #
##############################################################################

##############################################################################
#  Configuration                                                             #
##############################################################################

options(knitr.duplicate.label = "allow", citation.bibtex.max=999, width = 125, max.print = 100, scipen = 999, digits=3)
set.seed(1234)

suppressPackageStartupMessages(library("grDevices"))
suppressPackageStartupMessages(library("tidyverse"))
suppressPackageStartupMessages(library("ggpubr"))
suppressPackageStartupMessages(library("RColorBrewer"))
suppressPackageStartupMessages(library("kableExtra"))
suppressPackageStartupMessages(library("gtsummary"))

conflicted::conflicts_prefer(dplyr::filter, dplyr::mutate, dplyr::select, base::load, base::attr)

Sys.setenv("DISPLAY"=":0.0")

##############################################################################
#  #start GGplot Settings for theming                                             #
##############################################################################

fontsize <- 14

theme_set(
  theme_classic() +
    theme(
      axis.text.x = element_text(angle = 70, hjust = 1, vjust = 1, size = fontsize, face='bold', color='black'), 
      axis.text.y = element_text(size = fontsize, face='bold', color='black'),
      axis.title.x = element_text(size = fontsize, face='bold', color='black'),
      axis.title.y = element_text(size = fontsize, face='bold', color='black'),
      plot.title = element_text(hjust=0.5,face = "bold", size= 26),
      legend.title= element_blank(),
      legend.position = 'bottom',
      legend.location = "plot",
      legend.text=element_text(size = fontsize, face='bold', color='black'),
      legend.justification= "right",
      strip.text = element_text(size = fontsize, face = 'bold', color = 'black'),
      strip.background.x = element_rect(fill = "white"),
      strip.background.y = element_rect(fill = "lightgrey"),
      plot.margin = margin(2, 2, 2, 2, "cm"),
      plot.caption = element_text(size = (fontsize-3))
      ))

#end
##############################################################################
#  #start gtsummary Theme Settings                                                  #
##############################################################################

set_gtsummary_theme(
  theme_gtsummary_journal("lancet")
)

pvalue_format <- function(x) {
  dplyr::case_when(
      is.na(x) ~ "",
      x < 0.0001 ~ "<0.0001",
      x < 0.001 ~ "<0.001",
      x < 0.01 ~ "<0.01",
      x < 0.05 ~ "<0.05",
      TRUE ~ as.character(round(x, 3))
    ) 
}

#end
##############################################################################
# #start kable Settings                                                             #
##############################################################################

# kable <- function(data, ...){
#   if(!interactive()) {
#   knitr::kable(data) %>%
#   kableExtra::kable_classic(c("striped", "hover", "condensed"), full_width = F, html_font = "Inter")
#   } 
#   else {
#      knitr::kable(data)
#   }

# }

kable <- function(data, ...){
  knitr::kable(data, table.attr = "style = \"color: #C6D0F5;\"")
}

#end

##############################################################################
#  #start Visualisation                                                   #
##############################################################################

#extracts legends from ggplots
extract_legend <- function(my_ggp) {
  step1 <- ggplot_gtable(ggplot_build(my_ggp))
  step2 <- which(sapply(step1$grobs, function(x) x$name) == "guide-box")
  step3 <- step1$grobs[[step2]]
  return(step3)
}

phyla_colours <- c(
  "Actinobacteriota" = '#a6cee3',  
  "Bacteroidota" = '#b2df8a',  
  "Campylobacterota" = '#33a02c',  
  "Bacillota" = '#Fb9a99',  
  "Other" = '#E31a1c',  
  "Pseudomonadota" = '#Fdbf6f',  
  "Unclassified" = '#Ff7f00',  
  "Unknown" = '#ffff99',  
  "Verrucomicrobiota" = '#Cab2d6'
)

pairedColours <-colorRampPalette(brewer.pal(12, "Paired")) #colour-blind friendly
set2 <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928')

trt_labels <- c('0' ="CPM",'1' ="FeZnPM")
time_labels <- c("1Baseline" = "Baseline","2Midpoint" = "Midpoint", "3Endpoint" = "Endpoint")

armColours <- c("#FC8D62","#8DA0CB")
timepoint_colours <- c("#66C2A5","#E78AC3")

#for use with ggplot tile or ggcorrplot
ggheatmap_palette <- c('#91bfdb','#ffffbf','#fc8d59')

okabe_ito <- c(
  "#E69F00", # orange
  "#56B4E9", # sky blue
  "#009E73", # bluish green
  "#F0E442", # yellow
  "#0072B2", # blue
  "#D55E00", # vermillion
  "#CC79A7", # reddish purple
  "#999999"  # grey
)
# Function to assign column classes based on a data dictionary
# To view colour-blind friendly palettes run: display.brewer.all(n=NULL, type="all", select=NULL, exact.n=TRUE, colorblindFriendly=TRUE) 
assign_unique_colors <- function(char_vector, color_vector = NULL, palette = "Set2") {
  if(!require("RColorBrewer", quietly = TRUE))
    install.packages("RColorBrewer")
  library(RColorBrewer)

  unique_levels <- unique(char_vector)
  
  # If color_vector is not provided, create an empty one
  if (is.null(color_vector)) {
    color_vector <- vector("character", length = length(unique_levels))
    #names(color_vector) <- unique_levels
  }
  
  # Find levels without assigned colors
  unassigned_levels <- setdiff(unique_levels, names(color_vector))
  
  # Generate unique colors for unassigned levels
  if (length(unassigned_levels) < 9) {
    new_colors <- brewer.pal(n = length(unassigned_levels), name = palette)
  } else {
    palette <- colorRampPalette(c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928'))
    new_colors <- palette(n = length(unassigned_levels))
  }
  names(new_colors) <- unassigned_levels
  
  #  Update the existing color vector with new colors for previously unseen levels
  for (level in unassigned_levels) {
    color_vector[level] <- new_colors[level]
  }

  # remove any NAs
  color_vector <- color_vector[!is.na(names(color_vector))]

  # Return the updated color vector
  return(color_vector[unique(char_vector)])
}

patterns <- function(params, boundary_df, aspect_ratio, legend = FALSE) {
    args <- as.list(params)
    pattern_type <- as.factor(as.numeric(params$pattern_type))
    
    # Define colorblind-friendly colors
    colors <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928') #brewer.pal(12, "Paired")
    
    # Base parameters for the pattern
    base_args <- list(
        x = boundary_df$x,
        y = boundary_df$y,
        id = boundary_df$id,
        prefix = ""
    )
    
    # Define different patterns for different levels
    if (pattern_type <= 12) {
        # Solid colors for first 12 levels using stripe pattern with 100% density
        args <- c(base_args, list(
            pattern = "stripe",
            pattern_fill = colors[pattern_type],
            pattern_colour = colors[pattern_type],  # Same as fill color
            pattern_spacing = 0.05,
            pattern_density = 1,  # Full density makes it appear solid
            pattern_angle = 0
        ))
    } else if (pattern_type >= 13) {
        # Striped patterns for remaining levels
        args <- c(base_args, list(
            pattern = "stripe",
            pattern_fill = colors[pattern_type],
            pattern_colour = colors[round((pattern_type - 12)/2)],
            pattern_spacing = 0.05,
            pattern_density = 0.7,
        ))
    } else {
        # Dot patterns for remaining levels
        args <- c(base_args, list(
            pattern = "circle",
            pattern_fill = colors[pattern_type],
            pattern_colour = colors[round((pattern_type - 12)/2)],
            pattern_spacing = 0.05,
            pattern_density = 0.7,
        ))
    }
    
    do.call(gridpattern::patternGrob, args)
}

# Register the pattern
options(ggpattern_geometry_funcs = list(patterns = patterns))

#' Create Correlation Panel with Color-Coded Values
#'
#' @description
#' Creates a correlation panel for use in pairs plot, displaying correlation
#' coefficients with color-coded backgrounds. The color intensity represents
#' the strength and direction of correlation.
#'
#' @param x Numeric vector or matrix for correlation calculation
#' @param y Numeric vector or matrix for correlation calculation
#' @param digits Integer. Number of decimal places to display (default: 2)
#' @param prefix Character string to prepend to correlation value (default: "")
#' @param text_size Numeric. Size of correlation text (default: 3)
#' @param color_palette Character vector of length 3 specifying low, mid, and high colors
#' @param na.rm Logical. Whether to remove NA values (default: TRUE)
#' @param method Character. Correlation method: "pearson", "spearman", or "kendall" (default: "pearson")
#' @param ... Additional arguments passed to text()
#'
#' @return Invisibly returns the correlation coefficient
#'
#' @examples
#' \dontrun{
#' pairs(mtcars,
#'       upper.panel = panel.cor,
#'       lower.panel = panel.smooth,
#'       gap = 0,
#'       row1attop = TRUE)
#' }
#'
#' @export
#' @importFrom grDevices colorRampPalette
#' @importFrom stats cor
panel.cor <- function(x, y,
                     digits = 2,
                     prefix = "",
                     text_size = 3,
                     color_palette = c('#91bfdb','#ffffbf','#fc8d59'),
                     na.rm = TRUE,
                     method = "pearson",
                     ...) {
    # Input validation
    if (!is.numeric(x) || !is.numeric(y)) {
        stop("x and y must be numeric vectors or matrices")
    }
    if (!is.numeric(digits) || digits < 0) {
        stop("digits must be a non-negative integer")
    }
    if (!is.character(prefix)) {
        stop("prefix must be a character string")
    }
    if (!method %in% c("pearson", "spearman", "kendall")) {
        stop("method must be one of: 'pearson', 'spearman', 'kendall'")
    }
    if (length(color_palette) != 3) {
        stop("color_palette must be a vector of three colors")
    }

    # Calculate correlation with error handling
    r <- tryCatch({
        cor(x, y, use = if(na.rm) "complete.obs" else "everything",
            method = method)
    }, error = function(e) {
        warning("Could not compute correlation: ", e$message)
        return(NA)
    })

    # Format text
    txt <- if (!is.na(r)) {
        paste0(prefix, format(round(r, digits), nsmall = digits))
    } else {
        "NA"
    }

    # Create color scale
    col <- colorRampPalette(color_palette)(100)
    
    # Map correlation to color index with NA handling
    col.ind <- if (!is.na(r)) {
        round((r + 1) * 49 + 1)
    } else {
        50  # middle color for NA
    }

    # Ensure color index is within bounds
    col.ind <- pmax(1, pmin(100, col.ind))

    # Fill panel with color using usr coordinates
    usr <- par("usr")
    rect(usr[1], usr[3], usr[2], usr[4], col = col[col.ind])

    # Add text with appropriate color
    text_col <- if (is.na(r) || abs(r) <= 0.5) "black" else "white"
    text(mean(usr[1:2]), mean(usr[3:4]), txt, 
         col = text_col,
         cex = text_size)

    # Return correlation coefficient invisibly
    invisible(r)
}

#end
################################################################################
# Plot limma-voom results
################################################################################
plot_limmavoom = function(tt, physeq, alpha = 0.1){
  require("ggplot2")
  require("phyloseq")
  # Rownames of tt are the OTU IDs
  xdf = cbind(tt, tax_table(physeq)[rownames(tt), ])
  xdf$OTU <- rownames(xdf)
  # The points to highlight
  specialdf = xdf[(xdf$P.Value < alpha),]
  # The plot
  p = ggplot(data = xdf,
             mapping = aes(x = logFC, 
                           y = -log10(P.Value),
                           size = -log10(P.Value))) + 
    geom_vline(xintercept = 0.0, linetype = 2) +
    # Background points
    geom_point(color = "black", alpha = 0.65) + 
    scale_size_continuous(range = c(1, 4)) +
    guides(size=FALSE, colour=guide_legend(nrow=2, byrow=TRUE)) +
    # axis labels
    labs(y = expression(-log[10](p)),
         x = expression(log[2](FC)))
  # The interesting OTUs  
  if(nrow(specialdf) > 0){
    p <- p + 
      geom_point(data = specialdf,
                 mapping = aes(color = Genus)) +
      geom_text(data = specialdf,
                mapping = aes(label = paste("OTU:", OTU)),
                size = 2,
                nudge_x = 0.3)
  }
  return(p)
}

##############################################################################
#  #start Functions                                                                #
##############################################################################

#for scaling numeric variables on a 0 to 1 scale
scale_values <- function(x){(x-min(x))/(max(x)-min(x))}

#backtransforms values transformed by scale_values function
backtransform_scaled_values <- function(scaled_value, original_data) {
  original_range <- max(original_data) - min(original_data)
  backtransformed_value <- scaled_value * original_range + min(original_data)
  return(backtransformed_value)
}

#' Calculate Summary Statistics for Numeric Data
#'
#' @description Calculates summary statistics (mean, standard deviation, standard error,
#' median, maximum, and minimum) for numeric data. Works with vectors, matrices, or 
#' data frames, with optional grouping variables.
#'
#' @param data A numeric vector, matrix, or data frame
#' @param varname Character string specifying the variable name to summarize. 
#' If NULL and data is a vector, uses the entire vector.
#' @param groupnames Character vector of column names to group by. 
#' Optional for data frames, ignored for vectors and matrices.
#'
#' @return A data frame containing summary statistics:
#' \itemize{
#'   \item mean
#'   \item sd (standard deviation)
#'   \item SEM (standard error of the mean)
#'   \item median
#'   \item max (maximum value)
#'   \item min (minimum value)
#' }
#'
#' @examples
#' # Vector example
#' vec <- rnorm(100)
#' data_summary(vec)
#'
#' # Data frame example with grouping
#' df <- data.frame(
#'   value = rnorm(100),
#'   group = rep(c("A", "B"), each = 50)
#' )
#' data_summary(df, "value", "group")
#'
#' # Matrix example
#' mat <- matrix(rnorm(100), ncol = 2)
#' data_summary(mat)
#'
#' @importFrom stats sd median
#' @importFrom plyr ddply rename
#' @export
data_summary <- function(data, varname = NULL, groupnames = NULL) {
    # Input validation and conversion
    if (is.vector(data)) {
        if (!is.numeric(data)) stop("Vector must be numeric")
        data <- data.frame(value = data)
        varname <- "value"
    } else if (is.matrix(data)) {
        if (!is.numeric(data)) stop("Matrix must be numeric")
        data <- as.data.frame(data)
        if (is.null(varname)) {
            varname <- colnames(data)[1]
        }
    } else if (!is.data.frame(data)) {
        stop("Input must be a vector, matrix, or data frame")
    }

    # Check if varname exists in data frame
    if (!is.null(varname) && !(varname %in% colnames(data))) {
        stop("Variable name not found in data")
    }

    # Check if groupnames exist in data frame
    if (!is.null(groupnames) && !all(groupnames %in% colnames(data))) {
        stop("One or more grouping variables not found in data")
    }

    # Summary function
    summary_func <- function(x, col) {
        if (all(is.na(x[[col]]))) {
            return(c(n = NA, mean = NA, sd = NA, SEM = NA, 
                    median = NA, max = NA, min = NA))
        }
        c(n = length(x[[col]]),
          mean = mean(x[[col]], na.rm = TRUE),
          sd = sd(x[[col]], na.rm = TRUE),
          SEM = sd(x[[col]], na.rm = TRUE) / 
               sqrt(sum(!is.na(x[[col]]))),
          median = median(x[[col]], na.rm = TRUE),
          max = max(x[[col]], na.rm = TRUE),
          min = min(x[[col]], na.rm = TRUE))
    }

    # Calculate summaries
    if (is.null(groupnames)) {
        # No grouping - calculate overall summary
        data_sum <- as.data.frame(t(summary_func(data, varname)))
    } else {
        # With grouping
        data_sum <- ddply(data, groupnames, .fun = summary_func, varname)
    }

    # Rename mean column if varname provided
    if (!is.null(varname)) {
        data_sum <- rename(data_sum, c("mean" = varname))
    }

    return(data_sum)
}

#' Generate Multiple Random Vectors from Various Distributions
#'
#' @description Creates multiple random vectors using specified distribution functions. 
#' Can generate vectors of equal or varying lengths using different random distributions.
#'
#' @param n_vec Numeric. Number of vectors to generate
#' @param n_obs Numeric vector or single value. If single value, all vectors will have 
#' the same length. If vector, must have length equal to n_vec
#' @param dist Character or function. Distribution to use. Can be "norm" (default), "unif", 
#' "exp", "pois", or a custom random generation function
#' @param params List of parameters for the distribution. For normal distribution: 
#' list(mean = 0, sd = 1), for uniform: list(min = 0, max = 1), etc.
#' @param names Character vector of names for the vectors. If NULL, default names 
#' will be "vec1", "vec2", etc.
#'
#' @return A list of numeric vectors, each containing random values from the specified distribution
#'
#' @examples
#' # Create 3 normal vectors
#' mkvec(n_vec = 3, n_obs = 10, dist = "norm")
#'
#' # Create 3 uniform vectors
#' mkvec(n_vec = 3, n_obs = 10, 
#'                      dist = "unif", 
#'                      params = list(min = 0, max = 10))
#'
#' # Create 2 exponential vectors with different rates
#' mkvec(n_vec = 2, 
#'                      n_obs = c(10, 20), 
#'                      dist = "exp", 
#'                      params = list(rate = c(1, 2)))
#'
#' # Using a custom distribution function
#' custom_dist <- function(n) rbeta(n, 2, 2)
#' mkvec(n_vec = 2, n_obs = 10, dist = custom_dist)
#'
#' @export
mkvec <- function(n_vec, n_obs, dist = "norm", params = list(mean = 0, sd = 1)) {
    # Input validation
    if (!is.numeric(n_vec) || n_vec < 1) {
        stop("n_vec must be a positive number")
    }
    
    # Handle n_obs input - now with recycling
    if (length(n_obs) == 1) {
        n_obs <- rep(n_obs, n_vec)
    } else {
        # Recycle n_obs values if needed
        n_obs <- rep_len(n_obs, n_vec)
    }
    
    # Generate default names
    names <- paste0("vec", 1:n_vec)
    
    # Handle custom function with multiple parameters
    if (is.function(dist)) {
        # Create list of vectors
        result <- vector("list", n_vec)
        
        # Ensure all parameters are properly replicated
        params <- lapply(params, function(p) {
            if (length(p) == 1) {
                rep(p, n_vec)
            } else {
                rep_len(p, n_vec)  # Recycle parameter values if needed
            }
        })
        
        for (i in seq_len(n_vec)) {
            # Extract parameters for this iteration
            current_params <- lapply(params, function(p) p[i])
            
            # Add n parameter
            current_params$n <- n_obs[i]
            
            # Call custom function with parameters
            tryCatch({
                result[[i]] <- do.call(dist, current_params)
                # Convert to matrix to vector if needed
                if (is.matrix(result[[i]])) {
                    result[[i]] <- as.vector(result[[i]])
                }
            }, error = function(e) {
                stop("Error in custom function for vector ", i, ": ", e$message)
            })
        }
    } else if (is.character(dist)) {
        # Handle built-in distributions (code for built-in distributions...)
        stop("Built-in distributions not yet implemented")
    } else {
        stop("dist must be either a character string or a function")
    }
    
    # Assign names to the vectors in the list
    names(result) <- names
    
    return(result)
}

#end
##############################################################################
#  #start LMMs Tools for LMMs                                                       #
##############################################################################

#generate a dataframe with the common goodness of fit metrics from an nlme derived model
model_stats <- function(nlme_model, vif = TRUE, format = "markdown"){
  
  if (class(nlme_model) != "lme") {
    message("Model must be of class 'lme'.")
    stop()
  }

  x <- summary(nlme_model)
  
  mod_df <- data.frame(
    row.names = "Value",
    Bhat = x$coefficients$fixed[1],
    intercept_variance = as.numeric(nlme::VarCorr(x)[,1])[1], #tau
    residual_variance = as.numeric(nlme::VarCorr(x)[,1])[2], #sigma
    total_varaince = as.numeric(nlme::VarCorr(x)[,1])[1] + as.numeric(nlme::VarCorr(x)[,1])[2],
    icc = as.numeric(nlme::VarCorr(x)[,1])[1]/(as.numeric(nlme::VarCorr(x)[,1])[1] + as.numeric(nlme::VarCorr(x)[,1])[2]), #intercalss correlation coefficient
    BIC = x$BIC,
    AIC = x$AIC,
    loglik = x$logLik
  )

  if(vif == TRUE){  
    VIF <- car::vif(nlme_model) #check for multicollineratiy issues
    VIF_Intercept <- NA
    VIF <- c(Intercept = VIF_Intercept, VIF)

    tTable <- as.data.frame(x$tTable)
    tTable$VIF <- VIF
  } else {
      VIF <- car::vif(nlme_model) #check for multicollineratiy issues
      VIF$Intercept <- NA

      tTable <- as.data.frame(x$tTable)
      cbind(tTable, VIF)

    }

  results <- bind_rows(tTable, as.data.frame(t(mod_df)))
  results <- knitr::kable(results, format = format)
  return(results)
}

#plot residuals to test assumption of normal distribution
# ADD Breusch-Pagan test or similar for heteroskedacity test
# use render = FALSE for interactive use
residual_plots <- function(model, model_name = names(model), render = TRUE, chol = TRUE){
  set.seed(1234)
  library(ggplot2)
  library(dplyr)
  library(mgcv)

  if(chol == TRUE){
    rawRes <- residuals(model, type ="pearson")
    estCov <- extract.lme.cov(model, model$data)
  
    # Perform Cholesky decomposition on the residuals' covariance matrix
    message("Cholesky decomposition is being performed on residuals from ", deparse(substitute(model)))
    residuals <- solve(t(chol(estCov))) %*% rawRes
  } else{
    residuals <- residuals(model, type ="pearson")
  }

  xy_plot <- ggplot(data.frame(x = predict(model), y = residuals), aes(x=x, y=y)) +
    geom_point(shape = 1, size = 2, color = "black") +
    #geom_smooth(method = "lm") +
    #ggpubr::stat_cor(position = "dodge") +
    geom_smooth(method = "loess") +
    geom_hline(yintercept = 0, color = "red") +
    xlab("Fitted Values") +
    ylab("Model Residuals") +
    labs(title = paste("Residuals vs Fitted Values")) +
    theme(plot.title = element_text(size=10))

  qqplot <- ggplot(data.frame(resid = residuals), aes(sample = resid)) +
    stat_qq(shape = 1, size = 2, color = "black") +
    stat_qq_line(color = "red") +
    labs(title = paste("QQ Plot")) +
    ylab(NULL) +
    xlab(NULL) +
    theme(plot.title = element_text(size=10))
  
  #create histogram and overlay normal curve
  hist_data <- hist(residuals, plot = FALSE)
  data <- data.frame(x = residuals)

  hist <- ggplot(data, aes(x=x)) +
    geom_histogram(aes(y = after_stat(density)),binwidth = hist_data$breaks[2] - hist_data$breaks[1], fill = "lightblue", color = "black", boundary = 0.5) +
    stat_function(fun = dnorm, args = list(mean = mean(data$x), sd = sd(data$x)), color = "red", size = 1) +
    ylab("Frequency") +
    xlab("Model residuals")+
    labs(title = paste("Residuals Histogram")) +
    theme(plot.title = element_text(size=10))


  norm_test1 <- capture.output(shapiro.test(residuals))
  norm <- ggplot(data.frame(x=0:1, y=0:1), aes(x=x, y=y)) +
    geom_blank() +
    xlab(NULL) +
    ylab(NULL) +
    theme(axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    axis.line = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank()) +
    annotate(geom = "text", x = 0.75, y = 0.20, label = paste("Summary Output:\n", paste(norm_test1, collapse = "\n"), "P-value <0.05", "\n => NOT normally distributed"), hjust = 1, vjust = 0, size = 4)

  # Create a list of plots
  if(render == FALSE){
  X11(display = "", title = model_name)
  }

  plots <- gridExtra::grid.arrange(xy_plot, qqplot, hist,norm, ncol = 2, nrow = 2)

  return(plots)
}

residual_norm_test <- function(model_list) {
  norm_test <- lapply(names(model_list), function(model_name) {
    model <- model_list[[model_name]]
    st <- shapiro.test(residuals(model))
    data.frame(Model = model_name, W = st$statistic, P_value = st$p.value)
  })
  norm_df <- do.call(rbind, norm_test)
  return(norm_df)
}

vda <- function(data, variable, by, ...) {
  # Compute VD.A
  A <- effsize::VD.A(as.formula(glue::glue("`{variable}` ~ {by}")), data = data)
  tibble(vda_estimate  = A$estimate, vda_magnitude = A$magnitude)
}

sturges_bins <- function(data) {
  n <- length(data)
  k <- ceiling(log2(n) + 1)
  return(k)
}

#' Test for Normality of Data Frame Columns
#'
#' @description Performs Shapiro-Wilk normality test on a specified numeric column
#' of a data frame and returns formatted results suitable for Quarto/RMarkdown documents.
#'
#' @param df A data frame containing the data to test
#' @param j Column name or index to test for normality
#' @param format Output format for the table. One of "auto", "pipe", "simple",
#' "html", "latex", or "rst" (default: "auto")
#' @param digits Number of decimal places for p-value (default: 4)
#' @param alpha Significance level for normality test (default: 0.05)
#'
#' @return A formatted kable object containing test results. The table includes:
#' \itemize{
#'   \item Name: Name of the tested variable
#'   \item W: Shapiro-Wilk test statistic
#'   \item P_value: P-value of the test
#' }
#'
#' @details
#' The function performs a Shapiro-Wilk test for normality on the specified column.
#' Results are formatted using kable() for clean output in RMarkdown/Quarto documents.
#' The null hypothesis is that the data is normally distributed.
#'
#' @note
#' The Shapiro-Wilk test is most appropriate for sample sizes between 3 and 5000.
#'
#' @examples
#' # Create example data
#' df <- data.frame(
#'   normal = rnorm(100),
#'   uniform = runif(100),
#'   categorical = factor(rep(1:4, 25))
#' )
#'
#' # Test normally distributed data
#' norm_test(df, "normal")
#'
#' # Test non-normal data
#' norm_test(df, "uniform")
#'
#' # Test with different format
#' norm_test(df, "normal", format = "html")
#'
#' @importFrom stats shapiro.test
#' @importFrom knitr kable
#' @export
norm_test <- function(df, j, format, digits = 4, alpha = 0.05) {
    # Input validation
    if (!is.data.frame(df)) {
        stop("First argument must be a data frame")
    }

    if (is.character(j) && !(j %in% names(df))) {
        stop("Column '", j, "' not found in data frame")
    }

    if (is.numeric(j) && (j < 1 || j > ncol(df))) {
        stop("Column index out of bounds")
    }

    # Extract column
    y <- df[[j]]
    col_name <- if(is.character(j)) j else names(df)[j]

    # Check if numeric
    if (!is.numeric(y)) {
        warning("Column '", col_name, "' is not numeric. Skipping test.")
        return(NULL)
    }

    # Check sample size
    if (length(y) < 3 || length(y) > 5000) {
        warning("Sample size (", length(y), ") is outside recommended range (3-5000) for Shapiro-Wilk test")
    }

    # Remove NA values
    y <- na.omit(y)
    if (length(y) == 0) {
        warning("No non-missing values in column '", col_name, "'")
        return(NULL)
    }

    # Perform test
    norm_test <- shapiro.test(y)

    # Create results data frame
    norm_stats <- data.frame(
        "Variable" = col_name,
        "n" = length(y),
        "W" = norm_test$statistic,
        "P_value" = round(norm_test$p.value, digits),
        "Distribution" = ifelse(norm_test$p.value > alpha,
                              "Likely Normal",
                              "Likely Non-normal"),
        check.names = FALSE
    )

    # Create caption
    caption <- sprintf(
        "Shapiro-Wilk Normality Test Results (α = %.2f)",
        alpha
    )

    # Format table
    table <- knitr::kable(norm_stats,
        format = format,
        caption = caption,
        align = c('l', 'r', 'r', 'r', 'l'),
        booktabs = TRUE,
        digits = digits
    )

    # Add styling if format is latex and kableExtra is available
    if (format == "latex") {
        if (requireNamespace("kableExtra", quietly = TRUE)) {
            table <- kableExtra::kable_styling(table,
                bootstrap_options = c("striped", "hover"),
                full_width = FALSE
            )
        }
    }

    return(table)
}

#' Print method for norm_test output
#' @param x Output from norm_test function
#' @param ... Additional arguments passed to print
#' @export
print.norm_test <- function(x, ...) {
    print(x, ...)
}

cor.mtest <- function(mat, ...) {
    mat <- as.matrix(mat)
    n <- ncol(mat)
    p.mat<- matrix(NA, n, n)
    diag(p.mat) <- 0
    for (i in 1:(n - 1)) {
        for (j in (i + 1):n) {
            tmp <- cor.test(mat[, i], mat[, j], ...)
            p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
        }
    }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  round(p.mat, 4)
}

#' Summarize Variables for Linear Mixed Model Terms
#'
#' @description
#' Creates a summary table of variables intended for use in linear mixed models,
#' including basic characteristics and summary statistics for both numeric and
#' categorical variables.
#'
#' @param variables A list of variables to be summarized
#' @param variable_names A character vector of names corresponding to the variables
#'
#' @return A kable-formatted table containing:
#' \itemize{
#'   \item Variable: Name of the variable
#'   \item Type: Class of the variable
#'   \item N: Number of observations
#'   \item Missing: Number of missing values
#'   \item Unique values: Number of unique values
#'   \item Levels: Number of levels (for factors)
#'   \item Summary Stats: For numeric variables: mean, SD, and range.
#'                       For non-numeric variables: "NA"
#' }
#'
#' @details
#' The function processes both numeric and categorical variables differently:
#' * Numeric variables include summary statistics (mean, SD, range)
#' * Categorical variables show number of levels but no summary statistics
#' All results are formatted using knitr::kable for nice printing
#'
#' @examples
#' variables <- list(
#'   age = c(25, 30, 35),
#'   group = factor(c("A", "B", "A")),
#'   time = c(1, 2, 3)
#' )
#' var_names <- c("age", "group", "time")
#' summarise_terms(variables, var_names)
#' 
#' @aliases summarize_terms
#' @export
#'
#' @import knitr
#'
#' @seealso
#' \code{\link[knitr]{kable}} for the table formatting
#'
#' @note
#' Ensures consistent formatting across variable types and handles missing values
summarise_terms <- function(variables, variable_names) {
  # Input validation
  if(length(variables) != length(variable_names)) {
    stop("Number of variables must match number of variable names")
  }
  if(!is.list(variables)) {
    stop("variables must be a list")
  }
  if(!is.character(variable_names)) {
    stop("variable_names must be a character vector")
  }

  # Initialize empty data frame
  summaries <- data.frame()
  
  for(i in seq_along(variables)) {
    var <- variables[[i]]
    name <- variable_names[i]
    
    # Basic info for all variables
    summary <- data.frame(
      Variable = name,
      Type = class(var)[1],
      N = length(var),
      Missing = sum(is.na(var)),
      `Unique values` = length(unique(var)),
      Levels = length(levels(var))
    )
    
    # Add type-specific summaries
    if(is.numeric(var)) {
      summary$`Summary Stats` <- paste0(
        "Mean=", round(mean(var, na.rm = TRUE), 2),
        ", SD=", round(sd(var, na.rm = TRUE), 2),
        ", Range=[", round(min(var, na.rm = TRUE), 2),
        "-", round(max(var, na.rm = TRUE), 2), "]"
      )
    } else {
      summary$`Summary Stats` <- "NA"
    }
    
    # Bind to main results
    summaries <- rbind(summaries, summary)
  }
  
  return(knitr::kable(summaries, digits = 2))
}

anova_pvalue <- function(x){
  UseMethod("anova_pvalue", x)
}
anova_pvalue.default <- function(x){
  terms <- rownames(x)
  # Extract the p-value column from the data frame
  pvals <- x$`p-value`
  # Combine the p-values and terms into a temporary data frame
  data.frame(Terms = terms, Model = model, P.value = pvals)
}
anova_pvalue.list <- function(x){
  # Initialize an empty data frame to store results
  combined_results <- data.frame()

  pvalues <- lapply(seq_along(x), function(i){
    # Get p-values and terms for each model in the current list
    terms <- rownames(x[[i]])
    # Extract the p-value column from the data frame
    pvals <- x[[i]]$`p-value`
    model <- names(x)[i]
    # Combine the p-values and terms into a temporary data frame
    data.frame(Terms = terms, Model = model, P.value = pvals)
  })
  # Bind the temporary data frame to the combined results data frame
  combined_results <- dplyr::bind_rows(combined_results, pvalues)
  rownames(combined_results) <- NULL
  
  # Return the combined results data frame
  return(combined_results)
}
anova_pvalue.listoflists <- function(x) {
  # Initialize an empty data frame to store results
  combined_results <- data.frame()

  for (l in x) {
      # Get p-values and terms for each model in the current list
    pvalues <- lapply(seq_along(l), function(i) {
      terms <- rownames(l[[i]])
      # Extract the p-value column from the data frame
      pvals <- l[[i]]$`p-value`
      model <- names(l)[i]
      # Combine the p-values and terms into a temporary data frame
      data.frame(Terms = terms, Model = model, P.value = pvals)

        })
    # Bind the temporary data frame to the combined results data frame
    combined_results <- dplyr::bind_rows(combined_results, pvalues)
    rownames(combined_results) <- NULL
  }

 # Return the combined results data frame
  return(combined_results)
}

het_breuschpagan_lme <- function(nlme_model, exog_het, robust = TRUE) {
  # Extract residuals and predicted values from the LME model
  resid <- residuals(nlme_model, type = "pearson")
  y <- resid^2
  if (!robust) {
    y <- y / mean(y)
  }
  
  # Convert exog_het to a matrix
  exog_het <- as.matrix(exog_het)
  
  # Fit a linear model using OLS
  lm_fit <- lm(y ~ exog_het - 1)  # -1 removes intercept
  
  # Calculate test statistics
  lm <- if (robust) {
    nobs(lm_fit) * summary(lm_fit)$r.squared
  } else {
    summary(lm_fit)$sigma / 2
  }
  
  # Calculate p-value
  lm_pval <- 1 - pchisq(lm, length(exog_het) - 1)
  
  # Return the result as a list
  result <- list(
    lm = lm,
    lm_pvalue = lm_pval,
    fvalue = summary(lm_fit)$fstatistic[1],
    f_pvalue = summary(lm_fit)$fstatistic[2]
  )
  
  return(result)
}

# Function to check and apply transformation
check_and_transform <- function(var) {
 
  # Example: Check skewness and apply log-transformation if needed
  if (shapiro.test(var)$p.value < 0.05) {
    var <- log(var)
    cat("Log-transformation applied to", response_var, "\n")
  }
  
  # Return the modified data
  return(data)
}

#' Transform Variable to Achieve Linear Relationships
#'
#' @description
#' Attempts to find a transformation that improves linear relationships between
#' an outcome variable and predictor variables using correlation analysis.
#'
#' @param df Data frame containing variables
#' @param y Character, name of outcome variable
#' @param cor.threshold Numeric, minimum acceptable correlation coefficient
#' @param method Character, correlation method ("pearson", "spearman", "kendall"). Default: "pearson"
#' @param use Character, handling of missing values in correlation
#'
#' @return List containing transformed data frame and transformation details
#' 
#' @examples 
#' \dontrun{
#' result <- straighten(df, "outcome_variable", cor.threshold = 0.3)
#' print(result$transformation)
#' print(result$correlations)
#' transformed_df <- result$data
#' }
#' 
#' @export
straighten <- function(df, y, cor.threshold = 0.2, 
                      method = "pearson", 
                      use = "pairwise.complete.obs") {
    
    # Input validation
    if (!is.data.frame(df)) stop("df must be a data frame")
    if (!y %in% names(df)) stop("y must be a column name in df")
    if (!is.numeric(df[[y]])) stop("y must be numeric")
    if (any(df[[y]] <= 0)) warning("y contains non-positive values, some transformations may fail")
    
    # Define transformations to try
    transforms <- list(
        original = function(x) x,
        log = function(x) log(x),
        sqrt = function(x) sqrt(x),
        square = function(x) x^2,
        cube = function(x) x^3,
        inverse = function(x) 1/x,
        boxcox = function(x) {
            if(requireNamespace("MASS", quietly = TRUE)) {
                bc <- MASS::boxcox(lm(x ~ 1), plotit = FALSE)
                lambda <- bc$x[which.max(bc$y)]
                if(abs(lambda) < 0.001) log(x) else (x^lambda - 1)/lambda
            } else x
        }
    )
    
    # Function to check correlations
    check_correlations <- function(transformed_y) {
        # Handle transformation errors
        if(any(is.na(transformed_y)) || any(is.infinite(transformed_y))) {
            return(FALSE)
        }
        
        # Create temporary df with transformed y
        temp_df <- df
        temp_df[[y]] <- transformed_y
        
        # Calculate correlations
        cors <- cor(temp_df[[y]], 
                   df[setdiff(names(df), y)], 
                   method = method, 
                   use = use)
        
        # Check if any correlation exceeds threshold
        any(abs(cors) >= cor.threshold)
    }
    
    # Try each transformation
    results <- list()
    for(transform_name in names(transforms)) {
        tryCatch({
            transformed_y <- transforms[[transform_name]](df[[y]])
            if(check_correlations(transformed_y)) {
                # Store successful transformation
                transformed_df <- df
                transformed_df[[y]] <- transformed_y
                results[[transform_name]] <- list(
                    data = transformed_df,
                    transformation = transform_name,
                    correlations = cor(transformed_df[[y]], 
                                     df[setdiff(names(df), y)],
                                     method = method,
                                     use = use)
                )
            }
        }, error = function(e) {
            warning(paste("Transformation", transform_name, "failed:", e$message))
        })
    }
    
    # If no transformations worked
    if(length(results) == 0) {
        warning("No transformation achieved the desired correlation threshold")
        return(list(
            data = df,
            transformation = "none",
            correlations = cor(df[[y]], 
                             df[setdiff(names(df), y)],
                             method = method,
                             use = use)
        ))
    }
    
    # Find best transformation (highest max correlation)
    best_transform <- names(results)[which.max(sapply(results, function(x) 
        max(abs(x$correlations))))]
    
    return(results[[best_transform]])
}

#end

pad_columns <- function(df) {
  # Determine the maximum length among all columns
  max_length <- max(sapply(df, length))
  
  # Pad each column with NA values
  padded_df <- lapply(df, function(x) {
    if(length(x) < max_length) {
      c(x, rep(NA, max_length - length(x)))
    } else {
      x
    }
  })
  
  # Convert the result back to a data frame
  padded_df <- as.data.frame(padded_df)
  
  return(padded_df)
}

#determine what fold change a coefficient estimates
fc <- function(coef, log_scale = 2){coef^2}
#determine the coefficient threshold for a particular fold change of interest
coef <- function(desired_fold_change, log_scale = 2){log(desired_fold_change, base = log_scale)}

##############################################################################
#  #start Wrangling functions for data manipulation                         #
##############################################################################

loadcombine <- function(file_dir, file_pattern, header = TRUE, sep, skip = 0, output){
  # Usage

  #loadcombine(file_dir = "C:/Users/Admin/OneDrive - University of Aberdeen (1)/Experiments/Sequencing/Transcriptomics/Nate-transcriptome_analysis/results/exploratory_MoA/GO/REVIGO_tiny/", file_pattern = "*.tsv", sep = "\t", output = "C:/Users/Admin/OneDrive - University of Aberdeen (1)/Experiments/Sequencing/Transcriptomics/Nate-transcriptome_analysis/results/exploratory_MoA/GO/REVIGO_tiny/REVIGO_results_combined.csv", header = T)  

  currentDir <- getwd()
  setwd(file_dir)

  #create var with files paths as a character vector
  all_file_paths <- list.files(path = file_dir, pattern = file_pattern, full.names = TRUE)

  #load all the files into the environment
  all_files <- lapply(all_file_paths, read.table, header = header, sep = sep, skip = skip)

  all_filenames <- 
    all_file_paths %>%
    basename() %>% #basename removes the path from the file name
    as.list() #turns them into a list

  #combines the file content list and file name list i.e. matches the names and the files
  all_lists <- mapply(c, all_files, all_filenames, SIMPLIFY = FALSE)

  all_result <- rbindlist(all_lists, fill = TRUE)
  names(all_result)[length(all_result)] <- "sample"
  #BUG all_result <- all_result[ ,colSums(is.na(all_result))<=ncol(all_result)]
  #export results file
  write.csv(all_result, file = output, row.names = FALSE)
  setwd(currentDir)
}

save_plot <- function(plot, filename) {
svg(filename = paste0(filename, ".svg"))
print(plot)
dev.off()
png(filename = paste0(filename, ".png"))
print(plot)
dev.off()
}

# Function to assign column classes based on a data dictionary
assign_col_classes <- function(data, data_dict_path, variable_name = "Variable.Name", classCol = "colClass.R") {
  # Read the data dictionary
  data_dict <- read.csv(data_dict_path, stringsAsFactors = FALSE)
  
  # Read the first row of the data dictionary to get the variable names
  variables <- data_dict[[variable_name]]
  
  # Read the first row of the data dictionary to get the classes
  classes <- data_dict[[classCol]]
  
  if(is.object(data) == FALSE) {
    data <- read.csv(data, header = TRUE)
  }

  # Match variable names to column names in the data dictionary
    col_classes <- sapply(colnames(data), function(var_name) {
      class_index <- match(var_name, variables)
        if (!is.na(class_index)) {
          return(classes[class_index])
        } 
    })


  # Loop through columns and assign classes
  for(i in seq_along(col_classes)){
    tryCatch(
      {if(is.null(col_classes[[i]])){
              data[[i]] <- type.convert(data[[i]], as.is =TRUE)
            } else {
                if(col_classes[[i]] =="factor"){
                  data[[i]] <- as.factor(data[[i]])
                } else {
                    class(data[[i]]) <- col_classes[[i]]
                  }
              }},
      error = function(e) {
        cat("Error assigning class to column:", names(data)[i], "\n")
        cat("Error message:", conditionMessage(e), "\n")
      }
    )
  }  

  return(data)
}
# Function to assign column classes based on a data dictionary
assign_col_classes <- function(data, data_dict_path, variable_name = "Variable.Name", classCol = "colClass.R") {
  # Read the data dictionary
  data_dict <- read.csv(data_dict_path, stringsAsFactors = FALSE)
  
  # Read the first row of the data dictionary to get the variable names
  variables <- data_dict[[variable_name]]
  
  # Read the first row of the data dictionary to get the classes
  classes <- data_dict[[classCol]]
  
  if(is.object(data) == FALSE) {
    data <- read.csv(data, header = TRUE)
  }

  # Match variable names to column names in the data dictionary
    col_classes <- sapply(colnames(data), function(var_name) {
      class_index <- match(var_name, variables)
        if (!is.na(class_index)) {
          return(classes[class_index])
        } 
    })


  # Loop through columns and assign classes
  for(i in seq_along(col_classes)){
    tryCatch(
      {if(is.null(col_classes[[i]])){
              data[[i]] <- type.convert(data[[i]], as.is =TRUE)
            } else {
                if(col_classes[[i]] =="factor"){
                  data[[i]] <- as.factor(data[[i]])
                } else {
                    class(data[[i]]) <- col_classes[[i]]
                  }
              }},
      error = function(e) {
        cat("Error assigning class to column:", names(data)[i], "\n")
        cat("Error message:", conditionMessage(e), "\n")
      }
    )
  }  

  return(data)
}

#' @title Utilities For \code{\link{phyloseq-class}} Slots to Data Frames

#' @description Utility to convert phyloseq slots to data frames.

#' @details These functions are a fork of \code{tibble_utilities} from the [\code{microbiome} package](https://github.com/microbiome/microbiome/blob/master/R/tibble_utilities.R). Instead of converting to tibbles, these functions instead convert to data frame format, thus retaining rownames instead of adding the rowname as a new column.
#'
#' Convert different \code{phyloseq} slots into data frames.
#' \code{otu_tibble} gets the otu_table in data frame format. 
#' \code{tax_tibble} gets the taxa_table in data frame format. 
#' \code{combine_otu_tax} combines otu_table and taxa_table into one data frame.
#' \code{sample_df} is effectively the same as \code{microbime::meta()}, and extracts the sample metadata as a data.frame.

#' @param x \code{\link{phyloseq-class}} object.
#' @param column.id Provide name for the column which will hold the rownames. 
#'                  of slot.
#' @return A \code{data frame}
#' @examples
#' library(promicrobialTools)
#' data("dietswap")
#' otu_tib <- otu_tibble(dietswap,column.id="FeatureID")
#' tax_tib <- tax_tibble(dietswap,column.id="FeatureID")
#' sample_tib <- sample_tibble(dietswap,column.id="SampleID")
#' otu_tax <- combine_otu_tax(dietswap,column.id = "FeatureID")
#' head(otu_tax)
#' 
#' @name DfUtilites
#' @author Contact: Nathaniel Cole \email{nc564@cornell.edu}
#' @seealso To convert OTU tables to abundacne matrices see \code{microbiome::abundances}. To extract 
NULL

#' @rdname DfUtilites
#' @aliases otu_df
#' @export
otu_df <- function(x){
    
    if (any(c("phyloseq", "otu_table") %in% is(x))) {
        
        # Pick OTU matrix
        otu <- microbiome::abundances(x)
    }
    otu_df <- otu %>%  
        as.data.frame()
    return(otu_df)
}


#' @rdname DfUtilites
#' @aliases tax_df
#' @export
tax_df <- function(x, column.id="FeatureID"){
    
    if (any(c("phyloseq", "tax_table") %in% is(x))) {
        
        # Pick OTU matrix
        tax <- phyloseq::tax_table(x)
    tax_df <- tax %>%  
        as.matrix() %>% 
        as.data.frame()
    return(tax_df)
    } else {
      return(message("tax_table not found"))
    }
}

#' @rdname DfUtilites
#' @aliases sample_df
#' @export
sample_df <- function(x, column.id="SampleID"){
    
    if (any(c("phyloseq", "sample_data") %in% is(x))) {
        
        # Pick OTU matrix
        smd <- microbiome::meta(x)
    }
    return(sample_tibble)
}

#' @rdname TibbleUtilites
#' @aliases combine_otu_tax
#' @export
combine_otu_tax <- function(x, column.id = "FeatureID"){
    otu_tb <- tax_tb <- NULL
    otu_tb <- otu_df(x, column.id) 
    tax_tb <- tax_df(x, column.id)
    otu_tb <- tax_tb %>% 
        dplyr::left_join(otu_tb, by=column.id)
    return(otu_tb)
}

#start check_metadata function

#' Check Metadata Variable Properties
#'
#' @description
#' Checks and reports the class, number of NA values, and length of a metadata variable.
#' This function is designed to validate variables used in microbiome analyses,
#' ensuring they meet expected specifications.
#'
#' @param var The variable to check (vector)
#' @param expected_class Character string specifying the expected class of the variable
#' @param name Character string specifying the name of the variable for reporting
#'
#' @return Prints a summary of the variable's properties:
#'   \itemize{
#'     \item Class (actual and expected)
#'     \item Number of NA values
#'     \item Length of variable
#'   }
#'
#' @examples
#' subject <- c("A1", "A2", "A3")
#' check_metadata(subject, "character", "subject")
#'
#' age <- c(25, 30, NA, 40)
#' check_metadata(age, "numeric", "age")
#'
#' group <- factor(c("Control", "Treatment"))
#' check_metadata(group, "factor", "group")
#'
#' @seealso
#' \code{\link{class}}, \code{\link{is.na}}
#'
#' @export
#'
#' @note
#' This function is particularly useful for checking metadata variables
#' before conducting microbiome analyses where complete cases and 
#' correct variable types are crucial.
#'
#' @author Nathaniel Cole
#' @version 1.0.0
check_metadata <- function(var) {
    cat("Checking:", deparse(substitute(var)), "\n")
    cat("Class:", class(var), "\n")
    cat("NAs:", sum(is.na(var)), "\n")
    cat("Length:", length(var), "\n")
    cat("-------------------\n")
}

#end

#' Create a Formatted Table from Multiple Results Objects
#'
#' @description
#' Combines multiple results objects into a single formatted table.
#' Compatible with emmeans, data.frames, matrices, and other objects that can be
#' coerced to data.frames. Provides flexible formatting options and is compatible
#' with knitr/quarto rendering.
#'
#' @param results_list List of objects to combine. Names of list elements used as identifiers.
#' @param id_col Character. Name for the identifier column (default: "Model")
#' @param digits Integer. Number of decimal places for numeric columns (default: 2)
#' @param format Character. Output format: "markdown", "html", or "latex" (default: "markdown")
#' @param caption Character. Optional table caption
#' @param col.names Character vector. Custom column names
#' @param round_cols Character vector. Columns to round (default: all numeric)
#' @param align Character vector. Column alignment (default: auto-detect)
#' @param table_style Character vector. kableExtra styling options
#'
#' @return A knitr_kable object that can be directly used in R Markdown or Quarto
#'
#' @examples
#' \dontrun{
#' # With emmeans objects
#' results1 <- list(
#'   "Model 1" = emmeans(model1, ~treatment),
#'   "Model 2" = emmeans(model2, ~treatment)
#' )
#'
#' # With data frames
#' results2 <- list(
#'   "Analysis 1" = data.frame(x = 1:3, y = 4:6),
#'   "Analysis 2" = data.frame(x = 7:9, y = 10:12)
#' )
#'
#' # Create tables
#' table1 <- table_bind(
#'   results1,
#'   caption = "EMM Comparison",
#'   table_style = c("striped", "hover")
#' )
#'
#' table2 <- table_bind(
#'   results2,
#'   id_col = "Analysis",
#'   align = c('l', 'r', 'r')
#' )
#' }
#'
#' @export
#' @importFrom knitr kable
#' @importFrom kableExtra kable_styling
table_bind <- function(results_list, 
                      id_col = "Model",
                      digits = 2, 
                      format = c("markdown", "html", "latex"),
                      caption = NULL,
                      col.names = NULL,
                      round_cols = NULL,
                      align = NULL,
                      table_style = NULL) {
    
    # Input validation
    if (!is.list(results_list)) {
        stop("Input must be a list of results objects")
    }
    
    if (length(results_list) == 0) {
        stop("Empty list provided")
    }
    
    # Match format argument
    format <- match.arg(format)
    
    # Convert each object to data frame
    df_list <- lapply(results_list, function(x) {
        tryCatch({
            # Handle different object types
            if (inherits(x, "emmGrid")) {
                as.data.frame(x)
            } else if (inherits(x, "matrix")) {
                as.data.frame(x)
            } else if (is.data.frame(x)) {
                x
            } else {
                as.data.frame(x)
            }
        }, error = function(e) {
            stop("Error converting object to data frame: ", e$message)
        })
    })
    
    # Check for consistent columns
    col_names <- lapply(df_list, colnames)
    if (length(unique(lapply(col_names, length))) > 1) {
        stop("Inconsistent number of columns in objects")
    }
    
    # Create results data frame
    results <- data.frame(
        ID = rep(names(results_list), sapply(df_list, nrow)),
        do.call(rbind, df_list),
        check.names = FALSE
    )
    names(results)[1] <- id_col
    
    # Round numeric columns
    if (is.null(round_cols)) {
        numeric_cols <- sapply(results, is.numeric)
        results[, numeric_cols] <- round(results[, numeric_cols], digits)
    } else {
        results[, round_cols] <- round(results[, round_cols], digits)
    }
    
    # Use custom column names if provided
    if (!is.null(col.names)) {
        if (length(col.names) != ncol(results)) {
            stop("Length of col.names must match number of columns")
        }
        colnames(results) <- col.names
    }
    
    # Auto-detect alignment if not specified
    if (is.null(align)) {
        align <- ifelse(sapply(results, is.numeric), 'r', 'l')
    }
    
    # Create kable
    table <- knitr::kable(results,
                         format = format,
                         digits = digits,
                         caption = caption,
                         align = align,
                         booktabs = TRUE)
    
    # Apply kableExtra styling if requested
    if (!is.null(table_style) && requireNamespace("kableExtra", quietly = TRUE)) {
        table <- kableExtra::kable_styling(table,
                                         bootstrap_options = table_style)
    }
    
    # Add class for method dispatch
    class(table) <- c("bound_table", class(table))
    
    return(table)
}

# Print method
#' @export
print.bound_table <- function(x, ...) {
    print(unclass(x))
}

# Knit print method
#' @export
knit_print.bound_table <- function(x, ...) {
    knitr::knit_print(unclass(x), ...)
}
#end

#start EMMs functions for EMMs
#################
#     EMMs      #
#################

#' Bind Multiple Estimated Marginal Means into a Table
#'
#' @description
#' Combines multiple emmeans objects into a single formatted table, with model names
#' as identifiers. The output is compatible with knitr/quarto rendering.
#'
#' @param emm List of emmeans objects. Names of the list elements are used as model identifiers.
#' @param digits Integer. Number of decimal places for numeric columns (default: 2)
#' @param format Character. Output format: "markdown", "html", or "latex" (default: "markdown")
#' @param caption Character. Optional table caption
#' @param col.names Character vector. Custom column names
#'
#' @return A knitr_kable object that can be directly used in R Markdown or Quarto
#'
#' @examples
#' \dontrun{
#' # Create multiple emmeans objects
#' emm1 <- emmeans(model1, ~treatment)
#' emm2 <- emmeans(model2, ~treatment)
#'
#' # Combine into table
#' emm_table <- emm_bind(
#'   list("Model 1" = emm1, "Model 2" = emm2),
#'   digits = 3,
#'   caption = "Estimated Marginal Means Comparison"
#' )
#'
#' # Print table
#' emm_table
#' }
#'
#' @export
#' @importFrom knitr kable
#' @importFrom emmeans emmeans
emm_bind <- function(emm, 
                    digits = 2, 
                    format = "markdown",
                    caption = NULL,
                    col.names = NULL) {
    
    # Input validation
    if (!is.list(emm)) {
        stop("'emm' must be a list of emmeans objects")
    }
    
    if (length(emm) == 0) {
        stop("Empty list provided")
    }
    
    if (!all(sapply(emm, inherits, "emmGrid"))) {
        stop("All elements must be emmeans objects (class 'emmGrid')")
    }
    
    # Match format argument
    format <- match.arg(format)
    
    # Convert each emmeans object to data frame
    df_list <- lapply(emm, function(x) {
        tryCatch({
            as.data.frame(x)
        }, error = function(e) {
            stop("Error converting emmeans to data frame: ", e$message)
        })
    })
    
    # Check for consistent columns
    col_names <- lapply(df_list, colnames)
    if (length(unique(lapply(col_names, length))) > 1) {
        stop("Inconsistent number of columns in emmeans objects")
    }
    
    # Create results data frame
    results <- data.frame(
        Model = rep(names(df_list), sapply(df_list, nrow)),
        do.call(rbind, df_list),
        check.names = FALSE
    )
    
    # Round numeric columns to specified digits
    numeric_cols <- sapply(results, is.numeric)
    results[numeric_cols] <- round(results[numeric_cols], digits)
    
    # Use custom column names if provided
    if (!is.null(col.names)) {
        if (length(col.names) != ncol(results)) {
            stop("Length of col.names must match number of columns")
        }
        colnames(results) <- col.names
    }
    
    # Create kable with appropriate format
    table <- knitr::kable(results,
                         format = format,
                         digits = digits,
                         caption = caption,
                         booktabs = TRUE)
    
    # Add class for potential method dispatch
    class(table) <- c("emm_table", class(table))
    
    return(table)
}

#end

calculate_pairwise_vda <- function(data, value_col, group_col) {
  # Get unique groups
  groups <- unique(data[[group_col]])
  n_groups <- length(groups)
  
  # Create empty results dataframe
  results <- data.frame(
    group1 = character(),
    group2 = character(),
    VDA = numeric(),
    effect_size = character(),
    stringsAsFactors = FALSE
  )
  
  # Calculate VDA for each pair
  for(i in 1:(n_groups-1)) {
    for(j in (i+1):n_groups) {
      group1_data <- data[data[[group_col]] == groups[i], ][[value_col]]
      group2_data <- data[data[[group_col]] == groups[j], ][[value_col]]
      
      # Calculate VDA
      score <- 0
      for(x1 in group1_data) {
        for(x2 in group2_data) {
          if(x1 > x2) score <- score + 1
          if(x1 == x2) score <- score + 0.5
        }
      }
      
      vda <- score/(length(group1_data) * length(group2_data))
      
      # Determine effect size
      effect <- case_when(
        vda >= 0.71 ~ "large",
        vda >= 0.64 ~ "medium",
        vda >= 0.56 ~ "small",
        vda <= 0.29 ~ "large negative",
        vda <= 0.36 ~ "medium negative",
        vda <= 0.44 ~ "small negative",
        TRUE ~ "negligible"
      )
      
      # Add to results
      results <- rbind(results, data.frame(
        group1 = groups[i],
        group2 = groups[j],
        VDA = vda,
        effect_size = effect
      ))
    }
  }
  
  return(results)
}

author <- function(){
  require("usethis")

  use_author(
    given = "Nathaniel",
    family = "Cole",
    email = "nc564@cornell.edu",
    role = c("aut", "cre", "cph"),
    comment = c(ORCID = "0000-0002-5132-3681")
  )
}
