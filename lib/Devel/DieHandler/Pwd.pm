package Devel::DieHandler::Pwd;

# DATE
# VERSION

use strict;
use warnings;
use Cwd;

my @handler_stack;

sub import {
    my $pkg = shift;
    push @handler_stack, $SIG{__DIE__} if $SIG{__DIE__};
    $SIG{__DIE__} = sub {
        local $SIG{__DIE__};
        print STDERR "Current directory: ", getcwd(), "\n";
        if (@handler_stack) {
            goto &{$handler_stack[-1]};
        } else {
            die @_;
        }
    };
}

sub unimport {
    my $pkg = shift;
    if (@handler_stack) {
        $SIG{__DIE__} = pop(@handler_stack);
    }
}

1;
# ABSTRACT: Print working directory when program dies

=head1 SYNOPSIS

 % perl -MDevel::DieHandler::Pwd -e'...'


=head1 DESCRIPTION

When imported, this module installs a C<__DIE__> handler which prints working
directory to STDERR, then calls the previous handler (or die).

Unimporting (via C<no Devel::DieHandler::Pwd>) after importing restores the
previous handler.


=head1 SEE ALSO

Other C<Devel::DieHandler::*> modules
