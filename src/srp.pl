/*
File: srp.pl
*/

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


/*
Predicate: srp/2

srp(+Preferences:list, -Partners:list) is nondet.

srp(+Preferences:list, +Partners:list) is semidet.

Arguments:
Preferences - List of lists of participants ordered according to desirability
Partners - Assignment of partners

See also:
<srp/3>
*/

srp(Preferences, Partners) :-
  srp(Preferences, Partners, []).


/*
Predicate: srp/3

srp(+Preferences:list, -Partners:list, :Options:list) is nondet.

Arguments:
Preferences - List of lists of participants ordered according to desirability
Partners - Assignment of partners
Options - Options list for _clpfd:labeling/2_
*/

srp(Preferences, Partners, Options) :-
  make_scores(Preferences, Scores),
  srp_scores(Scores, Partners, Options),
  members(Partners, Preferences).

:- begin_tests(srp).

test(n0, [true(Partners == [])]) :- srp([], Partners).
test(n1, [true(Partners == [1])]) :- srp([[1]], Partners).
test(n2, [true(Partners == [2,1])]) :- srp([[2,1], [1,2]], Partners).

%Source: http://en.wikipedia.org/wiki/Stable_roommates_problem#Solution
test(fail_wikipedia, [fail]) :-
  srp([[2,3,4], [3,1,4], [1,2,4], [1,2,3]], _Partners).

test(friends_fail, [fail]) :-
  srp([[3,4,2], [3], [1,2,4], [3,1,2]], _Partners).
test(friends_true, true(Partners == [3,4,1,2])) :-
  srp([[3,4,2], [3,4], [1,2,4], [3,1,2]], Partners).

%Source: http://en.wikipedia.org/wiki/Stable_roommates_problem#Example
test(wiki_6, [true(Partners == [6,4,5,2,3,1])]) :-
  srp([
    [3,4,2,6,5],
    [6,5,4,1,3],
    [2,4,5,1,6],
    [5,2,3,6,1],
    [3,1,2,4,6],
    [5,1,3,4,2]], Partners).

%Source: http://en.wikipedia.org/wiki/File:Gale-Shapley.gif
test(wiki_marriages, [fixme('Generates an unexpected solution'),
    true(Partners == [5,8,7,6,1,4,3,2])]) :-
  srp([
    [5,7,6,8],
    [7,8,5,6],
    [8,6,7,5],
    [7,6,5,8],
    [2,1,3,4],
    [4,1,2,3],
    [1,3,2,4],
    [2,3,1,4]], Partners).

%Source: Tardos, Kleinberg: Stable matchings
test(kleinberg_1, [true(Partners == [3,4,1,2])]) :-
  srp([[3,4],[3,4],[1,2],[1,2]], Partners).

%Source: Tardos, Kleinberg: Stable matchings
test(kleinberg_2, [all(Partners == [[3,4,1,2], [4,3,2,1]])]) :-
  srp([[3,4],[4,3],[2,1],[1,2]], Partners).

:- end_tests(srp).


%members(?Elements, ?Lists)
members([], []).
members([EH|ET], [LH|LT]) :-
  member(EH, LH),
  members(ET, LT).


/*
Predicate: srp_scores/3

srp_scores(+Scores:list, +Partners:list, :Options:list) is semidet.

srp_scores(+Scores:list, -Partners:list, :Options:list) is nondet.

Arguments:
Scores - List of lists of scores
Partners - Assignment of partners
Options - Options list for _clpfd:labeling/2_
*/

srp_scores(Scores, Partners, Options) :-
  length(Scores, N),
  length(Partners, N),
  domain(Partners, 1, N), %Partners is a list of N domain variables
  assignment(Partners, Partners), %Constrain Partners
  length(PartnerScores, N),
  domain(PartnerScores, 1, N), %PartnerScores is a list of N domain variables
  elements(Partners, Scores, PartnerScores), %Bind Partners and PartnerScores
  stable_prefix_i(Scores, PartnerScores, N, N), %Constrain PartnerScores
  labeling(Options, Partners).

:- begin_tests(srp_scores).
test(kleinberg_2, [all(Partners == [[3,4,1,2], [4,3,2,1]])]) :-
  srp_scores([[4,4,1,2],[4,4,2,1],[2,1,4,4],[1,2,4,4]], Partners, []).
:- end_tests(srp_scores).


%elements(?Xs, +Lists, ?Ys)
elements([], [], []).
elements([X|Xs], [List|Lists], [Y|Ys]) :-
  element(X, List, Y),
  elements(Xs, Lists, Ys).

%stable_prefix_i(+Scores, ?PartnerScores, +N, +I)
stable_prefix_i(Scores, PartnerScores, N, I) :-
  (I == 0
  ; I > 0 ->
    I1 is I - 1,
    stable_prefix_ij(Scores, PartnerScores, I, I),
    stable_prefix_i(Scores, PartnerScores, N, I1)).

%stable_prefix_ij(+Scores, ?PartnerScores, +I, +J)
stable_prefix_ij(Scores, PartnerScores, I, J) :-
  (J == 0
  ; J > 0 ->
    stable_pair(Scores, PartnerScores, I, J),
    J1 is J - 1,
    stable_prefix_ij(Scores, PartnerScores, I, J1)).

%stable_pair(+Scores, ?PartnerScores, +I, +J)
stable_pair(Scores, PartnerScores, I, J) :-
  nth1(I, Scores, ScoreI), %ScoreI: auxiliary
  nth1(J, Scores, ScoreJ), %ScoreJ: auxiliary
  nth1(J, ScoreI, ScoreIJ), %ScoreIJ: constant
  nth1(I, ScoreJ, ScoreJI), %ScoreJI: constant
  nth1(I, PartnerScores, ScoreIP), %ScoreIP: CP variable
  nth1(J, PartnerScores, ScoreJP), %ScoreJP: CP variable
  ScoreIP #=< ScoreIJ #\/ ScoreJP #=< ScoreJI. %Constrain!


/*
Predicate: make_scores/2

make_scores(+Preferences:list, -Scores:list) is det.

Arguments:
Preferences - List of lists of candidates ordered by desirability
Scores - List of lists of scores
*/

make_scores(Preferences, Scores) :-
  length(Preferences, N),
  make_scores(Preferences, Scores, N).

:- begin_tests(make_scores).
test(kleinberg_2,
    [all(Scores == [[[4,4,1,2],[4,4,2,1],[2,1,4,4],[1,2,4,4]]])]) :-
  make_scores([[3,4],[4,3],[2,1],[1,2]], Scores).
:- end_tests(make_scores).

make_scores([], [], _N).
make_scores([PH|PT], [SH|ST], N) :-
  make_score(PH, SH, N, N),
  make_scores(PT, ST, N).

%make_score(+Preference, -Score, +Length, +Padding)
make_score(Preference, Score, Length, Padding) :-
  length(Score, Length),
  make_score1(Preference, Score, 1, Padding).

make_score1(_Preference, [], _I, _Padding).
make_score1(Preference, [SH|ST], I, Padding) :-
  nth1(SH, Preference, I),
  I1 is I + 1,
  make_score1(Preference, ST, I1, Padding).
make_score1(Preference, [SH|ST], I, Padding) :-
  \+ member(I, Preference),
  SH = Padding,
  I1 is I + 1,
  make_score1(Preference, ST, I1, Padding).
