%This line is needed so you can modify the variables with these predicates
:- dynamic item_at/2, here/1, card_collected/2.

%Predicate used to say which room we are currently in
here(entrance).

%series of predicates that tells us how the rooms are connected
move_to(entrance, n, lightstick_room).
move_to(lightstick_room, s, entrance).
move_to(entrance, e, concert_room) :- write('You need to collect all photo cards first!'), nl, !, fail.
move_to(entrance, w, dark_room) :- item_at(lightstick, in_hand).
move_to(entrance, w, dark_room) :- write('Cannot go in there. It is too dark!'), nl, !, fail.
move_to(dark_room, e, entrance).
move_to(dark_room, n, puzzle_room1).
move_to(dark_room, w, monster_room1).
move_to(monster_room1, e, dark_room).
move_to(monster_room1, n, monster_room2).
move_to(monster_room2, s, monster_room1).
move_to(monster_room2, e, puzzle_room1).
move_to(puzzle_room1, s, dark_room).
move_to(puzzle_room1, e, puzzle_room2).
move_to(puzzle_room2, w, puzzle_room1).
move_to(puzzle_room2, n, hydra_room) :- all_cards_collected.
move_to(hydra_room, s, puzzle_room2).
move_to(hydra_room, n, concert_room) :- fight_hydra.
move_to(concert_room, s, hydra_room).


%predicates that shows which rooms the items exist in
item_at(lightstick, lightstick_room).



%the take() predicates allow us to pick up an item.
take(Item) :- 
	item_at(Item, in_hand),
	write('You already have it'),
	nl, !.

take(Item) :-
	here(Place),
	item_at(Item, Place),
	retract(item_at(Item, Place)),
	assert(item_at(Item, in_hand)),
	write('OK.'),
	nl, !.
	
take(_) :-
	write('You do not see that here.'), nl.


%the describe() predicates give the room descriptions
describe(entrance) :- 
	write('Welcome to the Stray Kids K-pop Adventure!'), nl,
	write('The obvious exits are north and west.').

describe(lightstick_room) :-
	write('You are in the lightstick room.'),nl,
	write('Pick up the lightstick to explore darker areas.'), nl,
	write('The only exit is back south.').
	
describe(dark_room) :-
	write('You enter a dark and scary room .'),nl,
	write('The only exits are east, west, or north to a mysterious room.').
	
describe(monster_room1) :-
	write('You enter a dark cave(the first monster room) and face a ferocious monster!'), nl,
	write('Defeat the monster to earn two Stray Kids a photo cards.').
	
describe(monster_room2) :-
	write('You enter a fiery chamber(the first monster room) and encounter another monster!'), nl,
	write('Defeat it to earn two more Stray Kids photo cards.').
	
describe(puzzle_room1) :-
	write('You enter the first puzzle room.'), nl,
	write('Solve the challenge to collect two Stray Kids photo cards'). 
	
describe(puzzle_room2) :-
	write('You enter the second puzzle room.'), nl,
	write('Solve the challenge to collect the last two Stray Kids photo cards'). 
	
describe(hydra_room) :-
	write('You enter the Hydras lair'), nl,
	write('The hydra stands tall, gaurding a captive skz member!'), nl,
	write('Defeat the Hydra to rescue a Stray Kids member and proceed to the final room.').
	
describe(concert_room) :-
	write('You enter the grand concert hall!'), nl,
	write('Stray Kids are here to sign your photo cards and perform for you!').
	


%The show_objects() predicates are used to show any items that exist in the room outside of the description
show_objects(Place) :- 
	item_at(X, Place),
	write('There is a '), write(X), write(' here.'), nl, fail.
	
show_objects(_).

%Fight monsters
fight(monster1) :-
	here(monster_room1),
	not(card_collected(monster_room1, skz_member1)),
	not(card_collected(monster_room1, skz_member2)),
	assert(card_collected(monster_room1, skz_member1)),
	assert(card_collected(monster_room1, skz_member2)),
	write('You defeated the monster and collected BangChan and Lee Know photo cards'), nl, !.
	
