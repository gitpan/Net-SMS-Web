use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Net::SMS::Web',
    'VERSION_FROM'	=> 'Web.pm', # finds $VERSION
    'PREREQ_PM'		=> {
        Carp            => undef,
        Class::Struct   => undef,
        LWP::UserAgent  => undef,
        CGI::Enurl      => undef,
        URI             => undef,
        CGI::Lite       => undef,
    }, # e.g., Module::Name => 1.1
);
