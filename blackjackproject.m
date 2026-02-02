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

while keepPlaying
    
    % reset hands each round
    playerHands = cell(1, numPlayers);
    dealerHand = [];
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
        fprintf('Value: %d\n\n', handValue(playerHands{p}));
    end
    
    fprintf('Dealer shows: ');
    displayHand(dealerHand(1));
    
    %% Playing the game
    
    % Play each player's hand. Player 1 is user, players 2, 3, ... are bots
    
    for p = 1:numPlayers
        fprintf('\n=== Player %d Turn ===\n', p);
        [playerHands{p}, playingDeck] = playHand(playerHands{p}, playingDeck, isHuman(p));
    end
    
    % Dealer turn (hit until 17)
    
    fprintf('\n=== Dealer Turn ===\n');
    fprintf('Dealer hand: ');
    displayHand(dealerHand);
    fprintf('Value: %d\n', handValue(dealerHand));
    
    while handValue(dealerHand) < 17
        [dealerHand, playingDeck] = dealCards(playingDeck, dealerHand);
    
        fprintf('Dealer hits: ');
        displayHand(dealerHand);
        fprintf('Value: %d\n', handValue(dealerHand));
    end
    
    if handValue(dealerHand) > 21
        fprintf('Dealer BUSTS!\n');
    else
        fprintf('Dealer stands.\n');
    end
    
    % Evaluate results
    
    dealerVal = handValue(dealerHand);
    
    fprintf('\n=== RESULTS ===\n');
    fprintf('Dealer final (%d): ', dealerVal);
    displayHand(dealerHand);
    
    for p = 1:numPlayers
        playerVal = handValue(playerHands{p});
    
        fprintf('Player %d final (%d): ', p, playerVal);
        displayHand(playerHands{p});
    
        if playerVal > 21
            fprintf('-> LOSE (bust)\n\n');
        elseif dealerVal > 21
            fprintf('-> WIN (dealer bust)\n\n');
        elseif playerVal > dealerVal
            fprintf('-> WIN\n\n');
        elseif playerVal < dealerVal
            fprintf('-> LOSE\n\n');
        else
            fprintf('-> PUSH\n\n');
        end
    end
    
    % play again prompt
    
    resp = lower(input('Play again? (y/n): ', 's'));
    while ~(resp == "y" || resp == "n")
        resp = lower(input('Enter y or n: ', 's'));
    end
    
    if resp == "n"
        keepPlaying = false;
    end
end

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

function total = handValue(hand)
    % returns the value of the hand
    % ace is 11, unless total value > 21, then ace becomes 1
    
    vals = [hand.value];
    total = sum(vals);
    
    % Ace logic
    numAces = sum(vals == 11);
    while (total > 21 && numAces > 0)
        % turn ace value from 11 -> 1
        total = total - 10; 
        numAces = numAces - 1;
    end
end

function [hand, shuffledDeck] = playHand(hand, shuffledDeck, isHuman)
    % Human: prompt hit/stand.
    % Bot: hit until value >= 17.
    
    if isHuman
        while true
            fprintf('Your hand: ');
            displayHand(hand);
            fprintf('Value: %d\n', handValue(hand));
    
            % bust check
            if handValue(hand) > 21
                fprintf('BUST!\n');
                break;
            end
    
            choice = lower(input('Hit or Stand? (h/s): ', 's'));
            while ~(choice == "h" || choice == "s")
                choice = lower(input('Enter h or s: ', 's'));
            end
    
            if choice == "s"
                fprintf('Stand.\n');
                break;
            end
    
            % Hit
            [hand, shuffledDeck] = dealCards(shuffledDeck, hand);
        end
    else
        % bot: dealer rules
        while handValue(hand) < 17
            [hand, shuffledDeck] = dealCards(shuffledDeck, hand);
        end
    
        fprintf('Bot stands with value %d.\n', handValue(hand));
    end
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
