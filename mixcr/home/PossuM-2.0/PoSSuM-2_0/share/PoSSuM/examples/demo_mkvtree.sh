#! /bin/sh
#
# demo_mkvtree.sh
#
# This file is part of the PoSSuM software distribution (see
# http://bibiserv.techfak.uni-bielefeld.de/possumsearch/).
#
# This file is public domain; you can distribute and/or modify it without
# any restrictions. The copyright holders of the PoSSuMsearch software
# distribution cannot be held responsible for anything done with this
# file.
#

#
# Working directory for this demo. Note that the temporary directory is not
# removed after the demonstration to give you a chance for taking a closer
# look at its content. Delete it manually if not needed anymore.
#
TMPDIR="/tmp/PoSSuMdemo"

ESAPROG="mkvtree"

#
# Change EXTRA to the directory the executables are installed in if this
# script doesn't work for you.
#
EXTRA=../../../bin
POSSUMFREQS="${EXTRA}/possumfreqs"
POSSUMDIST="${EXTRA}/possumdist"
POSSUMSEARCH="${EXTRA}/possumsearch"

# Show error message and terminate.
quit()
{
  errcode=$?
  echo
  if test -n "$1"
  then
    echo "Error ${errcode}: $1"
  else
    echo "Error ${errcode}, terminating."
  fi
  exit ${errcode}
}

# Make temporary directory if not already there.
if test ! -d "${TMPDIR}"
then
  mkdir -p "${TMPDIR}" || quit "Failed to create directory ${TMPDIR}."
fi


# ,-----------------------------------.
# | Actual demonstration starts here. |
# `-----------------------------------'

# Build an enhanced suffix array using the predefined protein alphabet from
# our little Fasta file.
${ESAPROG} -db demo.fas -indexname ${TMPDIR}/demoesa -protein -tis -suf -lcp -skp || quit "Failed to build enhanced suffix array in ${TMPDIR}"

# Determine relative character frequencies from enhanced suffix array for
# probability calculation. Note that the Fasta file could also be used for
# this (but then -protein would also be required).
${POSSUMFREQS} -db ${TMPDIR}/demoesa -qw > ${TMPDIR}/demo.freqs || quit "Failed to determine relative frequencies from database ${TMPDIR}/demoesa."

# Search for 17 PSSMs stored in demo.lib in our demo database which contains
# two sequences. We use a p-value cutoff of 1e-10 and expect to find 18
# matches (one of the PSSMs should be found twice). Results are written to
# stdout and should be the same for all runs (if they are not, please issue a
# bug report!). The file results.txt is included to check if your results are
# the same as intended.
#
# First we use the lazy probability distribution calculation for determining
# the score thresholds, using the frequencies just determined from the
# sequence. This is done three times on the previously built enhanced suffix
# array, first using ESAsearch, second using LAsearch, third using simple
# search. Then the search is repeated two times on the Fasta file without
# help of an index, once for LAsearch, once for simple search.
${POSSUMSEARCH} -db ${TMPDIR}/demoesa -esa -pr demo.lib -pval 1e-10 -lazy -freq ${TMPDIR}/demo.freqs -qw || quit "Failed to search demo.lib in ${TMPDIR}/demoesa via ESAsearch, lazy."
${POSSUMSEARCH} -db ${TMPDIR}/demoesa -lahead -pr demo.lib -pval 1e-10 -lazy -freq ${TMPDIR}/demo.freqs -qw || quit "Failed to search demo.lib in ${TMPDIR}/demoesa via LAsearch, lazy."
${POSSUMSEARCH} -db ${TMPDIR}/demoesa -simple -pr demo.lib -pval 1e-10 -lazy -freq ${TMPDIR}/demo.freqs -qw || quit "Failed to search demo.lib in ${TMPDIR}/demoesa via simple search, lazy."
${POSSUMSEARCH} -db demo.fas -protein -lahead -pr demo.lib -pval 1e-10 -lazy -freq ${TMPDIR}/demo.freqs -qw || quit "Failed to search demo.lib in demo.fas via LAsearch, lazy."
${POSSUMSEARCH} -db demo.fas -protein -simple -pr demo.lib -pval 1e-10 -lazy -freq ${TMPDIR}/demo.freqs -qw || quit "Failed to search demo.lib in demo.fas via simple search, lazy."

# Precalculate probability distribution for PSSMs using the frequencies just
# determined from the sequence the PSSMs are to be searched in.
${POSSUMDIST} -pr demo.lib -protein -freq ${TMPDIR}/demo.freqs -pdis ${TMPDIR}/demo.pdis -qw || quit "Failed to precalculate probability distribution from demo.lib."

# Now repeat exactly the same five searches as above, but read the PSSMs'
# probability distributions from file to determine the score thresholds.
# Again, results should be the same as above.
${POSSUMSEARCH} -db ${TMPDIR}/demoesa -esa -pr demo.lib -pval 1e-10 -pdis ${TMPDIR}/demo.pdis -qw || quit "Failed to search demo.lib in ${TMPDIR}/demoesa via ESAsearch, precalculated."
${POSSUMSEARCH} -db ${TMPDIR}/demoesa -lahead -pr demo.lib -pval 1e-10 -pdis ${TMPDIR}/demo.pdis -qw || quit "Failed to search demo.lib in ${TMPDIR}/demoesa via LAsearch, precalculated."
${POSSUMSEARCH} -db ${TMPDIR}/demoesa -simple -pr demo.lib -pval 1e-10 -pdis ${TMPDIR}/demo.pdis -qw || quit "Failed to search demo.lib in ${TMPDIR}/demoesa via simple search, precalculated."
${POSSUMSEARCH} -db demo.fas -protein -lahead -pr demo.lib -pval 1e-10 -pdis ${TMPDIR}/demo.pdis -qw || quit "Failed to search demo.lib in demo.fas via LAsearch, precalculated."
${POSSUMSEARCH} -db demo.fas -protein -simple -pr demo.lib -pval 1e-10 -pdis ${TMPDIR}/demo.pdis -qw || quit "Failed to search demo.lib in demo.fas via simple search, precalculated."
