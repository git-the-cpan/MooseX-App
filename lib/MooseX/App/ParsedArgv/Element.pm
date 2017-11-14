# ============================================================================
package MooseX::App::ParsedArgv::Element;
# ============================================================================

use 5.010;
use utf8;

use Moose;
no if $] >= 5.018000, warnings => qw(experimental::smartmatch);

has 'key' => (
    is              => 'ro',
    isa             => 'Str',
    required        => 1,
);

has 'value' => (
    is              => 'ro',
    isa             => 'ArrayRef[Str]',
    traits          => ['Array'],
    default         => sub { [] },
    handles         => {
        add_value       => 'push',
        has_values      => 'count',
        get_value       => 'get',
        raw_values      => 'elements',
    }
);

has 'consumed' => (
    is              => 'rw',
    isa             => 'Bool',
    default         => sub {0},
);

has 'type' => (
    is              => 'ro',
    isa             => 'Str',
    required        => 1,
);

has 'raw' => (
    is              => 'ro',
    isa             => 'Str',
    predicate       => 'has_raw',
);

has 'occurence' => (
    is              => 'ro',
    isa             => 'Int',
    default         => sub { 1 },
    traits          => ['Counter'],
    handles         => {
        inc_occurence   => 'inc',
    }
);

sub original {
    my ($self) = @_;
    if ($self->has_raw) {
        return $self->raw;
    } else {
        return $self->key;
    }
}

sub consume {
    my ($self,$attribute) = @_;
    
    Moose->throw_error('Element '.$self->type.' '.$self->key.' is already consumed')
        if $self->consumed;
    $self->consumed(1);  
    
    return $self; 
}

sub full_value {
    my ($self) = @_;
    
    # Fill up empty values
    if ($self->has_values < $self->occurence) {
        return [
            $self->raw_values,
            (undef) x ($self->occurence - $self->has_values)
        ];
    } else {
        return $self->value;
    }
}

#sub set_value {
#    my ($self,$value) = @_;
#    
#    unless (scalar @{$self->value}) {
#        $self->add_value($value);
#    } else {
#        if (! defined $self->value->[-1]) {
#            $self->value->[-1] = $value;
#        } else {
#            $self->add_value($value);
#        }
#    }
#}

sub serialize {
    my ($self) = @_;
    given ($self->type) {
        when ('extra') { 
            return $self->key
        }
        when ('parameter') { 
            return $self->key
        }
        when ('option') { 
            my $key = (length $self->key == 1 ? '-':'--').$self->key;
            return join(' ',map { $key.' '.$_ } @{$self->value});
        }
    }
    return;
}

__PACKAGE__->meta->make_immutable();
1;

=pod

=head1 NAME

MooseX::App::ParsedArgv::Element - Parsed element from @ARGV

=head1 DESCRIPTION

Every instance of this class represents a logical entity from @ARGV

=head1 METHODS

=head2 key

Parameter value or option key

=head2 value

Arrayref of values 

=head2 raw

Raw value as supplied by the user

=head2 type

Type of element. Can be 'option', 'parameter' or 'extra'

=head2 occurence

Number of occurences in @ARGV

=head2 consumed

Flag that indicates if element was already consumed

=head2 consume

Consumes element. Dies if element is already consumed

=head2 serialize

Serializes element (Does not procuce output that is identical with original @ARGV)

=cut