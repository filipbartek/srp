%Generate preferences list compatible with srp/2 from preference/2 predicate

%Entry point:
%preferences/3

:- use_module(library(lists), [
  keys_and_values/3
]).

:- use_module(library(plunit), [
  begin_tests/1,
  end_tests/1
]).

%preferences(+People, -Preferences, -Dict)
preferences(People, Preferences, Dict) :-
  length(People, N),
  range(N, Range),
  keys_and_values(Dict, Range, People),
  keys_and_values(DictR, People, Range),
  preferences1(People, DictR, Preferences).

%preferences1(+People, +Dict, -Preferences)
preferences1([], _Dict, []).
preferences1(People, Dict, Preferences) :-
  People = [PeopleH|PeopleT],
  Preferences = [PreferencesH|PreferencesT],
  preference(PeopleH, Preference),
  translate_list(Preference, Dict, PreferencesH),
  preferences1(PeopleT, Dict, PreferencesT).

%translate_list(+From, +Dict, -To)
translate_list([], _Dict, []).
translate_list([FromH|FromT], Dict, [ToH|ToT]) :-
  translate_elem(FromH, Dict, ToH),
  translate_list(FromT, Dict, ToT).
translate_list([FromH|FromT], Dict, To) :-
  \+ member(FromH-_, Dict),
  translate_list(FromT, Dict, To).

:- begin_tests(translate_list).
test(helloworld, [true(To == ['Ahoj', 'Svet'])]) :-
  translate_list(['Hello', 'World'], ['Hello'-'Ahoj', 'World'-'Svet'], To).
test(largedict, [true(To == [d,b])]) :-
  translate_list([4,2], [1-a, 2-b, 3-c, 4-d, 5-e], To).
test(miss_odd, [true(To == [b,d])]) :-
  translate_list([1,2,3,4,5], [2-b, 4-d], To).
test(miss_even, [true(To == [a,c,e])]) :-
  translate_list([1,2,3,4,5], [1-a, 3-c, 5-e], To).
:- end_tests(translate_list).

%translate_elem(+From, +Dict, -To)
translate_elem(From, [From-To|_T], To).
translate_elem(From, [_H|T], To) :-
  translate_elem(From, T, To).
