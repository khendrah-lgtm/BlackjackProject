clear
clc

myVals = [2:10,10,10,10,11];
myVals = repmat(myVals, [1,4]);

myNames = [2:10,"Jack","Queen","King","Ace"];
myNames = repmat(myNames, [1,4]);

nowSuits = [repmat("Hearts", [1,13]), repmat("Diamonds", [1,13]), repmat("Spades", [1,13]), repmat("Clubs", [1,13])];

myDeck = table();
myDeck.values= myVals';
myDeck.suits = nowSuits';
myDeck.names=myNames';
myDeck.cardName= myDeck.names + " of " + myDeck.suits; % call card value and suit for each player 

myPlayers= table();
nPlayers= input("How many players at the table? "); 


names = [];
for i=1:nPlayers
    names{i} = string(input("Player "+i+" name: ", "s"));
end

myPlayers.name= names';
myPlayers.money= repmat(10, [nPlayers,1]) % (money, [player, 1])

playingDeck=myDeck; % needs shuffling!!
%for i= (1:nPlayers)
    % myPlayers.hand(i)= playingdeck.cardName(1)
     %update playing deck
     %playingDeck(1,:) = [];
    