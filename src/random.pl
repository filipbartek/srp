/*
File: random.pl

The predicates defined in this file use randomness from library _random_.
To reset the randomness seed, execute the following goal:

> :- random:setrand(0).
*/

:- use_module(library(random), [
  random_permutation/2
]).

/*
Predicate: random_preferences/2

random_preferences(+N:int, -Preferences:list) is det.

Arguments:
N - Number of participants
Preferences - List of permutations of participant indices,
each ranging from 1 to N
*/

random_preferences(N, Preferences) :-
  length(Preferences, N),
  random_preferences1(N, Preferences).

%random_preferences1(+N, ?Preferences)
random_preferences1(_N, []).
random_preferences1(N, [H|T]) :-
  generate_preference(N, H),
  generate_preferences1(N, T).

%random_preference(+N, -Preference)
random_preference(N, Preference) :-
  range(N, Range),
  random_permutation(Range, Preference).
