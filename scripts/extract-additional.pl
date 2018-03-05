#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

foreach my $file (split /\n/, `find /var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes | grep upcindex.com | grep -E '\.html\$'`) {
  if ($file =~ /\/var\/lib\/myfrdcsa\/codebases\/minor\/inventory-manager\/data-git\/barcodes\/(.+?)\//) {
    $barcode = $1;
    my $c = read_file($file);

    my @images = map {'http:'.$_} $c =~ /src="(\/\/.+?\.jpg)"/sg;
    my @items = $c =~ /<li itemprop="itemListElement"><span itemprop="name">(.+?)<\/span><ul>(.+?)<\/ul>/sg;
    my $suppliers = {};
    while (@items) {
      my $supplier = shift @items;
      my $linkshtml = shift @items;

      my $h = {};
      my $i = 0;

      my @links = $linkshtml =~ /.*?<a href="([^"]+?).*?">(.+?)<\/a>.*?/sg;
      while (@links) {
	my $link = shift @links;
	my $description = shift @links;

	if ($link =~ /^\/\//) {
	  $link = 'http:'.$link;
	}
	$h->{++$i} = {
		      Link => $link,
		      Desc => $desc,
		     };
      }
      $suppliers->{$supplier} = $h;
    }
    my $results = DownloadImages
      (
       Barcode => $barcode,
       Images => \@images,
      );
    print Dumper
      ({
	File => $file,
	Images => \@images,
	Results => $results,
       });
    # Suppliers => $suppliers,
  }
}

sub DownloadImages {
  my (%args) = @_;
  my $barcode = $args{Barcode};
  my $dir = "/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/$barcode/upcindex.com";
  if (-d $dir) {
    my $imagedir = ConcatDir($dir,'imagedir');
    MkDirIfNotExists(Directory => $imagedir);
    my @results;
    foreach my $uri (@{$args{Images}}) {
      if ($uri =~ /^(.*?):\/\/(.+?)$/) {
	$newfilename = $1.':/'.$2;
	my $newfilenameabs = ConcatDir($imagedir,$newfilename);
	if (! -f $newfilename) {
	  my $command = 'cd '.shell_quote($imagedir).' && curl --create-dirs -o '.shell_quote($uri).'  '.shell_quote($uri);
	  print $command."\n";
	  system $command;
	  sleep 3;
	}
	if (0 and ! -f $newfilename) {
	  die "Error <$newfilename> <$command>\n";
	}
	push @results,
	  {
	   File => $newfilenameabs,
	   URI => $uri,
	  };
      }
    }
    return \@results;
  }
  return [];
}
