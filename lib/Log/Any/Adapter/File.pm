use 5.008001;
use strict;
use warnings;

package Log::Any::Adapter::File;

# ABSTRACT: Simple adapter for logging to files
our $VERSION = '0.90'; # TRIAL

use IO::File;

use base qw/Log::Any::Adapter::Base/;

sub new {
    my ( $class, $file ) = @_;
    return $class->SUPER::new( file => $file );
}

sub init {
    my $self = shift;
    my $file = $self->{file};
    open( $self->{fh}, ">>", $file )
      or die "cannot open '$file' for append: $!";
    $self->{fh}->autoflush(1);
}

foreach my $method ( Log::Any->logging_methods() ) {
    no strict 'refs';
    *{$method} = sub {
        my ( $self, $text ) = @_;
        my $msg = sprintf( "[%s] %s\n", scalar(localtime), $text );
        $self->{fh}->print($msg);
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

Log::Any::Adapter::File - Simple adapter for logging to files

=head1 VERSION

version 0.90

=head1 SYNOPSIS

    use Log::Any::Adapter ('File', '/path/to/file.log');

    # or

    use Log::Any::Adapter;
    ...
    Log::Any::Adapter->set('File', '/path/to/file.log');

=head1 DESCRIPTION

This simple built-in L<Log::Any|Log::Any> adapter logs each message to the
specified file, with a datestamp prefix and newline appended. The file is
opened for append with autoflush on. Category and log level are ignored.

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
