
package Perl6::MM::Method;

use Perl6::Core::Closure;

package method;

use strict;
use warnings;

use Carp 'confess';
use Scalar::Util 'blessed';

use base 'closure';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
} 

sub do {
    my ($self, $args) = @_;
    (blessed($args) && $args->isa('list'))
        || confess "You must have an arg list";
    ($args->length->greater_than_or_equal_to(num->new(1)) == $bit::TRUE)
        || confess "Your arg list must at least include the invocant";
    my $inv = $args->fetch(num->new(0));
    (blessed($inv) && $inv->isa('opaque'))
        || confess "The invocant must be an opaque type";
    $self->SUPER::do($args);
}

sub _bind_params {
    my ($self, $args) = @_;
    $self->SUPER::_bind_params($args);
    my $inv = $args->fetch(num->new(0));
    $self->{env}->set('$?SELF'    => $inv);
    $self->{env}->set('$?CLASS'   => $inv->class);    
    $self->{env}->set('$?PACKAGE' => $inv->class);        
}

1;

__END__

=pod

=head1 NAME

method - the core method instance type

=cut
