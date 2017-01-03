#!/bin/bash
(echo PACKAGE SIZE; \
  for A in /var/lib/pacman/local/*/desc; do
    (sed -n 2p $A; grep -E '^[0-9]{2,}$' $A) | tr '\n' ' '; echo
  done \
    | sort -nrk2) \
    | column -t > pacs_by_size



