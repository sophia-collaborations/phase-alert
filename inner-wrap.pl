use argola;
use strict;

my $hme;
my $rsd;

my $starto;
my $endoso;

my $curro;
my $prevo;
my $remaino;

my $crownarg;
my $mid_scrip;
my $end_scrip;

#$crownarg = &argola::getrg;
$crownarg = 20;

$hme = $ENV{"HOME"};
$rsd = $hme . "/.chobak/phase-alert";
$mid_scrip = $rsd . "/pre-inform.sh";
$end_scrip = $rsd . "/end-inform.sh";


sub nowo {
  my $lc_a;
  $lc_a = `date +%s`; chomp($lc_a);
  return $lc_a;
}

$starto = &nowo;
$endoso = int($starto + ($crownarg * 60) + 0.2);
$prevo = "x";

sub karoon {
  my $lc_a;
  $lc_a = &nowo;
  $remaino = int( ($endoso - $lc_a) + 0.2 );
  $curro = 1;
  if ( $remaino > 60.5 ) { $curro = 2; }
  if ( $remaino > 120.5 ) { $curro = 3; }
  if ( $remaino > 180.5 ) { $curro = 4; }
  return ( $lc_a < $endoso );
}

while ( &karoon )
{
  if ( $prevo ne $curro )
  {
    system("sh",$mid_scrip);
  }
  system("echo",$remaino);
  &reportora;
  $prevo = $curro;
  sleep(6);
}

sub reportora {
  my $lc_min;
  my $lc_sec;
  my $lc_out;
  
  $lc_sec = ( $remaino % 60 );
  $lc_min = int( ( ( $remaino - $lc_sec ) / 60 ) + 0.2 );
  
  $lc_out = "Remaining: " . $lc_min . " minute";
  if ( $lc_min > 1.5 ) { $lc_out .= "s"; }
  if ( $lc_min < 0.5) { $lc_out .= "s"; }
  $lc_out .= " and " . $lc_sec . " second";
  if ( $lc_sec > 1.5 ) { $lc_out .= "s"; }
  if ( $lc_sec < 0.5) { $lc_out .= "s"; }
  $lc_out .= ":";
  
  system("echo",$lc_out);
}

exec("sh",$end_scrip);


