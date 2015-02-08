
package MyMessage {
    use MooseX::App::Simple qw(Color Config Term);
    use Moose::Util::TypeConstraints qw();
    
    app_strict(1);
    
    parameter 'recipient' => (
        is            => 'rw',
        required      => 1,
        documentation => q[Recipient e-mail address],
        cmd_env       => 'MYMESSAGE_RECIPIENT',
    );
    option 'message' => (
        is            => 'rw',
        required      => 1,
        documentation => q[Message text],
        cmd_term      => 1,
    );
    option 'level' => (
        is            => 'rw',
        isa           => Moose::Util::TypeConstraints::enum([qw(low medium high)]),
        default       => 'medium',
        documentation => q[Message severity],
    );
    option 'verbose' => (
        is            => 'rw',
        isa           => 'Bool',
        documentation => q[Be verbose],
        cmd_aliases   => ['v'],
    );
    option 'extra' => (
        is            => 'rw',
        isa           => 'HashRef',
        documentation => q[Extra options],
    );
    
    
    sub run { 
        my ($self) = @_;
        
        use Data::Dumper;
        print 'Called run with '.Dumper($self);
    }
    
=head1 DESCRIPTION

This is how we roll

=cut
}

1;

