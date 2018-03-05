#!/usr/bin/perl -w

use BOSS::Config;
use KBS2::ImportExport;
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

my $importexport = KBS2::ImportExport->new();

my $json = read_file($conf->{'-f'});
ParseJSON(JSON => $json);

sub ParseJSON {
  my (%args) = @_;
  my $json = $args{JSON};
  my $perl = parse_json($json);
  my @results;
  foreach my $key (keys %$perl) {
    if (! defined $perl->{$key}) {
      # ['neg',['knows','mealplanner',Var('X'),[$key,['idFn','nutritionix',$perl->{item_id}]]]]
    } else {
      my $interlingua = [$key,['idFn','nutritionix',$perl->{item_id}],$perl->{$key}];
      my $res1 = $importexport->Convert
	(
	 Input => [$interlingua],
	 InputType => 'Interlingua',
	 OutputType => 'Prolog',
	);
      if ($res1->{Success}) {
	push @results, $res1->{Output};
      } else {
	die Dumper({Error => $res1});
      }
    }
  }
  print join('',@results)."\n";
  # print ClearDumper({Perl => $perl});
}
