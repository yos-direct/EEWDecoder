# Earthquake-EEW-Decoder
高度利用者向け緊急地震速報コード電文フォーマットを扱う為のライブラリです。
このプログラムは @skubota 氏の Earthquake EEW_Decoder0.03 を元に作られました。
オリジナルのソースは http://search.cpan.org/~skubota/Earthquake_EEW_Decoder-0.03/ にあります。

###インストール
 perl Makefile.PL
 make
 make test
 make install

でインストールできます。

###動作確認

\#!/opt/local/bin/perl -w

use utf8;
use strict;
use warnings;
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
<<
my $d = $eew->read_data($data);
print Dumper $d;

##ライセンス
This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

##Copyright
Magistol
http://twitter.com/magistol
magistol@gmail.com