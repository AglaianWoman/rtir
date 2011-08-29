package RT::Condition::RTIR_BlockActivation;
use strict;
use warnings;

use base 'RT::Condition::RTIR';

use RT::CustomField;

=head2 IsApplicable

When state of the block changes from C<pending active> to C<active>
or ticket created with C<active> state.

=cut

sub IsApplicable {
    my $self = shift;

    my $txn = $self->TransactionObj;

    my $type = $txn->Type;
    return 1 if $type eq 'Create'
        && ($self->TicketObj->FirstCustomFieldValue('State')||'') eq 'active';

    if ( $type eq 'CustomField' ) {
        my $cf = $self->TicketObj->QueueObj->CustomField('State');
        unless ( $cf->id ) {
            $RT::Logger->error("Couldn't load the 'State' field");
            return 0;
        }

        return 0 unless $cf->id == $txn->Field;
        return 0 unless ($txn->OldValue||'') eq 'pending activation';
        return 0 unless ($txn->NewValue||'') eq 'active';
        return 1;
    }

    return 0;
}

RT::IR->ImportOverlays;

1;
