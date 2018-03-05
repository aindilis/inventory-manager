#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

use JSON::Parse 'parse_json';

$specification = q(
	-b <barcode>		Barcode to search
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

if (! exists $conf->{'-b'}) {
  die "Need barcode to search\n";
}

my $upc = $conf->{'-b'};

my $filename = "/var/lib/myfrdcsa/codebases/minor/inventory-manager/data-git/barcodes/$upc/nutritionix.com/$upc.json";
if (! -f $filename) {
  MkDirIfNotExists(Directory => dirname($filename));
  system 'curl '.
    shell_quote("https://api.nutritionix.com/v1_1/item?upc=$upc&appId=$REDACTED&appKey=$REDACTED").
    ' -o '.
    shell_quote($filename);
}
if (-f $filename) {
  print "-----------------------------------------------------------------------\n";
  print "Filename: <$filename>\n";
  print "-----------------------------------------------------------------------\n";
  print "UPC: <$upc>\n";
  print "-----------------------------------------------------------------------\n";
  my $json = read_file($filename);
  my $perl = ParseJSON(JSON => $json);
  print Dumper({Perl => $perl});
  print "\n-----------------------------------------------------------------------\n";
  print "\n\n\n";
}

sub ParseJSON {
  my (%args) = @_;
  my $json = $args{JSON};
  my $perl = parse_json($json);
  print ClearDumper({Perl => $perl});
}
