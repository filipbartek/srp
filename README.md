# srp

_Stable roommates problem solver_

This solver finds a stable matching (if such matching exists) for a given preference relation on a finite set of participants.

The preference relation can be specified in one of two ways:

* each participant has a list of potential partners ordered according to desirability or
* each participant assigns every participant a score.

## Problem definition

### Stable roommates problem

Let each of _n_ participants linearly order all the other participants according to personal preferences.

A matching is an equivalence relation on participants that has classes of size at most 2.

A perfect matching is a matching with classes of size exactly 2. In a perfect matching, every participant is assigned a partner.

An instability in a matching is a pair of participants each of whom prefers (according to their preference relation) the other to their current partner.

A stable matching is a matching that doesn't admit an instability.

(Source: [Wikipedia](http://en.wikipedia.org/wiki/Stable_roommates_problem))

## Tools

* [SICStus Prolog](https://sicstus.sics.se/) 4.2.3
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
