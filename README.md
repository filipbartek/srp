# srp

Stable roommates problem solver

This solver finds a perfect stable matching (if such matching exists) for a given set of lists of preferences (not necessarily complete).

Note especially that the solver isn't able to find imperfect matchings.

## Definitions

* Stable matching: [Stable roommates problem - Wikipedia](http://en.wikipedia.org/wiki/Stable_roommates_problem)
* Perfect matching: [Matching - Wikipedia](http://en.wikipedia.org/wiki/Matching_%28graph_theory%29#Definition)

## Tools

* [SICStus Prolog](https://sicstus.sics.se/) 4.2.3
  * lists
  * clpfd
  * plunit
* [NaturalDocs](http://www.naturaldocs.org/) 1.52

## Usage

```prolog
srp(+Preferences, -Partners).
```
`Preferences` is a list of lists of integers. Every participant is identified by an integer between _1_ and _n_, where _n_ is the length of `Preferences`. _i_-th member of `Preferences` lists the ids of all potential partners of participant with the id _i_ ordered from the most desirable to the least desirable.

`Partners` is a permutation of integers between _1_ and _n_. _i_-th member of `Partners` is the id of the partner of the participant _i_ in the stable matching found by the program.

## Tests

This project uses plunit library for unit testing. To run the tests, consult a source file and execute goal:
```prolog
plunit:run_tests.
```
Detailed instructions for running the tests are available in [plunit documentation](https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/lib_002dplunit.html#lib_002dplunit).
