package Net::SMS::Web::Action;
use Class::Struct;

struct(
    'Net::SMS::Web::Action' => {
        url     => '$',
        method  => '$',
        agent   => '$',
        params  => '%',
    }
);

#------------------------------------------------------------------------------

=head1 NAME

Net::SMS::Web::Action - a Class::Struct class for use with Net::SMS::Web
classes.

=head1 SYNOPSIS

    my $action = Net::SMS::Web::Action->new(
        url     => $url,
        params  => {
            foo => 'bar',
            baz => 'foobar',
        },
        method  => 'GET',
        agent   => 'myapp/1.0',
    );

    my $url = $action->url;
    $action->url( $new_url );

See <Class::Struct> for more details.

=head1 DESCRIPTION

This is a utility class for Net::SMS::Web classes. It is used to define a web
action in terms of a URL and some parameters.

=head1 AUTHOR

Ave Wrigley <Ave.Wrigley@itn.co.uk>

=head1 COPYRIGHT

Copyright (c) 2001 Ave Wrigley. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms as Perl
itself.

=cut

#------------------------------------------------------------------------------
#
# End of POD
#
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
#
# True ...
#
#------------------------------------------------------------------------------

1;
