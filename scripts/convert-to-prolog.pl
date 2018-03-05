#!/usr/bin/perl -w

use KBS2::ImportExport;
use PerlLib::SwissArmyKnife;

my $importexport = KBS2::ImportExport->new();

my $debug = 0;
my $barcode = "072392352425";
my $file = "/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/$barcode/upcindex.com/$barcode.dat";

print Dumper({File => $file}) if $debug;

my @assertions;

my $h = DeDumperFile($file);
foreach my $key (keys %$h) {
  my $predicate = $key;
  $predicate = 'has'.CaptializeFirstCharacter($predicate);
  my $ref = ref($h->{$key});
  if ($ref eq '') {
    push @assertions, [$predicate,['productHavingBarcodeFn',$barcode],$h->{$key}];
  } elsif ($ref eq 'ARRAY') {
    print Dumper({Ref => $ref}) if $debug;
    print Dumper($h->{$key}) if $debug;
    foreach my $value (@{$h->{$key}}) {
      push @assertions, [$predicate,['productHavingBarcodeFn',$barcode],$value];
    }
  }
}

foreach my $assertion (@assertions) {
  my $res1 = $importexport->Convert
    (
     Input => [$assertion],
     InputType => 'Interlingua',
     OutputType => 'Prolog',
    );
  if ($res1->{Success}) {
    print $res1->{Output};
  } else {
    print "error\n";
  }
}

sub CaptializeFirstCharacter {
  my ($text) = @_;
  my @l = split //, $text;
  $l[0] = uc($l[0]);
  return join("",@l);
}
