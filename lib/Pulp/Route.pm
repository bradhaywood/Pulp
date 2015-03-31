package Pulp::Route;

use warnings;
use strict;
use true;

sub import {
    my $routes = {};
    my $caller = caller;
    my @classarr = split '::', $caller;
    my $class = $classarr[$#classarr]; 
    strict->import();
    warnings->import();
    true->import();
    {
        no strict 'refs';
        push @{"${caller}::ISA"}, 'Kelp';
        *{"${caller}::new"} = sub { return shift->SUPER::new(@_); };

        *{"${caller}::everything"} = sub { return "(.+)"; };
        *{"${caller}::get"} = sub {
            my ($name, $coderef) = @_;
            $routes->{$name} = {
                type    => 'get',
                class   => $class,
                coderef => $coderef,
            };
        };

        *{"${caller}::post"} = sub {
            my ($name, $coderef) = @_;
            $routes->{$name} = {
                type    => 'post',
                class   => $class,
                coderef => $coderef,
            };
        };

        *{"${caller}::any"} = sub {
            my ($name, $coderef) = @_;
            $routes->{$name} = {
                type    => 'any',
                class   => $class,
                coderef => $coderef,
            };
        };

        *{"${caller}::bridge"} = sub {
            my ($name, $coderef, $type) = @_;
            $type //= 'get';
            $routes->{$name} = {
               type     => $type,
               class    => $class,
               coderef  => $coderef,
               bridge   => 1,
            };
        };

        *{"${caller}::get_routes"} = sub {
            return $routes;
        };
    }
}

1;
__END__
