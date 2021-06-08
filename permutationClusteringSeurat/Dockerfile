

FROM library/ubuntu as UBUNTU_BASE
MAINTAINER g.pia91@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
COPY ./R-3.4.4 /tmp
COPY ./home/* /home/
RUN apt-get update
RUN apt-get -y install gfortran
RUN apt-get -y install build-essential
RUN apt-get -y install fort77
RUN apt-get -y install xorg-dev
RUN apt-get -y install liblzma-dev  libblas-dev gfortran
RUN apt-get -y install gcc-multilib
RUN apt-get -y install gobjc++
RUN apt-get -y install aptitude
RUN apt-get -y install libbz2-dev
RUN apt-get -y install libpcre3-dev
RUN aptitude -y install libreadline-dev
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install tcl-dev tk-dev
RUN /tmp/configure --with-tcltk --with-tcl-config=/usr/lib/tclConfig.sh --with-tk-config=/usr/lib/tkConfig.sh
RUN make
RUN make install



COPY [ "Matrix_1.2-15.tar.gz","./assertthat_0.2.1.tar.gz", "./crayon_1.3.4.tar.gz", "./ellipsis_0.3.1.tar.gz",\
       "./fansi_0.4.1.tar.gz", "./cli_2.2.0.tar.gz", "./magrittr_2.0.1.tar.gz", \
       "./utf8_1.1.4.tar.gz", "./pkgconfig_2.0.3.tar.gz", "./digest_0.6.27.tar.gz",\ 
       "./vctrs_0.3.6.tar.gz", "./pillar_1.4.7.tar.gz", "./tibble_3.0.4.tar.gz", \
       "./rlang_0.4.10.tar.gz", "./glue_1.4.2.tar.gz", "./lifecycle_0.2.0.tar.gz", \
       "/tmp/" ]

RUN R CMD INSTALL --build tmp/assertthat_0.2.1.tar.gz \
    tmp/crayon_1.3.4.tar.gz \
	tmp/Matrix_1.2-15.tar.gz \
    tmp/rlang_0.4.10.tar.gz \
    tmp/ellipsis_0.3.1.tar.gz \ 
    tmp/fansi_0.4.1.tar.gz \
    tmp/glue_1.4.2.tar.gz \
    tmp/cli_2.2.0.tar.gz \
    tmp/magrittr_2.0.1.tar.gz \
    tmp/utf8_1.1.4.tar.gz \
    tmp/pkgconfig_2.0.3.tar.gz \
    tmp/digest_0.6.27.tar.gz \ 
    tmp/vctrs_0.3.6.tar.gz \
    tmp/lifecycle_0.2.0.tar.gz \
    tmp/pillar_1.4.7.tar.gz \
    tmp/tibble_3.0.4.tar.gz


COPY [ "./brio_1.1.0.tar.gz", "./ps_1.5.0.tar.gz", "./processx_3.4.5.tar.gz", "./callr_3.5.1.tar.gz", \
       "./rprojroot_2.0.2.tar.gz", "./desc_1.2.0.tar.gz", "./evaluate_0.14.tar.gz", "./jsonlite_1.7.2.tar.gz", \
       "./praise_1.0.0.tar.gz", "./R6_2.5.0.tar.gz", "/tmp/" ] 

RUN R CMD INSTALL --build tmp/brio_1.1.0.tar.gz \
	tmp/ps_1.5.0.tar.gz \ 
	tmp/R6_2.5.0.tar.gz \
	tmp/processx_3.4.5.tar.gz \ 
	tmp/callr_3.5.1.tar.gz \
	tmp/rprojroot_2.0.2.tar.gz \ 
	tmp/desc_1.2.0.tar.gz \
	tmp/evaluate_0.14.tar.gz \ 
	tmp/jsonlite_1.7.2.tar.gz \
	tmp/praise_1.0.0.tar.gz 


COPY [ "./rstudioapi_0.13.tar.gz", "./diffobj_0.3.3.tar.gz", "./rematch2_2.1.2.tar.gz", \
	"./waldo_0.2.3.tar.gz", "./prettyunits_1.1.1.tar.gz", "./withr_2.3.0.tar.gz", 	\
	"./pkgbuild_1.2.0.tar.gz", "./pkgload_1.1.0.tar.gz", "./testthat_3.0.1.tar.gz", \
	"./isoband_0.2.3.tar.gz", "./ggplot2_3.3.3.tar.gz",  \
	"./fitdistrplus_1.1-3.tar.gz" , "scales_1.1.1.tar.gz", "gtable_0.3.0.tar.gz", \
	"farver_2.0.3.tar.gz", "labeling_0.4.2.tar.gz", "munsell_0.5.0.tar.gz", \
	"RColorBrewer_1.1-2.tar.gz", "viridisLite_0.3.0.tar.gz", "colorspace_2.0-0.tar.gz" ,"/tmp/" ]

RUN R CMD INSTALL --build tmp/rstudioapi_0.13.tar.gz \
	tmp/diffobj_0.3.3.tar.gz \
	tmp/rematch2_2.1.2.tar.gz \
	tmp/waldo_0.2.3.tar.gz \
	tmp/prettyunits_1.1.1.tar.gz \
	tmp/withr_2.3.0.tar.gz \
	tmp/pkgbuild_1.2.0.tar.gz \
	tmp/pkgload_1.1.0.tar.gz \
	tmp/testthat_3.0.1.tar.gz \
	tmp/isoband_0.2.3.tar.gz \
	tmp/farver_2.0.3.tar.gz \
	tmp/labeling_0.4.2.tar.gz \
	tmp/colorspace_2.0-0.tar.gz \
	tmp/munsell_0.5.0.tar.gz \
	tmp/RColorBrewer_1.1-2.tar.gz \
	tmp/viridisLite_0.3.0.tar.gz\
	tmp/scales_1.1.1.tar.gz \
	tmp/gtable_0.3.0.tar.gz \ 
	tmp/ggplot2_3.3.3.tar.gz \
	tmp/fitdistrplus_1.1-3.tar.gz


COPY [ "globals_0.14.0.tar.gz", "listenv_0.8.0.tar.gz", "parallelly_1.23.0.tar.gz",\
	"future_1.21.0.tar.gz", "future.apply_1.7.0.tar.gz","/tmp/" ]

RUN R CMD INSTALL --build tmp/globals_0.14.0.tar.gz \
	tmp/listenv_0.8.0.tar.gz \
	tmp/parallelly_1.23.0.tar.gz \
	tmp/future_1.21.0.tar.gz \
	tmp/future.apply_1.7.0.tar.gz 	

RUN apt-get update && apt-get -y install libssl-dev

COPY ["ggrepel_0.9.0.tar.gz", "ggridges_0.5.3.tar.gz", "httr_1.4.2.tar.gz", "ica_1.0-2.tar.gz", \
	"igraph_1.2.6.tar.gz", "irlba_2.3.3.tar.gz", "leiden_0.3.6.tar.gz", "lmtest_0.9-38.tar.gz", \
	"matrixStats_0.57.0.tar.gz", "miniUI_0.1.1.1.tar.gz", "patchwork_1.1.1.tar.gz", \
	"pbapply_1.4-3.tar.gz", "plotly_4.9.3.tar.gz", "png_0.1-7.tar.gz", "RANN_2.6.1.tar.gz", \
	"Rcpp_1.0.5.tar.gz", "plyr_1.8.6.tar.gz", "curl_4.3.tar.gz", "mime_0.9.tar.gz", \
	"openssl_1.4.1.tar.gz", "askpass_1.1.tar.gz", "sys_3.4.tar.gz", "reticulate_1.18.tar.gz", \
	"rappdirs_0.3.1.tar.gz","zoo_1.8-8.tar.gz", "shiny_1.5.0.tar.gz", "htmltools_0.5.1.tar.gz", \
	"/tmp/"]



RUN R CMD INSTALL --build tmp/Rcpp_1.0.5.tar.gz \
	tmp/ggrepel_0.9.0.tar.gz \
	tmp/plyr_1.8.6.tar.gz \
	tmp/ggridges_0.5.3.tar.gz \
	tmp/curl_4.3.tar.gz \
	tmp/mime_0.9.tar.gz \
	tmp/sys_3.4.tar.gz \
	tmp/askpass_1.1.tar.gz \
	tmp/openssl_1.4.1.tar.gz \
	tmp/httr_1.4.2.tar.gz \
	tmp/ica_1.0-2.tar.gz \
	tmp/igraph_1.2.6.tar.gz \
	tmp/rappdirs_0.3.1.tar.gz \
	tmp/reticulate_1.18.tar.gz \
	tmp/irlba_2.3.3.tar.gz \
	tmp/leiden_0.3.6.tar.gz \
	tmp/zoo_1.8-8.tar.gz \
	tmp/lmtest_0.9-38.tar.gz \
	tmp/matrixStats_0.57.0.tar.gz 



COPY [ "./cowplot_0.9.4.tar.gz","httpuv_1.5.5.tar.gz", "xtable_1.8-4.tar.gz", "sourcetools_0.1.7.tar.gz", \
	"later_1.1.0.1.tar.gz", "promises_1.1.1.tar.gz", "fastmap_1.0.1.tar.gz", \
	"commonmark_1.7.tar.gz", "BH_1.75.0-0.tar.gz", "base64enc_0.1-3.tar.gz", \
	"htmlwidgets_1.5.3.tar.gz", "tidyr_1.1.2.tar.gz", "dplyr_1.0.3.tar.gz",\
	"lazyeval_0.2.2.tar.gz", "crosstalk_1.1.1.tar.gz", "purrr_0.3.4.tar.gz", \
	"data.table_1.13.6.tar.gz", "/tmp/"]


RUN R CMD INSTALL --build tmp/BH_1.75.0-0.tar.gz \
	tmp/cowplot_0.9.4.tar.gz \
	tmp/later_1.1.0.1.tar.gz \ 
	tmp/promises_1.1.1.tar.gz \	
	tmp/httpuv_1.5.5.tar.gz \
	tmp/xtable_1.8-4.tar.gz \
	tmp/base64enc_0.1-3.tar.gz \
	tmp/htmltools_0.5.1.tar.gz \
	tmp/sourcetools_0.1.7.tar.gz \
	tmp/fastmap_1.0.1.tar.gz \
	tmp/commonmark_1.7.tar.gz \
	tmp/shiny_1.5.0.tar.gz \
	tmp/miniUI_0.1.1.1.tar.gz \
	tmp/patchwork_1.1.1.tar.gz \
	tmp/pbapply_1.4-3.tar.gz 


COPY ["yaml_2.2.1.tar.gz", "cpp11_0.2.5.tar.gz", "tidyselect_1.1.0.tar.gz", \ 
	"generics_0.1.0.tar.gz", "RcppAnnoy_0.0.18.tar.gz", "ROCR_1.0-7.tar.gz", \
	"rsvd_1.0.3.tar.gz", "Rtsne_0.15.tar.gz", "sctransform_0.3.2.tar.gz", \
	"spatstat_1.56-1.tar", "uwot_0.1.10.tar.gz", "RcppEigen_0.3.3.9.1.tar.gz", \
	"RcppProgress_0.4.2.tar.gz", "gplots_3.1.1.tar.gz", "/tmp/"]

RUN R CMD INSTALL --build tmp/yaml_2.2.1.tar.gz \
	tmp/htmlwidgets_1.5.3.tar.gz \
	tmp/purrr_0.3.4.tar.gz \
	tmp/generics_0.1.0.tar.gz \
	tmp/tidyselect_1.1.0.tar.gz \	
	tmp/dplyr_1.0.3.tar.gz \
	tmp/cpp11_0.2.5.tar.gz \
	tmp/tidyr_1.1.2.tar.gz \
	tmp/lazyeval_0.2.2.tar.gz \
	tmp/crosstalk_1.1.1.tar.gz \
	tmp/data.table_1.13.6.tar.gz \
	tmp/plotly_4.9.3.tar.gz \
	tmp/png_0.1-7.tar.gz \
	tmp/RANN_2.6.1.tar.gz \
	tmp/RcppAnnoy_0.0.18.tar.gz
	

COPY ["ape_5.4-1.tar.gz","caTools_1.17.1.1.tar.gz", "gtools_3.8.2.tar.gz", "bitops_1.0-6.tar.gz", \
	"RcppArmadillo_0.10.1.2.2.tar.gz", "reshape2_1.4.4.tar.gz", "gridExtra_2.3.tar.gz", \
	"stringr_1.4.0.tar.gz", "stringi_1.5.3.tar.gz","/tmp/"]


RUN R CMD INSTALL --build tmp/bitops_1.0-6.tar.gz \
	tmp/ape_5.4-1.tar.gz \
	tmp/caTools_1.17.1.1.tar.gz \
	tmp/gtools_3.8.2.tar.gz \
	tmp/gplots_3.1.1.tar.gz\
	tmp/ROCR_1.0-7.tar.gz \
	tmp/rsvd_1.0.3.tar.gz \
	tmp/Rtsne_0.15.tar.gz \
	tmp/RcppArmadillo_0.10.1.2.2.tar.gz \
	tmp/stringi_1.5.3.tar.gz \
	tmp/stringr_1.4.0.tar.gz \
	tmp/reshape2_1.4.4.tar.gz \
	tmp/gridExtra_2.3.tar.gz \
	tmp/sctransform_0.3.2.tar.gz 


COPY [ "spatstat.data_1.4-0.tar.gz", "deldir_0.1-15.tar.gz", "abind_1.4-5.tar.gz", \
	"tensor_1.5.tar.gz", "polyclip_1.10-0.tar.gz", "goftest_1.2-2.tar.gz", \
	"spatstat.utils_1.20-2.tar.gz", "FNN_1.1.3.tar.gz", "RSpectra_0.16-0.tar.gz", \
	"dqrng_0.2.1.tar.gz", "sitmo_2.0.1.tar.gz", "Seurat_3.2.0.tar.gz", "/tmp/"]

RUN R CMD INSTALL --build tmp/spatstat.utils_1.20-2.tar.gz \
	tmp/spatstat.data_1.4-0.tar.gz \
	tmp/deldir_0.1-15.tar.gz \
	tmp/abind_1.4-5.tar.gz \
	tmp/tensor_1.5.tar.gz \
	tmp/polyclip_1.10-0.tar.gz \
	tmp/goftest_1.2-2.tar.gz \ 
	tmp/spatstat_1.56-1.tar \
	tmp/FNN_1.1.3.tar.gz \
	tmp/RcppEigen_0.3.3.9.1.tar.gz \
	tmp/RcppProgress_0.4.2.tar.gz \
	tmp/RSpectra_0.16-0.tar.gz \
	tmp/sitmo_2.0.1.tar.gz \	
	tmp/dqrng_0.2.1.tar.gz \
	tmp/uwot_0.1.10.tar.gz \
	tmp/Seurat_3.2.0.tar.gz 

COPY [ "sandwich_2.5-0.tar.gz", "TH.data_1.0-9.tar.gz","/tmp/"]

RUN R CMD INSTALL --build tmp/sandwich_2.5-0.tar.gz \
	tmp/TH.data_1.0-9.tar.gz

COPY [ "mvtnorm_1.0-8.tar.gz", "multcomp_1.4-8.tar.gz","VGAM_1.0-6.tar.gz","/tmp/"]

RUN R CMD INSTALL --build tmp/mvtnorm_1.0-8.tar.gz \
	tmp/multcomp_1.4-8.tar.gz \
	tmp/VGAM_1.0-6.tar.gz

RUN R -e "install.packages('vioplot',dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN R -e "install.packages('argparser',dependencies=TRUE, repos='http://cran.rstudio.com/')"

RUN R -e "install.packages('Publish',dependencies=TRUE, repos='http://cran.rstudio.com/')"