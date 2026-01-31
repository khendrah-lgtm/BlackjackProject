%% Blackjack Pseudocode

clear
clc

%% test change

%% Player input initialization
% Need inputs for how many players and initial $
% Need larger loop for how long to play
% Initialize player variables

%% Game Initialization
myDeck=innitDeck();
playingDeck=shuffleDeck(myDeck);
%% Main Loop
while(number of players>0 or players decide to end)


% take initial bets
playingDeck=shuffleDeck(myDeck)


% create loop for dealing cards
% display information in command window, needs to be for players and dealer

% hit/stand logic, use functions from below

end


%% my local functions
function shuffledDeck=shuffleDeck(myDeck)
% use randperm to shuffle deck, numbers 1-52
% return shuffled deck
end

function myDeck=innitDeck()
% create a loop for each suit
% should my deck be: array, tables, structures
% Align card values, suits
end

function [updatedPlayer, updatedDeck]=dealCards(shuffledDeck, player)
% think about player variable: arrays, tables, structures
% update player hand, calculate player hand value
% if hand > 21, and contains an Ace -> make the Ace value = 1
% use evaluateHand function here
% update shuffledDeck to remove cards delt, shuffledDeck(1)=[];
end

function [player, handValue]=evaluateHand(player, dealerHand)
% need logic to determine if player wins against dealer
end

function updatedDealer=dealerLogic(dealerHand)
% need logic here to determine if the dealer should hit or stand
% while loop, dealer hand <17 dealer needs to hit
end
