package Inventory::Util::Barcode::Lookup;

use BOSS::Config;
use Inventory::Util::Barcode::Parser;
use MyFRDCSA;
use PerlLib::Cacher;
use PerlLib::SwissArmyKnife;
use PerlLib::ToText;

use Moose;

has ToText =>
  (
   is => 'rw',
   isa => 'PerlLib::ToText',
   default => sub {
     PerlLib::ToText->new();
   }
  );

has Directory =>
  (
   is => 'rw',
   isa => 'Str',
   default => "/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes",
  );

has Parser =>
  (
   is => 'rw',
   isa => 'Inventory::Util::Barcode::Parser',
   default => sub {
     Inventory::Util::Barcode::Parser->new();
   },
  );


sub BUILD {
  my ($self,$args) = @_;
  MkDirIfNotExists(Directory => $self->Directory);
}

sub LookupBarcode {
  my ($self,%args) = @_;
  return $self->LookupBarcodeUsingSource(Source => 'upcindex.com',%args);
}

sub LookupBarcodeUsingSource {
  my ($self,%args) = @_;
  my $source = $args{Source};
  my $barcode = $args{Barcode};
  if ($barcode =~ /^[0-9]+$/) {
    my $length = length($barcode);
    if (($length ==  10) or ($length ==  12)) {
      my $barcodedir = ConcatDir($self->Directory,$barcode,$source);
      if (! -d $barcodedir) {
	MkDirIfNotExists(Directory => $barcodedir);

	my $uri = 'https://www.upcindex.com/'.$barcode;
	my $content = $self->GetURI(URI => $uri);

	WriteFile
	  (
	   File => ConcatDir($self->Directory,$barcode,$source,$barcode.'.html'),
	   Contents => $content,
	  );

	my $res1 = $self->ToText->ToText(String => $content);
	if ($res1->{Success}) {
	  my $text = $res1->{Text};
	  WriteFile
	    (
	     File => ConcatDir($self->Directory,$barcode,$source,$barcode.'.txt'),
	     Contents => $text,
	    );

	  my $res2 = $self->Parser->ParseText
	    (
	     Source => 'upcindex.com',
	     Text => $text,
	    );
	  if ($res2->{Success}) {
	    WriteFile
	      (
	       File => ConcatDir($self->Directory,$barcode,$source,$barcode.'.dat'),
	       Contents => Dumper($res2->{Results}),
	      );
	    return
	      {
	       Success => 1,
	       Results => $res2->{Results},
	      };
	  }
	}
      } else {
	print "Using cached\n";
	my $file = ConcatDir($self->Directory,$barcode,$source,$barcode.'.txt');
	if (-f $file) {
	  my $text = read_file($file);
	  my $res2 = $self->Parser->ParseText
	    (
	     Source => 'upcindex.com',
	     Text => $text,
	    );
	  if ($res2->{Success}) {
	    WriteFile
	      (
	       File => ConcatDir($self->Directory,$barcode,$source,$barcode.'.dat'),
	       Contents => Dumper($res2->{Results}),
	      );
	    return
	      {
	       Success => 1,
	       Results => $res2->{Results},
	      };
	  }
	}
      }
    }
  }
  return
    {
     Success => 0,
    };
}

sub GetURI {
  my ($self,%args) = @_;
  my $command = 'w3m -dump_source '.$args{URI}.' | gunzip';
  print $command."\n";
  my $res = `$command`;
  return $res;
}

sub ParseUPCIndexDotComResults {
  my ($self,%args) = @_;
  return $args{Content};
}

1;
