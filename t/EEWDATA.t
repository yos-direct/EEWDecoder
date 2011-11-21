# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl EEWDATA.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;
BEGIN { use_ok('Earthquake::EEW::Decoder') };

use Earthquake::EEW::Decoder;
my $eew;
ok $eew= Earthquake::EEW::Decoder->new();
$data = <<EoF;
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
my $d;
ok $d = $eew->read_data($data);

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

