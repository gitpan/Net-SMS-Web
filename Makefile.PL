use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Net::SMS::Web',
    'VERSION_FROM'	=> 'lib/Net/SMS/Web.pm', # finds $VERSION
    'PREREQ_PM'		=> {
        Carp            => undef,
        LWP::UserAgent  => undef,
        CGI::Enurl      => undef,
        URI             => undef,
        Term::ReadKey   => undef,
        File::Find      => undef,
        CGI::Lite       => undef,
        Class::Struct   => undef,

    }, # e.g., Module::Name => 1.1
);
