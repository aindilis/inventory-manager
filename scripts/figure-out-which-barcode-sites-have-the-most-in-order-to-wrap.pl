#!/usr/bin/perl -w

use System::WWW::Firefox::Cached;

my $firefox = System::WWW::Firefox::Cached->new();

foreach my $barcode (split /\n/, `ls /var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes`) {
  print "<$barcode>\n";
  # google search and get the urls of all matching sites
  $firefox->Get(URL => 'https://www.google.com/#safe=active&q='.$barcode);
}
