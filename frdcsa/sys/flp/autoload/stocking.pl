goal(location(Product,Location)) :-
	minimumLevel(livingRoomBathroom,toiletPaper,MinimumLevel),
	wsmHoldsNow(hasInventory(Location,Product,CurrentLevel)),
	CurrentLevel < DesiredLevel.

%% this is insufficient, need to say there should be at least one,
%% more if possible

resupplies(upstairsUtilityCloset,livingRoomBathroom,[toiletPaper]).

minimumLevel(livingRoomBathroom,toiletPaper,1).

%% should(always(Plan,(hasInventory(livingRoomBathroom,toiletPaper,Quantity),Quantity > 0))) :-
%% 	selectedPlan(Plan).
