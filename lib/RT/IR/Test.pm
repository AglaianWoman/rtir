package RT::IR::Test;
use strict;
use warnings;

### after: use lib qw(@RT_LIB_PATH@);
use lib qw(/opt/rt3/local/lib /opt/rt3/lib);

BEGIN {
    local $@;
    eval { require RT::Test; 1 } or do {
        require Test::More;
        Test::More::BAIL_OUT(
            "requires 3.8 to run tests. Error:\n$@\n"
            ."You may need to set PERL5LIB=/path/to/rt/lib"
        );
    };
}
use base qw(RT::Test);

use RT::IR::Test::Web;

our @EXPORT = qw(
    default_agent
    rtir_user
);

sub import {
    my $class = shift;
    my %args  = @_;

    $args{'requires'} ||= [];
    if ( $args{'testing'} ) {
        unshift @{ $args{'requires'} }, 'RT::IR';
    } else {
        $args{'testing'} = 'RT::IR';
    }
    unshift @{ $args{'requires'} }, 'RT::FM';

    $class->SUPER::import( %args );
    $class->export_to_level(1);

    RT->Config->LoadConfig( File => 'RTIR_Config.pm' );
    RT->Config->Set( 'rtirname' => 'regression_tests' );
    require RT::IR;
    return;
}

our $RTIR_TEST_USER = "rtir_test_user";
our $RTIR_TEST_PASS = "rtir_test_pass";

sub default_agent {
    my $agent = RT::IR::Test::Web->new;
    require HTTP::Cookies;
    $agent->cookie_jar( HTTP::Cookies->new );
    rtir_user();
    $agent->login($RTIR_TEST_USER, $RTIR_TEST_PASS);
    $agent->get_ok("/RTIR/index.html", "Loaded home page");
    return $agent;
}

sub rtir_user {
    return RT::Test->load_or_create_user(
        Name         => $RTIR_TEST_USER,
        Password     => $RTIR_TEST_PASS,
        EmailAddress => "$RTIR_TEST_USER\@example.com",
        RealName     => "$RTIR_TEST_USER Smith",
        MemberOf     => 'DutyTeam',
    );
}

1;
