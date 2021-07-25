function (y, label, w, filename, filetype, n.cores, legendtitle = "Cell Type", 
    width = 9.5, height = 8.5, res = 400, ...) 
{
    start_time <- Sys.time()
    if (missing(n.cores)) {
        n.cores = detectCores() - 1
    }
    cat("Start visualization...\n")
    w1 = dim(y$x0)[2]
    w2 = dim(y$viE)[2]
    if (missing(w)) {
        w = 2
    }
    if (w >= 100) {
        x1 = as.matrix(y$x0)
        x1 = jitter(x1, amount = 0)
    }
    else if (w <= 0.01) {
        x1 = as.matrix(y$viE)
    }
    else {
        x1 = as.matrix(cbind(w * scale(y$x0), scale(y$viE)))
    }
    if (dim(x1)[2] <= 50) {
        flag = FALSE
    }
    else {
        flag = TRUE
    }
    if (missing(filetype)) {
        if (dim(x1)[1] < 5000) {
            filetype = "pdf"
        }
        else {
            filetype = "png"
        }
    }
    if (missing(filename)) {
        filename = paste("vi_SHARP.", filetype, sep = "")
    }
    set.seed(10)
    cat("Project to 2-D space...\n")
    rtsne_out <- Rtsne(x1, check_duplicates = FALSE, pca = flag, 
        num_threads = n.cores, ...)
    file_plot <- filename
    tt = "2D SHARP Visualization"
    cat("Draw the scatter plots...\n")
    if (!missing(label)) {
        uc = length(unique(label))
        d0 = data.frame(rtsne_out$Y, as.character(label))
        colnames(d0) = c("x1", "x2", "label")
        allcol = c("black", "red", "green", "blue", "cyan", "magenta", 
            "yellow", "grey", "brown", "purple", "orange", "turquoise", 
            "beige", "coral", "khaki", "violet", "pink", "salmon", 
            "goldenrod", "orchid", "seagreen", "slategray", "darkred", 
            "darkblue", "darkcyan", "darkgreen", "darkgray", 
            "darkkhaki", "darkorange", "darkmagenta", "darkviolet", 
            "darkturquoise", "darksalmon", "darkgoldenrod", "darkorchid", 
            "darkseagreen", "darkslategray", "deeppink", "lightcoral", 
            "lightcyan")
        nl = length(allcol)
        n0 = 1:uc%%length(allcol)
        n0[n0 == 0] = nl
        pcol = allcol[n0]
        colScale <- scale_colour_manual(name = "label", values = pcol)
        vplot = ggplot(d0, aes(x = x1, y = x2, colour = label, 
            group = label)) + theme_bw(base_size = 14) + theme_classic() + 
            geom_point(size = 1) + theme(axis.title = element_text(face = "bold", 
            size = "14"), axis.text.x = element_text(size = "14", 
            hjust = 0.5, face = "bold", colour = "black"), axis.text.y = element_text(size = "14", 
            face = "bold", colour = "black"), legend.text = element_text(size = "14", 
            face = "bold"), legend.title = element_blank(), plot.title = element_text(hjust = 0.5, 
            size = "14", face = "bold"), panel.background = element_blank(), 
            panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
            panel.border = element_rect(fill = NA)) + xlab("SHARP Dim-1") + 
            ylab("SHARP Dim-2") + labs(group = legendtitle) + 
            ggtitle(tt) + colScale
        if (filetype == "pdf") {
            ggsave(file_plot, vplot, device = filetype, width = width)
        }
        else if (filetype == "png") {
            ggsave(file_plot, vplot, device = filetype, units = "in", 
                dpi = res)
        }
    }
    else {
        if (filetype == "pdf") {
            pdf(file_plot, width = width)
        }
        else if (filetype == "png") {
            png(file_plot, width = width, height = height, units = "in", 
                res = res)
        }
        plot(rtsne_out$Y, asp = 1, pch = 20, cex = 0.75, cex.axis = 1.25, 
            cex.lab = 1.25, cex.main = 1.5, xlab = "SHARP Dim-1", 
            ylab = "SHARP Dim-2", main = tt)
        dev.off()
    }
    end_time <- Sys.time()
    t <- difftime(end_time, start_time, units = "mins")
    cat("Running time for visualization:", t, "minutes\n")
    cat("-----------------------------------------------------------------------\n")
    cat("Results saved into", file_plot, "\n")
}
