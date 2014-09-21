%Stable roommates problem solver
%Find a stable perfect matching on participants with given preferences.

%Problem definition:
%http://en.wikipedia.org/wiki/Stable_roommates_problem

%Entry point:
%srp/2

:- use_module(library(clpfd), all).

:- use_module(library(lists), [
  nth1/3
]).

:- use_module(library(plunit), [
  begin_tests/1,
  end_tests/1
]).

%srp(+Preferences, ?Partners)
srp(Preferences, Partners) :-
  length(Preferences, N),
  length(Partners, N),
  assignment(Partners, Partners),
  stable(Preferences, Partners),
  labeling([], Partners).

:- begin_tests(srp).
test(n0, [true(Partners == [])]) :- srp([], Partners).
test(n1, [true(Partners == [1])]) :- srp([[1]], Partners).
test(n2, [true(Partners == [2,1])]) :- srp([[2,1], [1,2]], Partners).
%Source: http://en.wikipedia.org/wiki/Stable_roommates_problem#Solution
test(fail_wikipedia, [fail]) :- srp([[2,3,4], [3,1,4], [1,2,4], [1,2,3]], _Partners).
test(friends_fail, [fail]) :-
  srp([[3,4,2], [3], [1,2,4], [3,1,2]], _Partners).
test(friends_true, true(Partners == [3,4,1,2])) :-
  srp([[3,4,2], [3,4], [1,2,4], [3,1,2]], Partners).
:- end_tests(srp).

%Constrains Partners according to Preferences
%stable(+Preferences, ?Partners)
stable(Preferences, Partners) :-
  length(Preferences, N),
  stable_prefix(Preferences, Partners, N).

:- begin_tests(stable).
test(true, [true]) :- stable([[2,1], [1,2]], [2,1]).
test(fail, [fail]) :- stable([[2,1], [1,2]], [1,2]).
:- end_tests(stable).

%stable_prefix(+Preferences, ?Partners, +I)
stable_prefix(Preferences, Partners, I) :-
  (I == 0
  ; I > 0 ->
    length(Preferences, N),
    stable_prefix(Preferences, Partners, I, N),
    I1 is I - 1,
    stable_prefix(Preferences, Partners, I1)).

stable_prefix(Preferences, Partners, I, J) :-
  (J == 0
  ; J > 0 ->
    J1 is J - 1,
    stable_pair(Preferences, Partners, I, J),
    stable_prefix(Preferences, Partners, I, J1)).

%stable_pair(+Preferences, ?Partners, +I, +J)
stable_pair(Preferences, Partners, I, J) :-
  (prefers_partner_to_other(Preferences, Partners, I, J)
  ; prefers_partner_to_other(Preferences, Partners, J, I)).

%prefers_partner_to_other(+Preferences, +Partners, ?Judge, +Other)
prefers_partner_to_other(Preferences, Partners, Judge, Other) :-
  nth1(Judge, Preferences, Preference),
  element(Judge, Partners, Partner),
  prefers(Preference, Partner, Other).

:- begin_tests(prefers_partner_to_other).
test(true, [true]) :- prefers_partner_to_other([[2,1], _], [2,_], 1, 1).
test(fail, [fail]) :- prefers_partner_to_other([[1,2], _], [2,_], 1, 1).
test(generate_judge, [all(Judge == [1,2])]) :-
  prefers_partner_to_other([[2,1,3], [1,2,3], [1,2,3]], [2,1,3], Judge, 1).
:- end_tests(prefers_partner_to_other).

%prefers(+Preference, ?Good, +Bad)
prefers([H|T], Good, Bad) :-
  (H = Good
  ; H \== Bad -> prefers(T, Good, Bad)).

:- begin_tests(prefers).
test(empty_same, [fail]) :- prefers([], 1, 1).
test(empty_diff, [fail]) :- prefers([], 1, 2).
test(full_diff_true, [true]) :- prefers([1,2], 1, 2).
test(full_diff_fail, [fail]) :- prefers([1,2], 2, 1).
test(full_same, [true]) :- prefers([1,2], 1, 1).
test(generate_good, [all(Good == [1,2])]) :- prefers([1,2,_], Good, 2).
:- end_tests(prefers).
