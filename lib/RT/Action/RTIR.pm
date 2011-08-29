package RT::Action::RTIR;
use strict;
use warnings;

use base 'RT::Action::Generic';

use RT::IR;

sub CreatorCurrentUser {
    my $self = shift;
    my $user = RT::CurrentUser->new($self->TransactionObj->CurrentUser);
    $user->Load($self->TransactionObj->Creator);
    return $user;
}


1;
