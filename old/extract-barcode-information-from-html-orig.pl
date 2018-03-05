#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use PerlLib::ToText;

my $data = DeDumperFile('/var/lib/myfrdcsa/codebases/minor/inventory-manager/scripts/dump.dat');

my $totext = PerlLib::ToText->new();

my $extractiontemplateshashoflists =
  {
   productName => [qr/UPC number .+? is associated with (.+?)[\n\r]/sm,[1]],
   productName2 => [qr/UPC number .+? is associated with (.+?)[\n\r]/sm,1],
  };

my $extractiontemplateshashofhashes =
  {
   upc => {
	   Regex => qr/^UPC (.+?)[\n\r]/sm,
	   Index => 1,
	  },
   productName3 => {
		    Regex => qr/UPC number (.+?) is associated with (.+?)[\n\r]/,
		    Indexes => [1,2],
		   },
  };

sub ParseUPCDump {
  my (%args) = @_;
  my $c = $args{Contents};
  my $results = {};
  foreach my $templatename (keys %$extractiontemplateshashofhashes) {
    my $template = $extractiontemplateshashofhashes->{$templatename};
    my $regex = $template->{Regex};
    $c =~ $regex;
    if ($template->{Index}) {
      $results->{$templatename} = ${$template->{Index}};
    } elsif ($template->{Indexes}) {
      my $res = {};
      foreach my $index (@{$template->{Indexes}}) {
	$res->{$index} = ${$index};
      }
      $results->{$templatename} = $res;
    }
  }
  foreach my $templatename (keys %$extractiontemplateshashoflists) {
    my $template = $extractiontemplateshashoflists->{$templatename};
    my $regex = $template->[0];
    $c =~ $regex;
    my $res = {};
    my $ref = ref($template->[1]);
    if ($ref eq '') {
      $results->{$templatename} = ${$template->[1]};
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

my $res1 = $totext->ToText(String => $data);
if ($res1->{Success}) {
  my $c = $res1->{Text};
  my $res2 = ParseUPCDump(Contents => $c);
  print Dumper($res2);
}
