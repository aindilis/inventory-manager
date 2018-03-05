package Inventory::Util::Barcode::Parser;

use BOSS::Config;
use PerlLib::SwissArmyKnife;

use Moose;

has Templates =>
  (
   is => 'rw',
   isa => 'HashRef',
   default => sub {
     return
       {
	upc => [qr/^UPC (.+?)[\n\r]/sm,1],
	productName => [qr/UPC number .+? is associated with (.+?)[\n\r]/sm,1],
	productDescription => [qr/UPC number .+? is associated with .+?[\n\r](.+?)[\n\r]/sm,1],
	productNameVariations => [qr/Product Name Variations\s+(.+?)\s+GS1 \/ GTIN Registration/sm,1],
	upcA => [qr/UPC-A\s+([\d\s]+?)[\n\r]/sm,1],
	ean13 => [qr/EAN-13\s+([\d\s]+?)[\n\r]/sm,1],
	upc => [qr/UPC\s+([\d\s]+?)[\n\r]/sm,1],
	gtin => [qr/GTIN\s+([\d\s]+?)[\n\r]/sm,1],
	gtin14 => [qr/GTIN-14\s+([\d\s]+?)[\n\r]/sm,1],
	countryOfRegistration => [qr/Country of registration\s+(.+?)[\n\r]/sm,1],
	gs1GTINRegistration => [qr/GS1 \/ GTIN Registration\s+(.+?)\s+\d+ visitors? ha(s|ve) found this accurate/sm,1],
       }
     }
  );

has Parsers =>
  (
   is => 'rw',
   isa => 'HashRef',
   default => sub {
     return
       {
	productNameVariations => sub {[map {$_ =~ s/^.*?\. //; $_} split /\n/, $_[0]]},
	gs1GTINRegistration => sub {
	  my $lines = {};
	  my $key;
	  foreach my $line (split /\n/, $_[0]) {
	    if ($line =~ /^\s/) {
	      $line =~ s/\s*//;
	      push @{$lines->{$key}}, $line;
	    } else {
	      $key = $line;
	      $lines->{$key} = [];
	    }
	  }
	  my $newlines = {};
	  foreach my $key (keys %$lines) {
	    if ((scalar @{$lines->{$key}}) == 1) {
	      $newlines->{$key} = $lines->{$key}[0];
	    } else {
	      $newlines->{$key} = $lines->{$key};
	    }
	  }
	  return $newlines;
	},
       };
   },
  );

sub ParseText {
  my ($self,%args) = @_;
  # my $source = $args{Source};
  my $c = $args{Text};
  my $res2 = $self->ParseUPCDump(Contents => $c);
  my $res4 = {};
  if ($res2->{Success}) {
    my $res3 = $res2->{Results};
    foreach my $key (keys %$res3) {
      $res4->{$key} = $self->ParseParser
	(
	 Key => $key,
	 Value => $res3->{$key},
	);
    }
  }
  return
    {
     Success => 1,
     Results => $res4,
    };
}

sub ParseUPCDump {
  my ($self,%args) = @_;
  my $c = $args{Contents};
  my $results = {};
  foreach my $templatename (keys %{$self->Templates}) {
    my $template = $self->Templates->{$templatename};
    my $regex = $template->[0];
    my $res = {};
    my $ref = ref($template->[1]);

    $c =~ $regex;
    if ($ref eq '') {
      $results->{$templatename} = eval '$'.$template->[1];
    } else {
      foreach my $index (@{$template->[1]}) {
	$res->{$index} = ${$index};
      }
      $results->{$templatename} = $res;
    }
  }
  return
    {
     Success => 1,
     Results => $results,
    };
}

sub ParseParser {
  my ($self,%args) = @_;
  if (exists $self->Parsers->{$args{Key}}) {
    return &{$self->Parsers->{$args{Key}}}($args{Value});
  } else {
    return $args{Value};
  }
}

1;
