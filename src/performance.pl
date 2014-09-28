/*
File: performance.pl
This file defines tools for measuring performance of <srp/3>.

Example of usage:
> perform([0,1,2,4,8,16], [0,1,2,3,4,5,6,7,8,9], 100, user_output).
*/

:- consult('srp.pl').
%srp/3

:- consult('random_preferences.pl').
%random_preferences/3

perform(Sizes, Seeds, Executions, Stream) :-
  make_trials(Sizes, Seeds, Executions, Trials),
  write_header(Stream),
  write(Stream, '\n'),
  perform_trials(Trials, Stream).

write_header(Stream) :-
  write(Stream, 'size,seed,executions,solutions'),
  write(Stream, ','),
  write(Stream, 'leftmost.first.assumptions,leftmost.first.runtime,leftmost.first.walltime,leftmost.all.runtime,leftmost.all.walltime'),
  write(Stream, ','),
  write(Stream, 'ff.first.assumptions,ff.first.runtime,ff.first.walltime,ff.all.runtime,ff.all.walltime'),
  write(Stream, ','),
  write(Stream, 'ffc.first.assumptions,ffc.first.runtime,ffc.first.walltime,ffc.all.runtime,ffc.all.walltime').

make_trials(Sizes, Seeds, Executions, Trials) :-
  bagof(trial(Size, Seed, Executions),
      (member(Size, Sizes), member(Seed, Seeds)), Trials).

perform_trials([], _Stream).
perform_trials([Trial|Trials], Stream) :-
  perform_trial(Trial, Stream),
  write(Stream, '\n'),
  perform_trials(Trials, Stream).

%perform_trial(Trial, Stream)
perform_trial(trial(Size, Seed, Executions), Stream) :-
  write(Stream, Size),
  write(Stream, ','),
  write(Stream, Seed),
  write(Stream, ','),
  write(Stream, Executions),
  random_preferences(Size, Seed, Preferences),
  %Find the number of solutions using the strategy ff
  findall(Partners, srp(Preferences, Partners, [ff]), Solutions),
  length(Solutions, SolutionsN),
  write(Stream, ','),
  write(Stream, SolutionsN),
  perform_trial_strategy(Preferences, Executions, SolutionsN, leftmost, Stream),
  perform_trial_strategy(Preferences, Executions, SolutionsN, ff, Stream),
  perform_trial_strategy(Preferences, Executions, SolutionsN, ffc, Stream).

perform_trial_strategy(Preferences, Executions, SolutionsN, Strategy, Stream) :-
  write(Stream, ','),
  (SolutionsN == 0 %Leave empty (missing value)
  ; SolutionsN > 0 -> measure_assumptions(Preferences, Strategy, Stream)),
  write(Stream, ','),
  measure_time(Preferences, Executions, Strategy, Stream).

measure_assumptions(Preferences, Strategy, Stream) :-
  srp(Preferences, _Partners, [Strategy, assumptions(K)]),
  write(Stream, K).

measure_time(Preferences, Executions, Strategy, Stream) :-
  measure_time_first(Preferences, Executions, Strategy, Stream),
  write(Stream, ','),
  measure_time_all(Preferences, Executions, Strategy, Stream).

measure_time_first(Preferences, Executions, Strategy, Stream) :-
  timeit(srp(Preferences, _Partners, [Strategy]),
      Executions, Runtime, Walltime),
  write(Stream, Runtime),
  write(Stream, ','),
  write(Stream, Walltime).

measure_time_all(Preferences, Executions, Strategy, Stream) :-
  timeit(findall(Partners, srp(Preferences, Partners, [Strategy]), _Solutions),
      Executions, Runtime, Walltime),
  write(Stream, Runtime),
  write(Stream, ','),
  write(Stream, Walltime).

timeit(Stmt, Number, Runtime, Walltime) :-
  statistics(runtime, _),
  statistics(walltime, _),
  try_repeatedly(Stmt, Number),
  statistics(walltime, [_, Walltime]),
  statistics(runtime, [_, Runtime]).

try_repeatedly(Stmt, N) :-
  (N == 0
  ; N > 0 ->
    try(Stmt),
    N1 is N - 1,
    try_repeatedly(Stmt, N1)).

try(Stmt) :-
  call(Stmt), !.
try(_Stmt).

:- begin_tests(try_1).
test(true, [true]) :- try(true).
test(fail, [true]) :- try(fail).
:- end_tests(try_1).
