package RT::IR::Ticket;

use strict;
use warnings;

=head1 NAME

RT::IR::Ticket - RTIR's tickets utilities

=head1 FUNCTIONS

=head2 FirstCustomFieldValue $TicketObj, $Field

Returns first RTIR ticket's custom field value. Use it only with RTIR's
special custom fields like C<State> and other.

=cut

sub FirstCustomFieldValue {
    my $ticket = shift;
    my $field = shift;
    return undef unless $ticket->CurrentUserHasRight('ShowTicket');

    return $ticket->FirstCustomFieldValue( $field );
}

=head2 IsLinkedToActiveIncidents $ChildObj [$IncidentObj]

Returns number of active incedents linked to child ticket
(IR, Investigation, Block or other). If second argument provided
then it's excluded from count.

When function return zero that means that object has no active
parent incidents.

=cut

sub IsLinkedToActiveIncidents {
    my $child = shift;
    my $parent = shift;

    my $query =  "Queue = 'Incidents'"
                ." AND HasMember = ". $child->id
                ." AND ( ". join(" OR ", map {"Status = '$_'"} RT->Config->Get('ActiveStatus') ) ." ) ";

    $query   .= " AND id != ". $parent->Id if $parent;

    my $tickets = RT::Tickets->new( $child->CurrentUser );
    $tickets->FromSQL( $query );
    return $tickets->Count;
}


1;
