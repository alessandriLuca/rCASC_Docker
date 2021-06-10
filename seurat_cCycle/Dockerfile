

FROM library/ubuntu:18.04 as UBUNTU_BASE
MAINTAINER alessandri.luca1991@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
COPY ./R-3.6.0 /tmp
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
RUN /tmp/configure
RUN make
RUN make install
COPY p7zip_16.02 /tmp/
RUN cd /tmp/ && make
RUN cd /tmp/ && make install
RUN rm -r /tmp/*
COPY install_files.7z* /tmp/
RUN cd /tmp/ && 7za -y x "*.7z*" 


RUN R CMD INSTALL --build /tmp/install_files/assertthat_0.2.1.tar.gz \
    /tmp/install_files/crayon_1.3.4.tar.gz \
    /tmp/install_files/rlang_0.4.10.tar.gz \
    /tmp/install_files/ellipsis_0.3.1.tar.gz \ 
    /tmp/install_files/fansi_0.4.1.tar.gz \
    /tmp/install_files/glue_1.4.2.tar.gz \
    /tmp/install_files/cli_2.2.0.tar.gz \
    /tmp/install_files/magrittr_2.0.1.tar.gz \
    /tmp/install_files/utf8_1.1.4.tar.gz \
    /tmp/install_files/pkgconfig_2.0.3.tar.gz \
    /tmp/install_files/digest_0.6.27.tar.gz \ 
    /tmp/install_files/vctrs_0.3.6.tar.gz \
    /tmp/install_files/lifecycle_0.2.0.tar.gz \
    /tmp/install_files/pillar_1.4.7.tar.gz \
    /tmp/install_files/tibble_3.0.4.tar.gz



RUN R CMD INSTALL --build /tmp/install_files/brio_1.1.0.tar.gz \
	/tmp/install_files/ps_1.5.0.tar.gz \ 
	/tmp/install_files/R6_2.5.0.tar.gz \
	/tmp/install_files/processx_3.4.5.tar.gz \ 
	/tmp/install_files/callr_3.5.1.tar.gz \
	/tmp/install_files/rprojroot_2.0.2.tar.gz \ 
	/tmp/install_files/desc_1.2.0.tar.gz \
	/tmp/install_files/evaluate_0.14.tar.gz \ 
	/tmp/install_files/jsonlite_1.7.2.tar.gz \
	/tmp/install_files/praise_1.0.0.tar.gz 




RUN R CMD INSTALL --build /tmp/install_files/rstudioapi_0.13.tar.gz \
	/tmp/install_files/diffobj_0.3.3.tar.gz \
	/tmp/install_files/rematch2_2.1.2.tar.gz \
	/tmp/install_files/waldo_0.2.3.tar.gz \
	/tmp/install_files/prettyunits_1.1.1.tar.gz \
	/tmp/install_files/withr_2.3.0.tar.gz \
	/tmp/install_files/pkgbuild_1.2.0.tar.gz \
	/tmp/install_files/pkgload_1.1.0.tar.gz \
	/tmp/install_files/testthat_3.0.1.tar.gz \
	/tmp/install_files/isoband_0.2.3.tar.gz \
	/tmp/install_files/farver_2.0.3.tar.gz \
	/tmp/install_files/labeling_0.4.2.tar.gz \
	/tmp/install_files/colorspace_2.0-0.tar.gz \
	/tmp/install_files/munsell_0.5.0.tar.gz \
	/tmp/install_files/RColorBrewer_1.1-2.tar.gz \
	/tmp/install_files/viridisLite_0.3.0.tar.gz\
	/tmp/install_files/scales_1.1.1.tar.gz \
	/tmp/install_files/gtable_0.3.0.tar.gz \ 
	/tmp/install_files/ggplot2_3.3.3.tar.gz \
	/tmp/install_files/cowplot_1.1.1.tar.gz \
	/tmp/install_files/fitdistrplus_1.1-3.tar.gz



RUN R CMD INSTALL --build /tmp/install_files/globals_0.14.0.tar.gz \
	/tmp/install_files/listenv_0.8.0.tar.gz \
	/tmp/install_files/parallelly_1.23.0.tar.gz \
	/tmp/install_files/future_1.21.0.tar.gz \
	/tmp/install_files/future.apply_1.7.0.tar.gz 	

RUN apt-get install libssl-dev




RUN R CMD INSTALL --build /tmp/install_files/Rcpp_1.0.5.tar.gz \
	/tmp/install_files/ggrepel_0.9.0.tar.gz \
	/tmp/install_files/plyr_1.8.6.tar.gz \
	/tmp/install_files/ggridges_0.5.3.tar.gz \
	/tmp/install_files/curl_4.3.tar.gz \
	/tmp/install_files/mime_0.9.tar.gz \
	/tmp/install_files/sys_3.4.tar.gz \
	/tmp/install_files/askpass_1.1.tar.gz \
	/tmp/install_files/openssl_1.4.1.tar.gz \
	/tmp/install_files/httr_1.4.2.tar.gz \
	/tmp/install_files/ica_1.0-2.tar.gz \
	/tmp/install_files/igraph_1.2.6.tar.gz \
	/tmp/install_files/rappdirs_0.3.1.tar.gz \
	/tmp/install_files/reticulate_1.18.tar.gz \
	/tmp/install_files/irlba_2.3.3.tar.gz \
	/tmp/install_files/leiden_0.3.6.tar.gz \
	/tmp/install_files/zoo_1.8-8.tar.gz \
	/tmp/install_files/lmtest_0.9-38.tar.gz \
	/tmp/install_files/matrixStats_0.57.0.tar.gz 





RUN R CMD INSTALL --build /tmp/install_files/BH_1.75.0-0.tar.gz \
	/tmp/install_files/later_1.1.0.1.tar.gz \ 
	/tmp/install_files/promises_1.1.1.tar.gz \	
	/tmp/install_files/httpuv_1.5.5.tar.gz \
	/tmp/install_files/xtable_1.8-4.tar.gz \
	/tmp/install_files/base64enc_0.1-3.tar.gz \
	/tmp/install_files/htmltools_0.5.1.tar.gz \
	/tmp/install_files/sourcetools_0.1.7.tar.gz \
	/tmp/install_files/fastmap_1.0.1.tar.gz \
	/tmp/install_files/commonmark_1.7.tar.gz \
	/tmp/install_files/shiny_1.5.0.tar.gz \
	/tmp/install_files/miniUI_0.1.1.1.tar.gz \
	/tmp/install_files/patchwork_1.1.1.tar.gz \
	/tmp/install_files/pbapply_1.4-3.tar.gz 




RUN R CMD INSTALL --build /tmp/install_files/yaml_2.2.1.tar.gz \
	/tmp/install_files/htmlwidgets_1.5.3.tar.gz \
	/tmp/install_files/purrr_0.3.4.tar.gz \
	/tmp/install_files/generics_0.1.0.tar.gz \
	/tmp/install_files/tidyselect_1.1.0.tar.gz \	
	/tmp/install_files/dplyr_1.0.3.tar.gz \
	/tmp/install_files/cpp11_0.2.5.tar.gz \
	/tmp/install_files/tidyr_1.1.2.tar.gz \
	/tmp/install_files/lazyeval_0.2.2.tar.gz \
	/tmp/install_files/crosstalk_1.1.1.tar.gz \
	/tmp/install_files/data.table_1.13.6.tar.gz \
	/tmp/install_files/plotly_4.9.3.tar.gz \
	/tmp/install_files/png_0.1-7.tar.gz \
	/tmp/install_files/RANN_2.6.1.tar.gz \
	/tmp/install_files/RcppAnnoy_0.0.18.tar.gz
	




RUN R CMD INSTALL --build /tmp/install_files/bitops_1.0-6.tar.gz \
	/tmp/install_files/caTools_1.18.1.tar.gz \
	/tmp/install_files/gtools_3.8.2.tar.gz \
	/tmp/install_files/gplots_3.1.1.tar.gz\
	/tmp/install_files/ROCR_1.0-11.tar.gz \
	/tmp/install_files/rsvd_1.0.3.tar.gz \
	/tmp/install_files/Rtsne_0.15.tar.gz \
	/tmp/install_files/RcppArmadillo_0.10.1.2.2.tar.gz \
	/tmp/install_files/stringi_1.5.3.tar.gz \
	/tmp/install_files/stringr_1.4.0.tar.gz \
	/tmp/install_files/reshape2_1.4.4.tar.gz \
	/tmp/install_files/gridExtra_2.3.tar.gz \
	/tmp/install_files/sctransform_0.3.2.tar.gz 




RUN R CMD INSTALL --build /tmp/install_files/spatstat.utils_1.20-2.tar.gz \
	/tmp/install_files/spatstat.data_1.7-0.tar.gz \
	/tmp/install_files/deldir_0.2-3.tar.gz \
	/tmp/install_files/abind_1.4-5.tar.gz \
	/tmp/install_files/tensor_1.5.tar.gz \
	/tmp/install_files/polyclip_1.10-0.tar.gz \
	/tmp/install_files/goftest_1.2-2.tar.gz \ 
	/tmp/install_files/spatstat_1.64-1.tar.gz \
	/tmp/install_files/FNN_1.1.3.tar.gz \
	/tmp/install_files/RcppEigen_0.3.3.9.1.tar.gz \
	/tmp/install_files/RcppProgress_0.4.2.tar.gz \
	/tmp/install_files/RSpectra_0.16-0.tar.gz \
	/tmp/install_files/sitmo_2.0.1.tar.gz \	
	/tmp/install_files/dqrng_0.2.1.tar.gz \
	/tmp/install_files/uwot_0.1.10.tar.gz \
	/tmp/install_files/Seurat_3.2.2.tar.gz 
	
	
	
	RUN R CMD INSTALL --build /tmp/install_files/argparser_0.6.tar.gz

	COPY ["main.R","/home/"]

RUN mkdir -p /data/
RUN mkdir -p /scratch/
RUN apt-get update
RUN apt-get install tree
