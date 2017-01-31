package Web::Factorial;

use 5.006;
use strict;
use warnings FATAL => 'all';
use Moose;
use JSON::XS;
use LWP::UserAgent;
use Log::Log4perl qw(:easy);
use Carp qw(cluck);



has 'url'    => ( is => 'rw', isa => 'Str', required => 1 );
has 'number' => ( is => 'rw', isa => 'Int', builder => '_fetch', lazy => 1, required => 1);
has 'result' => ( is => 'rw', isa => 'Int', builder => '_calculate', lazy => 1, required => 1);


=head1 NAME

Web::Factorial - Calculates a factorial from a web API

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS


This module implements a simple access to the web factorial API. It does its
work in a lazy manner and only does the calculation when the result is actually
needed by the application.

Example:

    use Web::Factorial;

    my $fact = Web::Factorial->new( url => "http://example.com/get_number");
    print "The result is: " . $fact->result . "\n";
    ...

=head1 PROPERTIES

=head2 url

The URL to the web API. The query must return JSON data that contains a hash
with a 'numner' element within it.

=head2 number

The number of which the factorial is to be calculated. This is filled in from
the web API request.

The method is lazy; if it's never accessed, the request is never performed.

=head2 result

The resulting factorial

The method is lazy; if it's never accessed, the result is never calculated.

=head1 METHODS

=head2 refresh

Redo the API query and recalculate the result

=cut

sub refresh {
	my ($self) = @_;
	DEBUG "Refreshing";
	$self->number( $self->_fetch );
	$self->result( $self->_calculate );
}


sub _fetch {
	my ($self) = @_;

	DEBUG "Fetching data from " . $self->url;

	my $lwp = LWP::UserAgent->new();
	my $res = $lwp->get( $self->url );
	my $data;

	unless ( $res->is_success ) {
		die "Failed to GET " . $self->url . ": " . $res->status_line;
	}

	DEBUG "Parsing data";

	eval {
		$data = decode_json( $res->decoded_content );
	};
	if ( $@ ) {
		ERROR "Bad JSON data: '" . ($res->decoded_content//"") . "'";
		die "Failed to decode JSON data: $@";
	}

	# The JSON data must contain a hash with a 'number' element within it
	die "Number not found in JSON data" unless ( exists $data->{number} );

	return $data->{number};
}

sub _calculate {
	my ($self) = @_;
	DEBUG "Calculating";
	return _f($self->number);
}

sub _f {
	my ($num) = @_;
	return 1 if ($num <= 1);
	return $num * _f($num-1);
}



=head1 AUTHOR

Vadim Troshchinskiy Shmelev, C<< <me at vadim.ws> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-web-factorial at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Web-Factorial>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Web::Factorial


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Web-Factorial>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Web-Factorial>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Web-Factorial>

=item * Search CPAN

L<http://search.cpan.org/dist/Web-Factorial/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Vadim Troshchinskiy Shmelev.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>.


=cut

1; # End of Web::Factorial
