-- Team 20: Fatima Rizvi and Michael Yanez
-- The queries below were originally our own. Github copilot was used to verify that all necessary types of queries were included in the DML file, but it did not write the queries. After we got out step 3 feedback, we used GitHub copilot to add ordering to some of the queries with the following prompt.

-- Select all rows from MartialArts
select * from MartialArts
order by name;

-- Select a specific MartialArts record by ID
select * from MartialArts
where martialArtID = :the_selected_MartialArtID;

-- Select all rows from Moves
select * from Moves
order by name;

-- Select a specific Moves record by ID
select * from Moves
where moveID = :the_selected_MoveID;

-- Select all moves that match a given martial arts type
select Moves.name as moveName, Moves.description as moveDescription
from Moves
inner join MartialArtMoves on Moves.moveID = MartialArtMoves.moveID
inner join MartialArts on MartialArtMoves.martialArtID = MartialArts.martialArtID
where MartialArts.martialArtID = :the_selected_MartialArtID
order by Moves.name;

-- Select all rows from MartialArtMoves
select MartialArtMoves.martialArtID, MartialArtMoves.moveID,
       MartialArts.name as martialArtName, Moves.name as moveName
from MartialArtMoves
inner join MartialArts on MartialArtMoves.martialArtID = MartialArts.martialArtID
inner join Moves on MartialArtMoves.moveID = Moves.moveID
order by MartialArts.name, Moves.name;

-- Select a specific MartialArtMoves record
select MartialArtMoves.martialArtID, MartialArtMoves.moveID,
       MartialArts.name as martialArtName, Moves.name as moveName
from MartialArtMoves
inner join MartialArts on MartialArtMoves.martialArtID = MartialArts.martialArtID
inner join Moves on MartialArtMoves.moveID = Moves.moveID
where MartialArtMoves.martialArtID = :the_selected_MartialArtID
and MartialArtMoves.moveID = :the_selected_MoveID;

-- Select a specific MartialArtMoves record and display the move's name, type of martial art, and the description.
select Moves.name as moveName, MartialArts.name as martialArtName,
       Moves.description as moveDescription
from MartialArtMoves
inner join Moves on MartialArtMoves.moveID = Moves.moveID
inner join MartialArts on MartialArtMoves.martialArtID = MartialArts.martialArtID
where MartialArtMoves.martialArtID = :the_selected_MartialArtID 
and MartialArtMoves.moveID = :the_selected_MoveID;

-- Select all rows from Events
select Events.eventID, Events.name as eventName, Events.date,
       Events.martialArtID, MartialArts.name as martialArtName
from Events
left join MartialArts on Events.martialArtID = MartialArts.martialArtID
order by Events.name;

-- Select all events that match a chosen martial arts type
select Events.eventID, Events.name as eventName, Events.date,
       Events.martialArtID, MartialArts.name as martialArtName
from Events
left join MartialArts on Events.martialArtID = MartialArts.martialArtID
where Events.martialArtID = :the_selected_MartialArtID
order by Events.name;

-- Select a specific Events record
select Events.eventID, Events.name as eventName, Events.date,
       Events.martialArtID, MartialArts.name as martialArtName
from Events
left join MartialArts on Events.martialArtID = MartialArts.martialArtID
where Events.eventID = :the_selected_EventID;

-- Select all rows from StudySessions
select StudySessions.studySessionID, StudySessions.date as sessionDate,
       StudySessions.duration as sessionDuration, StudySessions.martialArtID,
       StudySessions.eventID, MartialArts.name as martialArtName,
       Events.name as eventName
from StudySessions
inner join MartialArts on StudySessions.martialArtID = MartialArts.martialArtID
left join Events on StudySessions.eventID = Events.eventID
order by MartialArts.name, Events.name;

-- Select all study session records that match a chosen martial arts type
select StudySessions.studySessionID, StudySessions.date as sessionDate,
       StudySessions.duration as sessionDuration, StudySessions.martialArtID,
       StudySessions.eventID, MartialArts.name as martialArtName,
       Events.name as eventName
from StudySessions
inner join MartialArts on StudySessions.martialArtID = MartialArts.martialArtID
left join Events on StudySessions.eventID = Events.eventID
where StudySessions.martialArtID = :the_selected_MartialArtID
order by MartialArts.name, Events.name;

-- Select a specific StudySessions record
select StudySessions.studySessionID, StudySessions.date as sessionDate,
       StudySessions.duration as sessionDuration, StudySessions.martialArtID,
       StudySessions.eventID, MartialArts.name as martialArtName,
       Events.name as eventName
from StudySessions
inner join MartialArts on StudySessions.martialArtID = MartialArts.martialArtID
left join Events on StudySessions.eventID = Events.eventID
where StudySessions.studySessionID = :the_selected_StudySessionID;

-- Insert a new MartialArts type
insert into MartialArts (name)
values (:martialArtName_input)

-- Insert a new Moves record
insert into Moves (name, description)
values (:moveName_input, :moveDescription_input)

-- Insert a MartialArtMoves relationship
insert into MartialArtMoves (martialArtID, moveID)
values (:martialArtID_for_the_selected_martial_art, :moveID_for_the_new_move)

-- Insert a new Events record
insert into Events (name, date, martialArtID)
values (:eventName_input, :eventDate_input, :martialArtID_for_the_selected_martial_art)

-- Insert a new StudySessions record
insert into StudySessions (date, duration, martialArtID, eventID)
values (:studySessionDate_input, :studySessionDuration_input, :martialArtID_for_the_selected_martial_art, :eventID_for_the_selected_event)

-- Update a MartialArtMoves relationship
update MartialArtMoves 
set martialArtID = :martialArtID_input, moveID = :moveID_input 
where martialArtID = :the_original_MartialArtID 
and moveID = :the_original_MoveID

-- Update a Moves record
update Moves
set name = :moveName_input, description = :moveDescription_input
where moveID = :the_selected_MoveID

-- Delete one MartialArtMoves relationship
delete from MartialArtMoves
where martialArtID = :the_selected_MartialArtID 
and moveID = :the_selected_MoveID

-- Delete an Events record
delete from Events
where eventID = :the_selected_EventID;