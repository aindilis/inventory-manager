#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

foreach my $dir (split /\n/, `ls -t1 /var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes`) {
  # print "<$dir>\n";
  foreach my $file (split /\n/, `find "/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/$dir" | grep -E '\.dat\$'`) {
    # print "<$file>\n";
    my $data = DeDumperFile($file);
    print Dumper($data);
    if (! exists $data->{productNameVariations}) {
      print "Hi\n";
    } else {
      foreach my $item (@{$data->{productNameVariations}}) {
	if (defined $item) {
	  print $item."\n";
	  last;
	}
      }
    }
  }
  if (! -d "/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/$dir/buycott.com") {
    print "buycott.com\n";
    # system `cd /var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/$dir && wget -x https://buycott.com/upc/$dir`;

    # ERROR 429: Too Many Requests
    # GetSignalFromUserToProceed();
  }
}
