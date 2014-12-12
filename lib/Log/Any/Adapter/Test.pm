use 5.008001;
use strict;
use warnings;

package Log::Any::Adapter::Test;

# ABSTRACT: Backend adapter for Log::Any::Test
our $VERSION = '0.90'; # TRIAL

use Data::Dumper;
use Log::Any;
use Test::Builder;

use base qw/Log::Any::Adapter::Base/;

my $tb = Test::Builder->new();
my @msgs;

# All detection methods return true
#
foreach my $method ( Log::Any->detection_methods() ) {
    no strict 'refs';
    *{$method} = sub { 1 };
}

# All logging methods push onto msgs array
#
foreach my $method ( Log::Any->logging_methods() ) {
    no strict 'refs';
    *{$method} = sub {
        my ( $self, $msg ) = @_;
        push(
            @msgs,
            {
                message  => $msg,
                level    => $method,
                category => $self->{category}
            }
        );
    };
}

# Testing methods below
#

sub msgs {
    my $self = shift;

    return \@msgs;
}

sub clear {
    my ($self) = @_;

    @msgs = ();
}

sub contains_ok {
    my ( $self, $regex, $test_name ) = @_;

    $test_name ||= "log contains '$regex'";
    my $found =
      _first_index( sub { $_->{message} =~ /$regex/ }, @{ $self->msgs } );
    if ( $found != -1 ) {
        splice( @{ $self->msgs }, $found, 1 );
        $tb->ok( 1, $test_name );
    }
    else {
        $tb->ok( 0, $test_name );
        $tb->diag( "could not find message matching $regex; log contains: "
              . $self->dump_one_line( $self->msgs ) );
    }
}

sub category_contains_ok {
    my ( $self, $category, $regex, $test_name ) = @_;

    $test_name ||= "log for $category contains '$regex'";
    my $found =
      _first_index(
        sub { $_->{category} eq $category && $_->{message} =~ /$regex/ },
        @{ $self->msgs } );
    if ( $found != -1 ) {
        splice( @{ $self->msgs }, $found, 1 );
        $tb->ok( 1, $test_name );
    }
    else {
        $tb->ok( 0, $test_name );
        $tb->diag(
            "could not find $category message matching $regex; log contains: "
              . $self->dump_one_line( $self->msgs ) );
    }
}

sub does_not_contain_ok {
    my ( $self, $regex, $test_name ) = @_;

    $test_name ||= "log does not contain '$regex'";
    my $found =
      _first_index( sub { $_->{message} =~ /$regex/ }, @{ $self->msgs } );
    if ( $found != -1 ) {
        $tb->ok( 0, $test_name );
        $tb->diag( "found message matching $regex: " . $self->msgs->[$found] );
    }
    else {
        $tb->ok( 1, $test_name );
    }
}

sub category_does_not_contain_ok {
    my ( $self, $category, $regex, $test_name ) = @_;

    $test_name ||= "log for $category contains '$regex'";
    my $found =
      _first_index(
        sub { $_->{category} eq $category && $_->{message} =~ /$regex/ },
        @{ $self->msgs } );
    if ( $found != -1 ) {
        $tb->ok( 0, $test_name );
        $tb->diag( "found $category message matching $regex: "
              . $self->msgs->[$found] );
    }
    else {
        $tb->ok( 1, $test_name );
    }
}

sub empty_ok {
    my ( $self, $test_name ) = @_;

    $test_name ||= "log is empty";
    if ( !@{ $self->msgs } ) {
        $tb->ok( 1, $test_name );
    }
    else {
        $tb->ok( 0, $test_name );
        $tb->diag( "log is not empty; contains "
              . $self->dump_one_line( $self->msgs ) );
        $self->clear();
    }
}

sub contains_only_ok {
    my ( $self, $regex, $test_name ) = @_;

    $test_name ||= "log contains only '$regex'";
    my $count = scalar( @{ $self->msgs } );
    if ( $count == 1 ) {
        local $Test::Builder::Level = $Test::Builder::Level + 1;
        $self->contains_ok( $regex, $test_name );
    }
    else {
        $tb->ok( 0, $test_name );
        $tb->diag( "log contains $count messages: "
              . $self->dump_one_line( $self->msgs ) );
    }
}

sub _first_index {
    my $f = shift;
    for my $i ( 0 .. $#_ ) {
        local *_ = \$_[$i];
        return $i if $f->();
    }
    return -1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::Adapter::Test - Backend adapter for Log::Any::Test

=head1 VERSION

version 0.90

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
