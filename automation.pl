#!/usr/bin/perl

use strict;
use warnings;
use threads;

use Thread::Queue;

our $nthreads = 5;

our $process_q = Thread::Queue -> new();

our $filename = '/home/saikrishna/Downloads/download.txt';

open(our $input_fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";

$process_q -> enqueue ( <$input_fh> );

close ( $input_fh );

$process_q -> end();

for ( 1..$nthreads )
{
  threads -> create ( \&worker );
}

foreach our $thr ( threads -> list() )
{
  $thr -> join();
}

################################################## Sub-routine Worker ###########################################################################################################
sub worker
{

  while ( our $server = $process_q -> dequeue() )
  {
     chomp ( $server );
     our $linux = "wget $server -P /home/saikrishna/Downloads/extract ";
     system $linux;
     our @name = split '/' , $server;
     our $laststr = $name[-1];
     our $strname="'" . "/home/saikrishna/Downloads/extract/" .  "$laststr" . "'";

     our $folder = "/home/saikrishna/Downloads/extract/";
     our $unzip = " tar -zxf $strname -C $folder"; 
     system $unzip;

     our $remove = "rm $strname";
     system $remove;

     our @inside = split '\.' , $laststr;
     our $onlyname = $inside[0];
     our $dirwithonlyname ="'" . $folder."$onlyname". "'" ;
    
     our @files = glob "$dirwithonlyname/*.nxml";

     for (0..$#files)
     {
       perlscript($files[$_])
     }

     our $removedir = "rm -r $dirwithonlyname";
     system $removedir;
  }
}

 
###################################################### Sub routine perlscript #####################################################################################################

sub perlscript {
use strict;
use warnings;
use XML::LibXML;
use XML::LibXML::Iterator;

our $filename = @_[0];

our $dom = XML::LibXML->load_xml(location => $filename);

our $docelement =$dom->documentElement;

our $rand=int(rand() *10000000000);

our $outputfolder = "/home/saikrishna/Downloads/PMC/";

our $outfile  = $outputfolder. "$rand" . "_" . "affdate"  . ".txt";

our $outfile1 = $outputfolder. "$rand" . '.txt';

open(our $fh, '>', $outfile) or die "could not open'$outfile' ";

open(our $fh1, '>', $outfile1) or die "could not open'$outfile1' ";

our $flag1 = 0;

our $flag2 = 0;

sub process_node {

	our $node = shift;

	if (($node->nodeName) eq  'aff')
        {
	  our $out = $node->to_literal();
	  print $fh $out,"\n";
	  $flag1 = $flag1+1;
        }

        if (($node->nodeName) eq 'pub-date'and ($node->getAttribute('pub-type')) eq 'epub' and $flag1 !=0)
        {  
           our $date = '';
           our @children = $node->childNodes();
           foreach our $child(@children)
           {
             $date = $date . $child->to_literal();
             $date = $date . '-';
           }

          print $fh substr($date,0,-1),"\n";
          print $fh "----","\n";
          $flag2 = $flag2+1;
        }
      
        if ($flag1!=0 and $flag2!=0)
	{
	  print $fh1 $node->to_literal(),"\n";
	}
	       

    for our $child ($node->childNodes) {
        process_node($child);
    }

}

process_node($docelement);

our $javaArgs = " -cp /home/saikrishna/Downloads/stanford-ner-2018-02-27:/home/saikrishna/Downloads/stanford-ner-2018-02-27/access-bridge-64.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/joda-time.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/stanford-ner-3.9.1.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/stanford-ner-resources.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/stanford-ner-3.9.1-javadoc.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/sunmscapi.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/jfr.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/stanford-ner-3.9.1-sources.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/jfxrt.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/stanford-ner.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/stanford-english-corenlp-2018-02-27-models.jar:/home/saikrishna/Downloads/stanford-ner-2018-02-27/jfxrt.jar";

our $className = "prac";

our $javaoutput = $outputfolder. "$rand" . '_' . 'out' . '.txt';;

@ARGV = ( $outfile1, $javaoutput);

our $javaCmd = "java ". $javaArgs ." " . $className . " " . join(' ', @ARGV);

our $ret =system("$javaCmd");

our $linux = "cat  $javaoutput >> $outfile";

system $linux;

close  $fh or die "could not close'$outfile' ";
close $fh1 or die "could not close'$outfile1' ";

unlink $javaoutput;
unlink $outfile1;

}


 
