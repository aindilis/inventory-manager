#!/usr/bin/perl -w

use PerlLib::Cacher;
use PerlLib::SwissArmyKnife;

my $barcode = '788821013149';

sub LookupBarcodeUsingUPCIndexDotCom {
  my (%args) = @_;
  my $barcode = $args{Barcode};
  if ($barcode =~ /^[0-9]+$/) {
    my $length = length($barcode);
    if (($length ==  10) or ($length ==  12)) {
      print "HI\n";
      my $uri = 'https://www.upcindex.com/'.$barcode;
      my $content = GetURI(URI => $uri);
      print Dumper
	({
	  Content => $content,
	 });
      my $parsed = ParseUPCIndexDotComResults
	(
	 Content => $content,
	);
      print Dumper($parsed);
    }
  }
}

sub GetURI {
  my (%args) = @_;
  my $command = 'w3m -dump_source '.$args{URI}.' | gunzip';
  print $command."\n";
  my $res = `$command`;
  return $res;
}

sub ParseUPCIndexDotComResults {
  my (%args) = @_;
  return $args{Content};
}

LookupBarcodeUsingUPCIndexDotCom(Barcode => $barcode);
