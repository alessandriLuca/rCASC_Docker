FROM library/ubuntu:18.04 as UBUNTU_BASE
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="sandro.contaldo@edu.unito.it"

COPY /R-3.4.4 /tmp/
COPY "*.tar.gz" /tmp/

RUN apt-get update \
    && apt-get install -y build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev \
    && apt-get install -y gfortran \
    && apt-get install -y xorg-dev \
    && apt-get install -y aptitude \
    && apt-get install -y libbz2-dev \
    && apt-get install liblzma-dev \
    && apt-get install -y libpcre++-dev \
    && apt-get install -y libcurl4-openssl-dev \
    && aptitude install -y libreadline-dev \
    && apt-get -y install tcl-dev tk-dev \
    && chmod +x /tmp/configure \
    && /tmp/configure --with-tcltk --with-tcl-config=/usr/lib/tclConfig.sh --with-tk-config=/usr/lib/tkConfig.sh\
    && make

RUN R CMD INSTALL --build /tmp/sm_2.2-5.5.tar.gz \
    && R CMD INSTALL --build /tmp/argparser_0.4.tar.gz \
    && R CMD INSTALL --build /tmp/zoo_1.8-3.tar.gz \
    && R CMD INSTALL --build /tmp/vioplot_0.3.4.tar.gz \
    && R CMD INSTALL --build /tmp/bitops_1.0-6.tar.gz \
    && R CMD INSTALL --build /tmp/caTools_1.17.1.1.tar.gz \
    && R CMD INSTALL --build /tmp/gtools_3.8.1.tar.gz \
    && R CMD INSTALL --build /tmp/gdata_2.18.0.tar.gz \
    && R CMD INSTALL --build /tmp/gplots_3.0.1.2.tar.gz \
    && R CMD INSTALL --build /tmp/ROCR_1.0-7.tar.gz

RUN R CMD INSTALL --build /tmp/Rcpp_1.0.3.tar.gz \
    && R CMD INSTALL --build /tmp/Rtsne_0.15.tar.gz \
    && R CMD INSTALL --build /tmp/RColorBrewer_1.1-2.tar.gz \
    && R CMD INSTALL --build /tmp/clusterCrit_1.2.8.tar.gz \
    && R CMD INSTALL --build /tmp/data.table_1.12.8.tar.gz \
    && R CMD INSTALL --build /tmp/iterators_1.0.12.tar.gz \
    && R CMD INSTALL --build /tmp/foreach_1.4.7.tar.gz \
    && R CMD INSTALL --build /tmp/doParallel_1.0.15.tar.gz \
    && R CMD INSTALL --build /tmp/flashClust_1.01-2.tar.gz

RUN R CMD INSTALL --build /tmp/farver_2.0.3.tar.gz \
    && R CMD INSTALL --build /tmp/labeling_0.3.tar.gz \
    && R CMD INSTALL --build /tmp/colorspace_1.4-1.tar.gz \
    && R CMD INSTALL --build /tmp/munsell_0.5.0.tar.gz \
    && R CMD INSTALL --build /tmp/R6_2.4.1.tar.gz \
    && R CMD INSTALL --build /tmp/viridisLite_0.3.0.tar.gz \
    && R CMD INSTALL --build /tmp/glue_1.3.1.tar.gz \
    && R CMD INSTALL --build /tmp/rlang_0.4.4.tar.gz \
    && R CMD INSTALL --build /tmp/lifecycle_0.1.0.tar.gz \
    && R CMD INSTALL --build /tmp/scales_1.1.0.tar.gz

RUN R CMD INSTALL --build /tmp/gtable_0.3.0.tar.gz \
    && R CMD INSTALL --build /tmp/pheatmap_1.0.12.tar.gz \
    && R CMD INSTALL --build /tmp/digest_0.6.23.tar.gz \
    && R CMD INSTALL --build /tmp/lazyeval_0.2.2.tar.gz \
    && R CMD INSTALL --build /tmp/plyr_1.8.5.tar.gz \
    && R CMD INSTALL --build /tmp/magrittr_1.5.tar.gz \
    && R CMD INSTALL --build /tmp/stringi_1.4.5.tar.gz \
    && R CMD INSTALL --build /tmp/stringr_1.4.0.tar.gz \
    && R CMD INSTALL --build /tmp/reshape2_1.4.3.tar.gz

RUN R CMD INSTALL --build /tmp/crayon_1.3.4.tar.gz \
    && R CMD INSTALL --build /tmp/fansi_0.4.1.tar.gz \
    && R CMD INSTALL --build /tmp/assertthat_0.2.1.tar.gz \
    && R CMD INSTALL --build /tmp/cli_2.0.1.tar.gz \
    && R CMD INSTALL --build /tmp/utf8_1.1.4.tar.gz \
    && R CMD INSTALL --build /tmp/ellipsis_0.3.0.tar.gz \
    && R CMD INSTALL --build /tmp/vctrs_0.2.2.tar.gz \
    && R CMD INSTALL --build /tmp/pillar_1.4.3.tar.gz \
    && R CMD INSTALL --build /tmp/pkgconfig_2.0.3.tar.gz \
    && R CMD INSTALL --build /tmp/tibble_2.1.3.tar.gz

RUN R CMD INSTALL --build /tmp/withr_2.1.2.tar.gz \
    && R CMD INSTALL --build /tmp/ggplot2_3.2.1.tar.gz \
    && R CMD INSTALL --build /tmp/gridExtra_2.3.tar.gz \
    && R CMD INSTALL --build /tmp/viridis_0.5.1.tar.gz \
    && R CMD INSTALL --build /tmp/clues_0.6.2.2.tar.gz

RUN R CMD INSTALL --build /tmp/SHARP-1.1.0.tar.gz

COPY home/* /home/

RUN R CMD INSTALL --build /tmp/numDeriv_2016.8-1.tar.gz \
    && R CMD INSTALL --build /tmp/SQUAREM_2017.10-1.tar.gz \
    && R CMD INSTALL --build /tmp/lava_1.6.3.tar.gz \
    && R CMD INSTALL --build /tmp/mvtnorm_1.0-8.tar.gz \
    && R CMD INSTALL --build /tmp/sandwich_2.5-0.tar.gz \
    && R CMD INSTALL --build /tmp/TH.data_1.0-9.tar.gz \
    && R CMD INSTALL --build /tmp/prodlim_2018.04.18.tar.gz \
    && R CMD INSTALL --build /tmp/multcomp_1.4-8.tar.gz \
    && R CMD INSTALL --build /tmp/Publish_2019.12.04.tar.gz
