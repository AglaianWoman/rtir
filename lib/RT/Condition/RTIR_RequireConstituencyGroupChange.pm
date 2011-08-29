package RT::Condition::RTIR_RequireConstituencyGroupChange;

use strict;
use warnings;

use base 'RT::Condition::RTIR';
use RT::CustomField;

=head2 IsApplicable

Applies to Ticket Creation and Constituency changes

=cut

sub IsApplicable {
    my $self = shift;

    my $ticket = $self->TicketObj;
    my $cf = $ticket->LoadCustomFieldByIdentifier('Constituency');
    # no constituency
    return 0 unless $cf && $cf->id;

    my $txn = $self->TransactionObj;
    my $type = $txn->Type;
    return 1 if $type eq 'Create';
    return 1 if $type eq 'CustomField' && $cf->id == $txn->Field;
    return 0;
}

RT::IR->ImportOverlays;

1;
