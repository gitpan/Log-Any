use 5.008001;
use strict;
use warnings;

package Log::Any::Adapter::Null;

# ABSTRACT: Discards all log messages
our $VERSION = '0.91'; # TRIAL

use base qw/Log::Any::Adapter::Base/;

# Collect all logging and detection methods, including aliases and printf variants
#
my %aliases     = Log::Any->log_level_aliases;
my @alias_names = keys(%aliases);
my @all_methods = (
    Log::Any->logging_and_detection_methods(),
    @alias_names,
    ( map { "is_$_" } @alias_names ),
    ( map { $_ . "f" } ( Log::Any->logging_methods, @alias_names ) ),
);

# All methods are no-ops and return false
#
foreach my $method (@all_methods) {
    no strict 'refs';
    *{$method} = sub { return undef }; ## no critic: intentional explict undef ?!
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::Adapter::Null - Discards all log messages

=head1 VERSION

version 0.91

=head1 SYNOPSIS

    Log::Any::Adapter->set('Null');

=head1 DESCRIPTION

This Log::Any adapter discards all log messages and returns false for all
detection methods (e.g. is_debug). This is the default adapter when Log::Any is
loaded.

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
