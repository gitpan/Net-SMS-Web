package Net::SMS::Web;

use strict;

#------------------------------------------------------------------------------
#
# Standard pragmas
#
#------------------------------------------------------------------------------

require LWP::UserAgent;
use Net::SMS::Web::Action;
use CGI::Enurl;
use URI;
use Carp;

#------------------------------------------------------------------------------
#
# POD
#
#------------------------------------------------------------------------------

=head1 NAME

Net::SMS::Web - a generic module for sending SMS messages using web2sms
gateways (e.g. L<http://www.mtnsms.com/> or L<http://www.genie.co.uk/>).

=head1 DESCRIPTION

A perl module to send SMS messages, using web2sms gateways. This module
should be subclassed for a particular gateway (see L<Net::SMS::Genie> or
L<Net::SMS::Mtnsms>).

When you subclass this class, you need to make a series of calls to the
L<action> method, passing a L<Net::SMS::Web::Action> object which should
correspond to the web form acions that are required to send an SMS message via
the web gateway in question.

=cut

#------------------------------------------------------------------------------
#
# Package globals
#
#------------------------------------------------------------------------------

use vars qw( $VERSION $DEFAULT_AGENT );

$VERSION = '0.002';
$DEFAULT_AGENT = 'Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)';

=head1 CONSTRUCTOR

The constructor of this class can be overridden in a subclass as follows:

    sub new
    {
        my $class = shift;
        my $self = $class->SUPER::new( @_ );
        $self->_init( @_ );
        return $self;
    }

=cut

sub new
{
    my $class = shift;
    my $self = bless {}, $class;
    $self->{COOKIES} = [];
    return $self;
}

sub _get_cookies
{
    my $self = shift;

    push(
        @{$self->{COOKIES}},
        reverse grep s{;.*}{}, $self->{RESPONSE}->header( 'Set-Cookie' )
    );
}

sub _get_location
{
    my $self = shift;

    return $self->{RESPONSE}->header( 'Location' );
}

=head1 METHODS

=cut

=head2 action

This method takes an L<Net::SMS::Web::Action> object as an argument, and
performs the corresponding action. It takes care of retention of cookies set by
previous actions, and follows any redirection that result from the submission
of the action.

=cut

sub action
{
    my $self = shift;
    my $action = shift;

    croak "Action should be a Net::SMS::Web::Action object\n" 
        unless ref( $action ) eq 'Net::SMS::Web::Action'
    ;

    my $url = $action->url;
    my $method = $action->method || 'GET';
    my $agent = $action->method || $DEFAULT_AGENT;
    my $params = enurl $action->params;

    warn "$method $url ...\n" if $self->{verbose};
    my $request;

    if ( $method eq 'GET' )
    {
        $url .= "?$params" if $params;
        $request = HTTP::Request->new( $method, $url );
    }
    elsif ( $method eq 'POST' )
    {
        $request = HTTP::Request->new( $method, $url );
        $request->content( $params ) if $params;
        $request->content_type( 'application/x-www-form-urlencoded' );
    }
    else
    {
        croak "Unknown method $method - should be GET or POST\n";
    }

    $request->header( 'Accept' => 'text/html' );
    $request->header( 'Cookie' => join( ';', @{$self->{COOKIES}} ) )
        if $self->{COOKIES} and @{$self->{COOKIES}}
    ;
    warn $request->as_string() if $self->{verbose};
    my $ua = LWP::UserAgent->new;
    $ua->env_proxy();
    $ua->agent( $agent );
    $self->{RESPONSE} = $ua->simple_request( $request );
    warn $self->{RESPONSE}->headers_as_string() if $self->{verbose};
    if ( $self->{RESPONSE}->is_error )
    {
        croak
            ref($self), ": ", $request->uri,
            " failed:\n\t", 
            $self->{RESPONSE}->status_line, 
            "\n"
        ;
    }
    $self->_get_cookies();
    my $location = $self->_get_location();
    if ( $location )
    {
        return $self->action( 
            Net::SMS::Web::Action->new( 
                method  => 'GET',
                url     => URI->new_abs( $location, $action->url )
            )
        );
    }
}

#------------------------------------------------------------------------------
#
# More POD ...
#
#------------------------------------------------------------------------------

=head1 AUTHOR

Ave Wrigley <Ave.Wrigley@itn.co.uk>

=head1 COPYRIGHT

Copyright (c) 2001 Ave Wrigley. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms as Perl
itself.

=cut

1;
