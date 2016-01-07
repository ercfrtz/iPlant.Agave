#!/usr/bin/perl

use warnings;
use strict;

my $systemArgs = "iplant-agave-sdk/foundation-cli/bin/tenants-init -t iplantc.org";
system($systemArgs);
$systemArgs = 'iplant-agave-sdk/foundation-cli/bin/clients-create -S -v -N my_client -D "Client used for app development" -u username -p password';
system($systemArgs);
$systemArgs = "iplant-agave-sdk/foundation-cli/bin/auth-tokens-create -v -S -u username -p password";
system($systemArgs);
