#!/opt/local/bin/perl -w

use utf8;
use strict;
use warnings;
use Time::Local;
use Earthquake::EEW::Decoder;
binmode( STDOUT, ":utf8" );
use Data::Dumper;
{
    package Data::Dumper;
    sub qquote { return shift; }
}
$Data::Dumper::Useperl = 1;

my $eew = Earthquake::EEW::Decoder->new();
my $data = <<EoF;
ﾅｳｷﾔｽﾄ3 ｷｼﾖｳ


37 03 00 110311144745 C11
110311144617
ND20110311144640 NCN012 JD////////////// JN///
288 N381 E1429 010 79 5+ RK66544 RT11/// RC0////
EBI 222 S5+5- ////// 11 220 S5+5- ////// 11 211 S5+5- ////// 11
213 S5-04 ////// 11 210 S5-04 ////// 11 221 S5-04 ////// 11
251 S5-04 ////// 11 250 S5-04 ////// 11 241 S0404 ////// 11
212 S0404 ////// 11 242 S0404 ////// 11 233 S0404 ////// 11
243 S0404 ////// 01 300 S0404 ////// 01 252 S0404 ////// 01
310 S0404 ////// 01 240 S0404 ////// 01 231 S0404 ////// 01
202 S0404 ////// 01 372 S0404 ////// 01 301 S0404 ////// 01
230 S0404 ////// 01 340 S0404 ////// 01 331 S0404 144749 00
360 S0404 144758 00 311 S0403 ////// 01 232 S0403 ////// 01
201 S0403 ////// 01 341 S0403 ////// 01 200 S0403 144746 00
371 S0403 144746 00 321 S0403 144747 00 330 S0403 144748 00
203 S0403 144752 00 350 S0403 144753 00
9999=
EoF

my $d = $eew->read_data($data);

my $before = &seconds( $d->{'warn_time'} ) - &seconds( $d->{'eq_time'} );
my $warn_time = sprintf "20%d%d/%d%d/%d%d %d%d:%d%d:%d%d",
  ( split //, $d->{'warn_time'} );
my $eq_time = sprintf "20%d%d/%d%d/%d%d %d%d:%d%d:%d%d",
  ( split //, $d->{'eq_time'} );

my $warn_num_f = '';
if ( $d->{'warn_num'} =~ /^9(\d\d)/ ) {
    $d->{'warn_num'} = $1 * 1;
    $warn_num_f = ' (最終報)';
}
my $str = '[第'
  . $d->{'warn_num'} . '報'
  . $warn_num_f . '] '
  . $d->{'center_name'} . ' 震度'
  . $d->{'shindo'} . ' '
  . $eq_time . '('
  . $before
  . '秒前)発生' . "\n";

$str .= '-地震ID:' . $d->{'eq_id'} . "\n";
$str .=
  '-発生時間:' . $eq_time . '(' . $before . '秒前)' . "\n";
$str .= '-発表時間:' . $warn_time . "\n";
$str .= sprintf("-震央 N%.1f/E%.1f(%s %s) %s 深さ%dkm\n",$d->{'center_lat'},$d->{'center_lng'}, $d->{'center_name'},$d->{'isSea'},$d->{'center_accurate'},$d->{'center_depth'});
$str .= sprintf("-最大: マグニチュード%.1f (%s)震度%s\n",$d->{'magnitude'} ,$d->{'magnitude_accurate'},$d->{'shindo'});

$str .= '-' . $d->{'EBI'}->{'name'} . "\n"  if ( $d->{'EBI'}->{'name'} );
foreach my $key ( keys %{ $d->{'EBI'} } ) {
    if ( $d->{'EBI'}->{$key}->{'name'} ) {
        my $reach_time = sprintf ("%s%s:%s%s:%s%s", ( split //, $d->{'EBI'}->{$key}->{'time'} ));
        my $arrive = '';
        $arrive = '(' . $d->{'EBI'}->{$key}->{'arrive'} . ')'  if ( $d->{'EBI'}->{$key}->{'arrive'} );
        $str .= '--'
          . $d->{'EBI'}->{$key}->{'name'}
          . ' 到達時間：'
          . $reach_time . ' '
          . $arrive
          . ' (' . $d->{'EBI'}->{$key}->{'isWarnded'} .')'
          . ' 予想震度:'
          . $d->{'EBI'}->{$key}->{'shindo2'} . '～'
          . $d->{'EBI'}->{$key}->{'shindo1'};
        $str .= "\n";
    }
}
print $str;
print Dumper $d;

# 残り時間を計算
sub seconds {
    my ($str) = @_;
    if ( $str =~ /(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/ ) {
        return timelocal( $6, $5, $4, $3, $2 - 1, $1 + 2000 );
    }
    else {
        return -1;
    }
}