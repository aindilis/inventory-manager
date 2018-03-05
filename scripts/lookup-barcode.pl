#!/usr/bin/perl -w

use Inventory::Util::Barcode::Lookup;

$specification = q(
	-b <barcode>	Barcode to lookup
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $lookup = Inventory::Util::Barcode::Lookup->new();
$lookup->LookupBarcode(Barcode => $conf->{'-b'});
