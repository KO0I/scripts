#!/bin/sh

LC_ALL=C find "/usr/lib/perl5/site_perl" -type f -exec pacman -Qqo {} + |& sed -n 's/^error: No package owns \(.*\)$/\1/p'
