use 5.008001;
use strict;
use warnings;

package Log::Any::Adapter::Stdout;

# ABSTRACT: Simple adapter for logging to STDOUT
our $VERSION = '0.91'; # TRIAL

use base qw/Log::Any::Adapter::Base/;

foreach my $method ( Log::Any->logging_methods() ) {
    no strict 'refs';
    *{$method} = sub {
        my ( $self, $text ) = @_;
        print STDOUT "$text\n";
      }
}

foreach my $method ( Log::Any->detection_methods() ) {
    no strict 'refs';
    *{$method} = sub { 1 };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::Adapter::Stdout - Simple adapter for logging to STDOUT

=head1 VERSION

version 0.91

=head1 SYNOPSIS

    use Log::Any::Adapter ('Stdout');

    # or

    use Log::Any::Adapter;
    ...
    Log::Any::Adapter->set('Stdout');

=head1 DESCRIPTION

This simple built-in L<Log::Any|Log::Any> adapter logs each message to STDOUT
with a newline appended. Category and log level are ignored.

=head1 SEE ALSO

L<Log::Any|Log::Any>, L<Log::Any::Adapter|Log::Any::Adapter>

=head1 AUTHORS

=over 4

=item *

Jonathan Swartz <swartz@pobox.com>

=item *

David Golden <dagolden@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jonathan Swartz and David Golden.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
