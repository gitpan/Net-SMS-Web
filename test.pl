#!/usr/bin/perl

#------------------------------------------------------------------------------
#
# Standard pragmas
#
#------------------------------------------------------------------------------

use strict;
require v5.6.0;

use Term::ReadKey;
use Net::SMS::Genie;
use Net::SMS::Mtnsms;

print "1..1\n";

$|++;

my %prompt = (
    module => "Enter SMS service (Mtnsms / Genie): ",
    username => "Enter username: ",
    password => "Enter password: ",
    recipient => "Enter recipient mobile number: ",
    message => "Enter an SMS message: ",
);

my %args;

for ( qw( module username password recipient message ) )
{
    ReadMode 'noecho' if $_ eq 'password';
    print $prompt{$_}; 
    chomp( my $response = <> );
    $args{$_} = $response;
    if ( $_ eq 'password' )
    {
        print "\n";
        ReadMode 'normal';
    }
}

eval {
    my $module = delete( $args{module} );
    my $sms = eval "Net::SMS::$module->new( %args )";
    $sms->verbose( 1 );
    $sms->send_sms();
};

if ( $@ )
{
    print "error: $@\n";
    print "NOT ok 1\n";
}
else
{
    print "ok 1\n";
}
