%Stable roommates problem solver
%Find a stable perfect matching on participants with given preferences.

%Problem definition:
%http://en.wikipedia.org/wiki/Stable_roommates_problem

%Entry point:
%srp_4/2

:- use_module(library(clpfd), all).

:- use_module(library(lists), [
  nth1/3
]).

:- use_module(library(plunit), [
  begin_tests/1,
  end_tests/1
]).

%srp_4(+Preferences, ?Partners)
srp_4(Preferences, Partners) :-
  srp_4(Preferences, Partners, _K).

%srp_4(+Preferences, ?Partners, ?K)
srp_4(Preferences, Partners, K) :-
  %Extract scores
  Preferences = [Pref1, Pref2, Pref3, Pref4],
  score(Score12, Pref1, 2),
  score(Score13, Pref1, 3),
  score(Score14, Pref1, 4),
  score(Score21, Pref2, 1),
  score(Score23, Pref2, 3),
  score(Score24, Pref2, 4),
  score(Score31, Pref3, 1),
  score(Score32, Pref3, 2),
  score(Score34, Pref3, 4),
  score(Score41, Pref4, 1),
  score(Score42, Pref4, 2),
  score(Score43, Pref4, 3),
  %Initialize Partners
  Partners = [Part1, Part2, Part3, Part4],
  %Constrain Partners
  domain(Partners, 1, 4),
  assignment(Partners, Partners),
  %Bind partner's score and ensure that partner is in preference list
  element(Score1P, Pref1, Part1),
  element(Score2P, Pref2, Part2),
  element(Score3P, Pref3, Part3),
  element(Score4P, Pref4, Part4),
  %Equality ScoreXP == ScoreXY holds iff PartX == Y
  Score1P #=< Score12 #\/ Score2P #=< Score21,
  Score1P #=< Score13 #\/ Score3P #=< Score31,
  Score1P #=< Score14 #\/ Score4P #=< Score41,
  Score2P #=< Score23 #\/ Score3P #=< Score32,
  Score2P #=< Score24 #\/ Score4P #=< Score42,
  Score3P #=< Score34 #\/ Score4P #=< Score43,
  %Label Partners
  labeling([assumptions(K)], Partners).

:- begin_tests(srp_4).

%Source: http://en.wikipedia.org/wiki/Stable_roommates_problem#Solution
test(fail_wikipedia, [fail]) :-
  srp_4([[2,3,4], [3,1,4], [1,2,4], [1,2,3]], _Partners).

test(friends_fail, [fail]) :-
  srp_4([[3,4,2], [3], [1,2,4], [3,1,2]], _Partners).
test(friends_true, true(Partners == [3,4,1,2])) :-
  srp_4([[3,4,2], [3,4], [1,2,4], [3,1,2]], Partners).
test(friends_true_complete, true(Partners == [3,4,1,2])) :-
  srp_4([[3,4,2], [3,4,1], [1,2,4], [3,1,2]], Partners).

%Source: Tardos, Kleinberg: Stable matchings
test(kleinberg_1, [true(Partners == [3,4,1,2])]) :-
  srp_4([[3,4],[3,4],[1,2],[1,2]], Partners).

%Source: Tardos, Kleinberg: Stable matchings
test(kleinberg_2, [all(Partners == [[3,4,1,2], [4,3,2,1]])]) :-
  srp_4([[3,4],[4,3],[2,1],[1,2]], Partners).

:- end_tests(srp_4).


%score(?Score, +Preference, +Candidate)
score(Score, Preference, Candidate) :-
  nth1(Score, Preference, Candidate),
  !.
score(4, Preference, Candidate) :-
  \+ member(Candidate, Preference).
