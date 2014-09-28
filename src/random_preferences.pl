/*
File: random_preferences.pl

The predicates defined in this file use randomness from library _random_.
To reset the randomness seed, execute the following goal:

> random:setrand(0).
*/

:- use_module(library(random), [
  random_permutation/2
]).

:- use_module(library(plunit), [
  begin_tests/1,
  end_tests/1
]).

/*
Predicate: random_preferences/2
Generates random instance of stable roommates problem of a given size.

> random_preferences(+N:int, -Preferences:list) is det.

Arguments:
N - Number of participants
Preferences - List of permutations of participant indices,
each ranging from 1 to N

Example of usage:
> random:setrand(0), random_preferences(64, Preferences), srp(Preferences, Partners).
*/

random_preferences(N, Preferences) :-
  length(Preferences, N),
  random_preferences1(N, Preferences).

%random_preferences1(+N, ?Preferences)
random_preferences1(_N, []).
random_preferences1(N, [H|T]) :-
  random_preference(N, H),
  random_preferences1(N, T).

%random_preference(+N, -Preference)
random_preference(N, Preference) :-
  range(N, Range),
  random_permutation(Range, Preference).

%range(+N, ?List)
range(N, List) :-
  N >= 0,
  N1 is N + 1,
  range(1, N1, List).

:- begin_tests(range_2).
test(n0, [true]) :- range(0, []).
test(n1, [true]) :- range(1, [1]).
test(n2, [true]) :- range(2, [1,2]).
test(generate_list_n0, [true(List == [])]) :- range(0, List).
test(generate_list_n1, [true(List == [1])]) :- range(1, List).
test(generate_list_n2, [true(List == [1,2])]) :- range(2, List).
:- end_tests(range_2).

%range(+Begin, +End, ?List)
range(Begin, End, List) :-
  (Begin == End -> List = []
  ; Begin < End ->
    Begin1 is Begin + 1,
    range(Begin1, End, Rest),
    List = [Begin|Rest]).

:- begin_tests(range_3).
test(generate_list_0_0, [true(List == [])]) :- range(0, 0, List).
test(generate_list_0_1, [true(List == [0])]) :- range(0, 1, List).
test(generate_list_1_2, [true(List == [1])]) :- range(1, 2, List).
test(generate_list_1_3, [true(List == [1,2])]) :- range(1, 3, List).
:- end_tests(range_3).
