/*
File: valid_preferences.pl
This file defines predicates for validating SRP instances.
*/

:- use_module(library(clpfd), [
  domain/3
]).

:- use_module(library(lists), [
  remove_dups/2,
  same_length/2,
  maplist/2
]).

:- use_module(library(plunit), [
  begin_tests/1,
  end_tests/1
]).


/*
Predicate: valid_preferences/1
Validates that a given list represents an instance of SRP.

> valid_preferences(+List:list) is semidet.
*/
valid_preferences(List) :-
  length(List, N),
  maplist(valid_preference(N), List).

:- begin_tests(valid_preferences_1).
test(empty, [true]) :- valid_preferences([]).
test(n1_empty, [true]) :- valid_preferences([[]]).
test(n1_full, [true]) :- valid_preferences([[1]]).
test(n2_basic, [true]) :- valid_preferences([[2,1],[1,2]]).
test(n2_irreflexive, [true]) :- valid_preferences([[2],[1]]).
test(n2_empty, [true]) :- valid_preferences([[],[]]).
test(n3_irreflexive, [true]) :- valid_preferences([[2,3],[3,1],[1,2]]).
test(n3_self, [true]) :- valid_preferences([[1],[2],[3]]).
test(n3_ranges, [true]) :- valid_preferences([[1,2,3],[1,2,3],[1,2,3]]).
test(n3_full, [true]) :- valid_preferences([[2,3,1],[3,1,2],[1,2,3]]).
test(n1_elem_high, [fail]) :- valid_preferences([[2]]).
test(n1_elem_zero, [fail]) :- valid_preferences([[0]]).
test(n2_dups, [fail]) :- valid_preferences([[2,2],[]]).
:- end_tests(valid_preferences_1).


/*
Predicate: valid_preference/2
Validates that a give list is a valid preference list of a given SRP size.

> valid_preference(+N:int, +List:list) is semidet.
*/
valid_preference(0, []).
valid_preference(N, List) :-
  valid_preference(List),
  domain(List, 1, N).

:- begin_tests(valid_preference_2).
test(true_n0, [true]) :- valid_preference(0, []).
test(true_n1, [true]) :- valid_preference(1, [1]).
test(true_n2, [true]) :- valid_preference(2, [1,2]).
test(true_n2_rev, [true]) :- valid_preference(2, [2,1]).
test(true_short, [true]) :- valid_preference(64, [64]).
test(fail_dups, [fail]) :- valid_preference(2, [1,1]).
test(fail_long_dups, [fail]) :- valid_preference(2, [2,1,2]).
test(fail_elem_high, [fail]) :- valid_preference(2, [1,2,3]).
test(fail_elem_0, [fail]) :- valid_preference(2, [0,2]).
:- end_tests(valid_preference_2).


/*
Predicate: valid_preference/1
Validates that a given list is a valid preference list.

> valid_preference(+List:list) is semidet.
*/
valid_preference(List) :-
  remove_dups(List, ListPruned),
  same_length(List, ListPruned).

:- begin_tests(valid_preference_1).
test(empty, [true]) :- valid_preference([]).
test(sequence, [true]) :- valid_preference([1,2,3]).
test(permutation, [true]) :- valid_preference([3,2,1]).
test(short, [true]) :- valid_preference([64]).
test(fail, [fail]) :- valid_preference([1,1]).
test(fail_long, [fail]) :- valid_preference([2,1,2]).
:- end_tests(valid_preference_1).
