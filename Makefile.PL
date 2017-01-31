use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Web::Factorial',
    AUTHOR           => q{Vadim Troshchinskiy Shmelev <me@vadim.ws>},
    VERSION_FROM     => 'lib/Web/Factorial.pm',
    ABSTRACT_FROM    => 'lib/Web/Factorial.pm',
    LICENSE          => 'gpl_3',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'         => 0,
	'Test::Exception'    => 0,
	'Test::Fake::HTTPD'  => 0,
    },
    PREREQ_PM => {
	    'Moose'          => 0,
	    'JSON::XS'       => 0,
	    'LWP::UserAgent' => 0,
	    'Log::Log4perl'  => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Web-Factorial-*' },
);

