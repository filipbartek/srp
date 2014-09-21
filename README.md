# srp

Stable roommates problem solver

## Tools

* [SICStus Prolog](https://sicstus.sics.se/) 4.2.3
  * lists
  * clpfd
  * plunit

## Usage

```prolog
srp(+Preferences, -Partners).
```
`Preferences` is a list of lists of integers. Every participant is identified by an integer between _1_ and _n_, where _n_ is the length of `Preferences`. _i_-th member of `Preferences` lists the ids of all potential partners of participant with the id _i_ ordered from the most desirable to the least desirable.

`Partners` is a permutation of integers between _1_ and _n_. _i_-th member of `Partners` is the id of the partner of the participant _i_ in the stable matching found by the program.
