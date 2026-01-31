%% Blackjack Pseudocode

clear
clc

%% Player input initialization
% Need inputs for how many players and initial $
% Need larger loop for how long to play
% Initialize player variables

% Leo's thoughts:
% 1. Get the number of players, ideally >=2
% 2. Get players struct array
    % - player 1 is the user
    % - player 2 is a bot

numPlayers = input('Enter the number of players, must be 2 or greater ');
% Check if the number of players entered is valid
while numPlayers < 2 || numPlayers ~= floor(numPlayers) 
    numPlayers = input("Enter a valid number of players. Must be 2 or greater");
end

keepPlaying = true;

%% Game Initialization
% set the humans vs the bots
isHuman = false(1, numPlayers);
isHuman(1) = true;

% create deck
myDeck = innitDeck();
% shuffle deck
playingDeck = shuffleDeck(myDeck);

% hands: each player gets a struct array of cards
playerHands = cell(1, numPlayers);
dealerHand = [];

% deal 2 cards to each player
for p = 1:numPlayers
    [playerHands{p}, playingDeck] = dealCards(playingDeck, playerHands{p});
    [playerHands{p}, playingDeck] = dealCards(playingDeck, playerHands{p});
end

% deal 2 cards to dealer
[dealerHand, playingDeck] = dealCards(playingDeck, dealerHand);
[dealerHand, playingDeck] = dealCards(playingDeck, dealerHand);

% Display initial hands

for p = 1:numPlayers
    fprintf('Player %d hand: ', p);
    displayHand(playerHands{p});
end

fprintf('Dealer shows: ');
displayHand(dealerHand(1));

%% Local Functions:

function myDeck = innitDeck()

    % create a loop for each suit
    % should my deck be: array, tables, structures
    % Align card values, suits

    suits = ["Hearts","Diamonds","Clubs","Spades"];
    ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"];
    values = [11, 2,3,4,5,6,7,8,9,10,10,10,10]; % Ace starts as 11
    myDeck(52) = struct('suit',"", 'rank',"", 'value',0);
    
    idx = 1;
    for s = 1:length(suits)
        for r = 1:length(ranks)
            myDeck(idx).suit = suits(s);
            myDeck(idx).rank = ranks(r);
            myDeck(idx).value = values(r);
            idx = idx + 1;
        end
    end
end 

function shuffledDeck = shuffleDeck(myDeck)
    % use randperm to shuffle deck, numbers 1-52
    % return shuffled deck
    % Shuffle deck using randperm (1-52)
    
    order = randperm(length(myDeck));
    shuffledDeck = myDeck(order);
end

function [hand, shuffledDeck] = dealCards(shuffledDeck, hand)
    % Take the top card from the deck and add it to the hand.
    % Remove that card from the deck (shuffledDeck(1)=[]).
    
    hand = [hand, shuffledDeck(1)];
    shuffledDeck(1) = [];
end

function displayHand(hand)
% Display cards in the command window as "Rank of Suit"
    for i = 1:length(hand)
        fprintf('%s of %s', hand(i).rank, hand(i).suit);
        if i < length(hand)
            fprintf(', ');
        end
    end
        fprintf('\n');
end

%{
%% Main Loop
while(number of players>0 or players decide to end)


% take initial bets
playingDeck=shuffleDeck(myDeck)


% create loop for dealing cards
% display information in command window, needs to be for players and dealer

% hit/stand logic, use functions from below

end


%% my local functions

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
%}
