use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Net::SMS::Web',
    'VERSION_FROM'	=> 'lib/Net/SMS/Web.pm', # finds $VERSION
    'PREREQ_PM'		=> {
        Carp            => undef,
        LWP::UserAgent  => 1.73,
        CGI::Enurl      => 1.06,
        URI             => 1.09,
        Term::ReadKey   => 2.14,
    }, # e.g., Module::Name => 1.1
);
