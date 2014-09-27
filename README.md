# srp

_Stable roommates problem solver_

This solver finds a stable matching (if such matching exists) for a given preference relation on a finite set of participants.

The preference relation can be specified in one of two ways:

* each participant has a list of potential partners ordered according to desirability or
* each participant assigns every participant a score.

## Problem definition

### Stable roommates problem

Let's assume we have _n_ participants. Each participant knows some of the participants, let's call these her potential partners. Each participant has a linear ordering of her potential partners according to preference.

Note that a participant may or may not consider herself a potential partner, i.e. the relation of potential partnership is not irreflexive.

A matching is an equivalence relation on participants that has classes of size at most 2, i.e. assigns each participant one or none partner. Matching must assign a potential partner to each of the participants.

An instability in a matching is a pair of participants each of whom prefers (according to their personal preference relations) the other to their current partner.

A stable matching is a matching that doesn't admit an instability.

In stable roommates problem, given preferences of each participant, the task is to find a stable matching.

Further reading: [Wikipedia](http://en.wikipedia.org/wiki/Stable_roommates_problem)

#### Perfect matching

A perfect matching is a matching in which every participant is assigned somebody else.

Once we can solve general SRP, we can force a perfect matching by making sure that no participant considers herself a potential partner.

## Tools

* [SICStus Prolog](https://sicstus.sics.se/) 4.2.3
  * Solver uses libraries `lists` and `clpfd`
  * Tests use library `plunit`
  * Performance measurement uses library `random`
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

## Documentation

Code documentation can be generated using [NaturalDocs](http://www.naturaldocs.org/).
A Windows batch script that facilitates the task is provided in
[NaturalDocs/build.bat](https://github.com/filipbartek/srp/blob/master/NaturalDocs/build.bat).

Code documentation is also available on the project's [GitHub web page](http://filipbartek.github.io/srp/).
Note that this version is not synchronized automatically with master branch and may be outdated.
