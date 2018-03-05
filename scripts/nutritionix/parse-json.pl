#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

use JSON::Parse 'parse_json';

$specification = q(
	-f <file>	  File to process
);

my $config =
  BOSS::Config->new
  (Spec => $specification);
my $conf = $config->CLIConfig;
# $UNIVERSAL::systemdir = "/var/lib/myfrdcsa/codebases/minor/system";

my $file = $conf->{'-f'};

if (! exists $conf->{'-f'}) {
  die "Must specify -f\n";
}

my $json = read_file($conf->{'-f'});
ParseJSON(JSON => $json);

sub ParseJSON {
  my (%args) = @_;
  my $json = $args{JSON};
  my $perl = parse_json($json);
  print ClearDumper({Perl => $perl});
}
