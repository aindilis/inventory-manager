#!/usr/bin/perl -w

use BOSS::Config;
use PerlLib::SwissArmyKnife;

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
  my $c = read_file($conf->{'-f'});
  ProcessText(Args => $c);
}
