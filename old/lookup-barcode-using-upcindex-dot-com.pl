#!/usr/bin/perl -w

use PerlLib::Cacher;
use PerlLib::SwissArmyKnife;

my $cacher = PerlLib::Cacher->new
  (
   Expires => 'never',
   CacheRoot => '/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/FileCache',
   MechanizedArgs => {
		      agent => 'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Safari/537.36.',
		     },
  );

my $barcode = '788821013149';

sub LookupBarcodeUsingUPCIndexDotCom {
  my (%args) = @_;
  my $barcode = $args{Barcode};
  if ($barcode =~ /^[0-9]+$/) {
    my $length = length($barcode);
    if (($length ==  10) or ($length ==  12)) {
      print "HI\n";
      my $uri = 'https://www.upcindex.com/'.$barcode;
      $cacher->delete($uri);
      my $tmp = $cacher->get($uri);
      my $content = $cacher->content;
      print Dumper
	({
	  Tmp => $tmp,
	  Content => $content,
	 });
      my $parsed = ParseUPCIndexDotComResults
	(
	 Tmp => $tmp,
	 Content => $content,
	);
      print Dumper($parsed);
    }
  }
}

sub ParseUPCIndexDotComResults {
  my (%args) = @_;
  return $args{Tmp};
}

LookupBarcodeUsingUPCIndexDotCom(Barcode => $barcode);
