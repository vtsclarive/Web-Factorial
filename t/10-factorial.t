#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;
use Web::Factorial;
use Test::Fake::HTTPD;

plan tests => 2;

my $input_number = 3;
my $good_json = qq{ { "number": $input_number } };
my $bad_json  = qq{ { "number: $input_number } };

my $good_httpd = make_httpd( $good_json );
my $bad_httpd  = make_httpd( $bad_json );


my $fact = Web::Factorial->new(url => "http://" . $good_httpd->host_port . "/data");
ok($fact->result == 3*2, "calculate factorial");

my $bad_fact = Web::Factorial->new(url=>"http://" . $bad_httpd->host_port . "/data");
throws_ok { $bad_fact->result } qr/Failed to decode JSON data/, 'Bad JSON caught';


sub make_httpd {
	my ($content) = @_;
	my $httpd = Test::Fake::HTTPD->new( timeout => 5 );

	$httpd->run(
		sub {
			my ($req) = @_;
			return [ 200,  [ 'Content-Type' => 'text/plain' ], [ $content ] ];
		} 
	);

	return $httpd;
}

