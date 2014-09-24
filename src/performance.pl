/*
File: performance.pl
This file defines tools for measuring performance of <srp/3>.
*/

:- use_module(library(random), [
  setrand/1,
  random_permutation/2
]).

%make_instances([0,1,2,4,8,16], [0,1,2,3,4,5,6,7,8,9], _Instances), measure(_Instances, 10, _Results), write_results(user_output, _Results).
%make_instances([32,64], [0,1,2,3,4,5,6,7,8,9], _Instances), measure(_Instances, 10, _Results), write_results(user_output, _Results).

write_results(_Stream, []).
write_results(Stream, [Result|Results]) :-
  write_result(Stream, Result),
  write_results(Stream, Results).

write_result(Stream, Result) :-
  Result = result(instance(id(Size, Seed), _Preferences), Executions, Strategy, Assumptions, Solutions, OneRuntime, OneWalltime, AllRuntime, AllWalltime),
  write(Stream, Size),
  write(Stream, ','),
  write(Stream, Seed),
  write(Stream, ','),
  write(Stream, Executions),
  write(Stream, ','),
  write(Stream, Strategy),
  write(Stream, ','),
  write(Stream, Assumptions),
  write(Stream, ','),
  write(Stream, Solutions),
  write(Stream, ','),
  write(Stream, OneRuntime),
  write(Stream, ','),
  write(Stream, OneWalltime),
  write(Stream, ','),
  write(Stream, AllRuntime),
  write(Stream, ','),
  write(Stream, AllWalltime),
  write(Stream, '\n').

make_instances([], _Seeds, []).
make_instances([Size|Sizes], Seeds, Instances) :-
  make_instances1(Size, Seeds, InstancesThis),
  make_instances(Sizes, Seeds, InstancesOther),
  append(InstancesThis, InstancesOther, Instances).

make_instances1(_Size, [], []).
make_instances1(Size, [Seed|Seeds], [Instance|Instances]) :-
  make_instance(Size, Seed, Instance),
  make_instances1(Size, Seeds, Instances).

make_instance(Size, Seed, Instance) :-
  setrand(Seed),
  random_preferences(Size, Preferences),
  Id = id(Size, Seed),
  Instance = instance(Id, Preferences).

%measure(+Sizes:list, +Seeds:list, +Executions:int, -Results:list)
measure([], _Executions, []).
measure([Instance|Instances], Executions, [ResultLeftmost, ResultFf, ResultFfc|Results]) :-
  measure(Instance, Executions, leftmost, ResultLeftmost),
  measure(Instance, Executions, ff, ResultFf),
  measure(Instance, Executions, ffc, ResultFfc),
  measure(Instances, Executions, Results).

measure(Instance, Executions, Strategy, Result) :-
  Instance = instance(_Id, Preferences),
  srp(Preferences, _Partners, [Strategy, assumptions(Assumptions)]),
  !,
  timeit(srp(Preferences, _Partners, [Strategy]), Executions, OneRuntime, OneWalltime),
  %timeit(findall(Partners, srp(Preferences, Partners, [Strategy]), List), Executions, AllRuntime, AllWalltime),
  %length(List, Solutions),
  %Result = result(Instance, Executions, Strategy, Assumptions, Solutions, OneRuntime, OneWalltime, AllRuntime, AllWalltime).
  Result = result(Instance, Executions, Strategy, Assumptions, 1, OneRuntime, OneWalltime, -1, -1).
measure(Instance, Executions, Strategy, Result) :-
  Instance = instance(_Id, Preferences),
  \+ srp(Preferences, _Partners, [Strategy]),
  Result = result(Instance, Executions, Strategy, -1, 0, -1, -1, -1, -1).

timeit(Stmt, Number, Runtime, Walltime) :-
  statistics(runtime, _),
  statistics(walltime, _),
  call_repeatedly(Stmt, Number),
  statistics(walltime, [_, Walltime]),
  statistics(runtime, [_, Runtime]).

call_repeatedly(Stmt, N) :-
  (N == 0
  ; N > 0 ->
    call(Stmt),
    N1 is N - 1,
    call_repeatedly(Stmt, N1)).
