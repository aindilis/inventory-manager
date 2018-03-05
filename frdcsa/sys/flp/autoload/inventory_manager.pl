hasInventory([
	      [printerPaper,nightstandUnderPrinter],
	     ]).

hasModelNumber(acer3dMonitor,'HN274H').
thrownOut(acer3dMonitor).

hasManual(acer3dMonitor,fileFn('/var/lib/myfrdcsa/codebases/internal/digilib/data/collections/manuals/UM_Acer_1.0_eng_HN274H.pdf')).

hasManual(lacrossBC900BatteryCharger,fileFn('/var/lib/myfrdcsa/codebases/internal/digilib/data/collections/manuals/bc-900.pdf')).

acquireInformationIntoFLP(hasModelNumber(Item,ModelNumber),hasManual(Item,Manual)) :-
	isa(Item,product),
	belongsTo(Item,memberOfHouseholdFn(andrewDougherty)).

location(genericInstanceOfFn(eyeGlassRepairKit),in(topLeftDrawer,yellowUtilityShelfInDownstairsComputerRoom)).
location(ornamentPackaging,diningRoomCloset).
