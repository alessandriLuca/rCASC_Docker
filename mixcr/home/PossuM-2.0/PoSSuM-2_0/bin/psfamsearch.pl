#!/usr/bin/env perl
use Getopt::Long;

# PSFAMSEARCH: Script for usage of possumsearch2 as a fast pre-filter for hmmsearch
# Prerequisite: Sequences to be searched have to be indexed with mkvtree


##########################################################################
#CHANGE THE FOLLOWING PATHES ACCORING TO YOUR LOCAL INSTALLATION


# path to possumsearch2 binary
my $possumsearch2="possumsearch";


# path to hmmsearch binary (tested version 2.3.1)
my $hmmsearch="hmmsearch";

##########################################################################




# Number of sequences in TREMBL Release 35.0: 3874166
# Needed for hmmsearch Evalue calculation
my $num_seqs=0; 


##########################################################################


my ($fammodel,
    $hmmodel,
    $filtered_seqs,
    $esaindex,
    $freq_file,
    $use_tc,
    $use_nc,
    $help,
    $outputfile);

my $num_params=$#ARGV;
my $hmm_cutoff;
my $possum_cutoff="";

GetOptions('pssmfm=s' => \$fammodel,  # PSSM family model file
	   'hmm=s'    => \$hmmodel, #Hidden Markov model file (HMMer 2 format)
	   'index=s' => \$esaindex, #Enhanced suffix array of target sequences
	   'seqtmp=s' => \$filtered_seqs, #output file for reduced search space
	   'freq=s' => \$freq_file, #background frequency file for p-value comp.
	   'trusted' => \$use_tc, #use trusted cutoffs 
	   'noise' => \$use_nc, #use noise cutoffs
	   'output=s' => \$outputfile, #hmmsearch output file
           'help|?|h' => \$help); # Help/Usage




# prints usage if invalid number of parameters are passed 
# or help option is passed
if ($help==1 or $num_params<7)
{
    usage()
}
        
checkparams(); 
get_num_of_sequences();

# Call possumsearch
print STDERR "#Calling: $possumsearch2 -db $esaindex -pr $fammodel -esa -lazy -freq $freq_file -modsearch 1 -format fasta  $possum_cutoff -q > $filtered_seqs\n";

system("$possumsearch2 -db $esaindex -pr $fammodel -esa -lazy -freq $freq_file -modsearch 1 -format fasta  $possum_cutoff -q > $filtered_seqs");




# Call hmmsearch on filtered sequence set
if ($outputfile) #output to file
{
    print STDERR "#Calling: $hmmsearch -A 0 -Z $num_seqs $cutoff $hmmodel $filtered_seqs >$outputfile\n";

    system("$hmmsearch -A 0 -Z $num_seqs $cutoff $hmmodel $filtered_seqs >$outputfile");
}
else # output to STDOUT
{
    print STDERR "#Calling: $hmmsearch -A 0 -Z $num_seqs $cutoff $hmmodel $filtered_seqs\n";

    system("$hmmsearch -A 0 -Z $num_seqs $cutoff $hmmodel $filtered_seqs");
}


#remove temporary sequence file
unlink($filtered_seqs);



sub usage
{
  print "Unknown option: @_\n" if ( @_ );
  print "usage: $0 --pssmfm PSSM-FM --hmm HMM --index INDEX --freq FREQ-FILE --seqtmp TMPFILENAME --trusted|--noise -output OUTFILENAME [--help|-?]\n";
  exit;
}


sub checkparams
{
    if (($use_nc==1) && ($use_tc==1))
    {
	die("Specify only one cutoff type: Either --trusted or --noise")
    }
    if ($use_nc==1)
    {
	$hmm_cutoff="--cut_nc";
	$possum_cutoff="-noise";
    }
    else
    {
	if ($use_tc==1)
	{
	    $cutoff="--cut_tc";
	    $possum_cutoff="-trusted";
	}
	else
	{
	    print"Use_nc: $use_nc\n";
	    print"Use_tc: $use_tc\n";
	    die("No cutoff type specified: Either --trusted or --noise are mandatory"); 
	}
    }
    if (!$fammodel)
    {
	die("No PSSM Family model specified! -pssmfm <PSSM-FM file> is mandatory\n");
    }
    if (!$hmmodel)
    {
	die("No PSSM hidden Markov model specified! -hmm <HMM-file> is mandatory\n");
    }
    if (!$esaindex)
    {
	die("No indexed sequence set specified! -index <ESA-index> is mandatory\n");
    }
    if (!$freq_file)
    {
	die("No background frequencies specified! -freq <possum-frequency file> is mandatory\n");
    }
}


# gets number of sequences from project file
sub get_num_of_sequences
{
    my $filename=$esaindex.".prj";
    open(PRJ,$filename) || die("cannot open file $!\n");
    while ($line=<PRJ>)
    {
	if ($line=~ /^numofsequences=(\d+)/)
	{
	    $num_seqs=$1;
	}
    }
    close(PRJ);
    if ($num_seqs==0) { die("could not determine number of sequences\n"); }
}
