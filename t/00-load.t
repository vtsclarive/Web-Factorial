#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Web::Factorial' ) || print "Bail out!\n";
}

diag( "Testing Web::Factorial $Web::Factorial::VERSION, Perl $], $^X" );