fight(monster1) :-
	here(monster_room1),
	write('You have already defeated this monster.'), nl, !.
	
fight(monster2) :-
	here(monster_room2),
	not(card_collected(monster_room1, skz_member3)),
	not(card_collected(monster_room1, skz_member4)),
	assert(card_collected(monster_room2, skz_member3)),
	assert(card_collected(monster_room2, skz_member4)),
	write('You defeated the monster and collected Changbin and Hyunjin photo cards'), nl, !.
	
fight(monster2) :-
	here(monster_room2),
	write('You have already defeated this monster.'), nl, !.
	
%Solving Puzzles
solve_puzzle(puzzle1) :-
	here(puzzle_room1),
	not(card_collected(puzzle_room1, skz_member5)),
	not(card_collected(puzzle_room1, skz_member6)),
	assert(card_collected(puzzle_room1, skz_member5)),
	assert(card_collected(puzzle_room1, skz_member6)),
	write('You solved the puzzle and collected Felix and Han photo cards'), nl, !.
	
solve_puzzle(puzzle1) :-
	here(puzzle_room1),
	write('You have already solved this puzzle.'), nl, !.
	
solve_puzzle(puzzle2) :-
	here(puzzle_room2),
	not(card_collected(monster_room1, skz_member7)),
	not(card_collected(monster_room1, skz_member8)),
	assert(card_collected(puzzle_room2, skz_member7)),
	assert(card_collected(puzzle_room2, skz_member8)),
	write('You solved the puzzle and collected Seungmin and IN photo cards'), nl, !.
	
solve_puzzle(puzzle2) :-
	here(puzzle_room2),
	write('You have already solved this puzzle.'), nl, !.
	
	
%Collect photo cards
collect_card(Member) :-
	here(Room),
	not(card_collected(Room, Member)),
	assert(card_collected(Room, Member)),
	write('You collected a photo card of '), write(Member), write('!'), nl, !.
	
collect_card(_) :-
	write('You have already colected this card.'), nl.
	
%Check if all cards are collected
all_cards_collected :-
	card_collected(_,_),
	findall(X, card_collected(_,X), Cards),
	length(Cards, 8). % photo cards for all members
	
%Hydra fight
fight_hydra :- 
	write('You have fought bravely and defeated the hydra!'), nl,
	write('You rescued the skz member held captive'), nl,
	write('You can now proceed to the final room'), nl, !.
	

%Commands for the player
look :-
	here(Place),
	describe(Place),
	nl,
	show_objects(Place),
	nl.


%Predicates used to move to a different room
go(Direction) :-
	here(Curren_Location),
	move_to(Curren_Location, Direction, Next_Location),
	retract(here(Curren_Location)),
	assert(here(Next_Location)), look, !.
	
go(_) :- 
	write('Cannot go there.'), nl.

%Series of shortcut predicates to move in the cardinal directions.
n :- go(n).
s :- go(s).
e :- go(e).
w :- go(w).
u :- go(u).
d :- go(d).

%Help file to show commands
help :- write('------------Help File-------------------'), nl,
		write('|help - Shows the help file'), nl,
		write('|start - starts the game'), nl,
		write('|look - shows the room description of current room'), nl,
		write('|n,s,e,w,u,d - moves in the directions typed'), nl,
		write('|take(item) - allows you to take an item that appears in the room'), nl,
		write('|fight(monster1) - allows you to fight a monster in the first monster room'), nl,
		write('|fight(monster2) - allows you to fight a monster in the second monster room'), nl,
		write('|solve_puzzle(puzzle1) - allows you to solve the puzzle in the first puzzle room'), nl,
		write('|solve_puzzle(puzzle2) - allows you to solve the puzzle in the second puzzle room'), nl,
		write('|Make sure you always end your command with a period'), nl,
		write('|halt - end the game.'), nl.

start :- write('Welcome to the Stray Kids Adventure Game'),nl,
		help, nl,nl, look.
