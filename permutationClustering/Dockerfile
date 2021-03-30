FROM library/ubuntu as UBUNTU_BASE
MAINTAINER alessandri.luca1991@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
COPY ./R-3.3.1 /tmp
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
RUN apt-get update
RUN apt-get install -y tcl
RUN apt-get install -y tcl-dev
RUN apt-get install -y tk-dev
RUN /tmp/configure --with-tcltk --with-tcl-config=/usr/lib/tclConfig.sh --with-tk-config=/usr/lib/tkConfig.sh
RUN make
RUN make install



COPY /home/* /home/
COPY p7zip_16.02 /tmp/
RUN cd /tmp/ && make
RUN cd /tmp/ && make install
COPY tmp.7z* /tmp/
RUN cd /tmp/ && 7za -y x "*.7z*" 


RUN R CMD INSTALL --build /tmp/tmp/doBy_4.5-15.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/DBI_0.6-1.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/digest_0.6.12.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/memoise_1.1.0.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/Rcpp_0.12.11.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/BH_1.72.0-3.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/plogr_0.2.0.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/RSQLite_1.1-2.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/refGenome_1.7.3.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/data.table_1.13.4.tar.gz
RUN apt-get install -y libcurl4-gnutls-dev libxml2-dev libssl-dev
RUN R CMD INSTALL --build /tmp/tmp/assertthat_0.2.1.tar.gz /tmp/tmp/glue_1.4.2.tar.gz /tmp/tmp/cli_2.3.0.tar.gz /tmp/tmp/crayon_1.4.1.tar.gz /tmp/tmp/rlang_0.4.10.tar.gz /tmp/tmp/ellipsis_0.3.1.tar.gz /tmp/tmp/fansi_0.4.2.tar.gz /tmp/tmp/lifecycle_1.0.0.tar.gz /tmp/tmp/vctrs_0.3.6.tar.gz /tmp/tmp/utf8_1.1.4.tar.gz /tmp/tmp/pillar_1.4.7.tar.gz /tmp/tmp/pkgconfig_2.0.3.tar.gz /tmp/tmp/sys_3.4.tar.gz /tmp/tmp/askpass_1.1.tar.gz /tmp/tmp/openssl_1.4.3.tar.gz /tmp/tmp/curl_4.3.tar.gz /tmp/tmp/jsonlite_1.7.2.tar.gz /tmp/tmp/credentials_1.3.0.tar.gz /tmp/tmp/zip_2.1.1.tar.gz /tmp/tmp/gitcreds_0.1.1.tar.gz /tmp/tmp/ini_0.3.1.tar.gz /tmp/tmp/lazyeval_0.2.2.tar.gz /tmp/tmp/base64enc_0.1-3.tar.gz /tmp/tmp/later_1.1.0.1.tar.gz /tmp/tmp/highr_0.8.tar.gz /tmp/tmp/xfun_0.21.tar.gz /tmp/tmp/mime_0.10.tar.gz /tmp/tmp/markdown_1.1.tar.gz /tmp/tmp/diffobj_0.3.3.tar.gz /tmp/tmp/magrittr_2.0.1.tar.gz /tmp/tmp/tibble_3.0.6.tar.gz /tmp/tmp/rematch2_2.1.2.tar.gz /tmp/tmp/clipr_0.7.1.tar.gz /tmp/tmp/fs_1.5.0.tar.gz /tmp/tmp/rstudioapi_0.13.tar.gz /tmp/tmp/gert_1.2.0.tar.gz /tmp/tmp/R6_2.5.0.tar.gz /tmp/tmp/httr_1.4.2.tar.gz /tmp/tmp/gh_1.2.0.tar.gz /tmp/tmp/purrr_0.3.4.tar.gz /tmp/tmp/rappdirs_0.3.3.tar.gz /tmp/tmp/rprojroot_2.0.2.tar.gz /tmp/tmp/whisker_0.4.tar.gz /tmp/tmp/yaml_2.2.1.tar.gz /tmp/tmp/ps_1.5.0.tar.gz /tmp/tmp/processx_3.4.5.tar.gz /tmp/tmp/rex_1.2.0.tar.gz /tmp/tmp/htmltools_0.5.1.1.tar.gz /tmp/tmp/htmlwidgets_1.5.3.tar.gz /tmp/tmp/crosstalk_1.1.1.tar.gz /tmp/tmp/promises_1.2.0.1.tar.gz /tmp/tmp/prettyunits_1.1.1.tar.gz /tmp/tmp/brew_1.0-6.tar.gz /tmp/tmp/commonmark_1.7.tar.gz /tmp/tmp/evaluate_0.14.tar.gz /tmp/tmp/stringi_1.5.3.tar.gz /tmp/tmp/stringr_1.4.0.tar.gz /tmp/tmp/knitr_1.31.tar.gz /tmp/tmp/xml2_1.3.2.tar.gz /tmp/tmp/brio_1.1.1.tar.gz /tmp/tmp/praise_1.0.0.tar.gz /tmp/tmp/waldo_0.2.4.tar.gz /tmp/tmp/desc_1.2.0.tar.gz /tmp/tmp/withr_2.4.1.tar.gz /tmp/tmp/usethis_2.0.1.tar.gz /tmp/tmp/callr_3.5.1.tar.gz /tmp/tmp/covr_3.5.1.tar.gz /tmp/tmp/DT_0.17.tar.gz /tmp/tmp/pkgbuild_1.2.0.tar.gz /tmp/tmp/pkgload_1.1.0.tar.gz /tmp/tmp/sessioninfo_1.1.1.tar.gz /tmp/tmp/xopen_1.0.0.tar.gz/tmp/tmp/rcmdcheck_1.3.3.tar.gz /tmp/tmp/remotes_2.2.0.tar.gz /tmp/tmp/roxygen2_7.1.1.tar.gz /tmp/tmp/rversions_2.0.2.tar.gz /tmp/tmp/testthat_3.0.2.tar.gz /tmp/tmp/xopen_1.0.0.tar.gz/tmp/tmp/rcmdcheck_1.3.3.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/xopen_1.0.0.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/rcmdcheck_1.3.3.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/devtools_2.3.2.tar.gz
RUN R CMD INSTALL --build /tmp/tmp/QUIC_1.1.tar.gz
RUN R CMD INSTALL -- build /tmp/tmp/iterators_1.0.13.tar.gz /tmp/tmp/bigmemory.sri_0.1.3.tar.gz /tmp/tmp/foreach_1.5.1.tar.gz /tmp/tmp/RcppArmadillo_0.10.2.1.0.tar.gz /tmp/tmp/RcppProgress_0.4.2.tar.gz /tmp/tmp/RColorBrewer_1.1-2.tar.gz /tmp/tmp/bigmemory_4.5.36.tar.gz /tmp/tmp/doParallel_1.0.16.tar.gz /tmp/tmp/corpcor_1.6.9.tar.gz /tmp/tmp/coop_0.6-2.tar.gz /tmp/tmp/igraph_1.2.6.tar.gz
RUN Rscript /home/script.R
RUN R CMD INSTALL --build /tmp/tmp/argparser_0.6.tar.gz \
/tmp/tmp/generics_0.1.0.tar.gz \
/tmp/tmp/tidyselect_1.1.0.tar.gz \
/tmp/tmp/dplyr_1.0.4.tar.gz \
/tmp/tmp/sm_2.2-5.6.tar.gz \
/tmp/tmp/zoo_1.8-8.tar.gz \
/tmp/tmp/vioplot_0.3.5.tar.gz \
/tmp/tmp/SIMLR.R.installer.1.0.1.tar.gz \
/tmp/tmp/numDeriv_2016.8-1.1.tar.gz \
/tmp/tmp/SQUAREM_2021.1.tar.gz \
/tmp/tmp/TH.data_1.0-10.tar.gz \
/tmp/tmp/sandwich_3.0-0.tar.gz \
/tmp/tmp/lava_1.6.8.1.tar.gz \
/tmp/tmp/prodlim_2019.11.13.tar.gz \
/tmp/tmp/mvtnorm_1.0-8.tar.gz \
/tmp/tmp/multcomp_1.4-8.tar.gz \
/tmp/tmp/Publish_2018.04.17.tar.gz \
/tmp/tmp/Rtsne_0.13.tar.gz
