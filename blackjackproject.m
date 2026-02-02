%% Blackjack Code

clear all % Clear workspace variables
clc       % Clear command window

%% Setup
% Display the rules of Blackjack once the program runs:

fprintf('\nBLACKJACK RULES: \n');
fprintf('Goal: Get as close to 21 as possible without going over\n');
fprintf('Card values: 2-10 = face value, J/Q/K = 10, Ace = 11 or 1\n');
fprintf('BUST: If your total goes over 21, you lose immediately\n');
fprintf('Turns:\n');
fprintf('  - Player 1 (you): choose Hit (h) to take a card or Stand (s) to stop\n');
fprintf('  - Other players (bots): hit until total >= 17\n');
fprintf('Dealer:\n');
fprintf('  - Dealer hits until total >= 17\n');
fprintf('Winning:\n');
fprintf('  - If you bust: you lose\n');
fprintf('  - If dealer busts and you do not: you win\n');
fprintf('  - Otherwise higher total wins\n');
fprintf('  - Equal totals = PUSH (tie)\n');
fprintf('  \n'); % for spacing
fprintf('  \n');


%% Initialize the start of the program
% Prompt the user for the number of players (players must be 2 or greater)
numPlayers = input('Want to play? Enter the number of players, must be 2 or greater ');


% Validate the user's input (must be an integer of 2 or greater)
while numPlayers < 2 || numPlayers ~= floor(numPlayers) 
    numPlayers = input("Enter a valid number of players. Must be 2 or greater");
end

keepPlaying = true; % Controls whether the game repeats

%% Main game loop
% Runs one full Blackjack round per iteration:
while keepPlaying
    
    %% Game Initialization
    % Identify the real player and the bot players:
    isHuman = false(1, numPlayers); % Logical array for player types
    isHuman(1) = true;              % Identify that "Player 1" is the real player
    
    % Create and shuffle a fresh deck:
    myDeck = innitDeck();
    % shuffle deck
    playingDeck = shuffleDeck(myDeck);

    % Deal the initial hands to the players and dealer:
    [playerHands, dealerHand, playingDeck] = dealInitialHands(playingDeck, numPlayers);
    
    % Display each player's starting hand and value:
    for p = 1:numPlayers
        fprintf('Player %d hand: ', p);
        displayHand(playerHands{p});
        fprintf('Value: %d\n\n', handValue(playerHands{p}));
    end

    % Show only the dealer's face-up card:
    fprintf('Dealer shows: ');
    displayHand(dealerHand(1));
    
    %% Playing the game
    % Each player plays their hand in order (note: Player 1 is the real player, Players 2, 3, ... are bots):
    for p = 1:numPlayers
        fprintf('\nPlayer %d Turn\n', p);
        [playerHands{p}, playingDeck] = playHand(playerHands{p}, playingDeck, isHuman(p), playerHands, dealerHand, p);
        pause(1); % Pause for 1 second for readability
    end
    
    % Dealer plays according to the dealer rules (hit until >= 17):
    fprintf('\nDealer Turn\n');
    fprintf('Dealer hand: ');
    displayHand(dealerHand);
    fprintf('Value: %d\n', handValue(dealerHand));
    
    while handValue(dealerHand) < 17
        [dealerHand, playingDeck] = dealCards(playingDeck, dealerHand);
        fprintf('Dealer hits: ');
        displayHand(dealerHand);
        fprintf('Value: %d\n', handValue(dealerHand));
        pause(1); % Pause for 1 second for readability
    end
    
    if handValue(dealerHand) > 21
        fprintf('Dealer BUSTS!\n');
    else
        fprintf('Dealer stands.\n');
    end
    
    % Compare each player's final hand against the dealer:
    dealerVal = handValue(dealerHand);
    
    fprintf('\nFINAL RESULTS\n');
    fprintf('Dealer final (%d): ', dealerVal);
    displayHand(dealerHand);
    
    for p = 1:numPlayers
        playerVal = handValue(playerHands{p});
    
        fprintf('Player %d final (%d): ', p, playerVal);
        displayHand(playerHands{p});

        % Determine win/loss/tie conditions:
        if playerVal > 21
            fprintf('-> LOSE (bust)\n\n');
        elseif dealerVal > 21
            fprintf('-> WIN (dealer bust)\n\n');
        elseif playerVal > dealerVal
            fprintf('-> WIN\n\n');
        elseif playerVal < dealerVal
            fprintf('-> LOSE\n\n');
        else
            fprintf('-> PUSH (TIE)\n\n');
        end
    end
    
    % Ask the user whether they want to play another round:
    resp = input('Play again? (y/n): ', 's');

    while isempty(resp) || ~(resp(1) == 'y' || resp(1) == 'n')
        resp = input('Enter y or n: ', 's');
    end
    
    if resp(1) == 'n'
        keepPlaying = false; % Exit the main game loop
    end
end

% Thank the user for playing:
fprintf('\nThank you for playing Blackjack!!!\n');


%% Local Functions
% This section contains all helper functions used by Blackjack (each function performs a specific task to organize the main script):

function myDeck = innitDeck()
    % Creates and returns a standard 52-card deck as an array
    % Each card contains a suit, rank, and Blackjack value
    % Ace is initialized with a value of 11

    % Define each card suit:
    suits = ["Hearts","Diamonds","Clubs","Spades"];

    % Define each card rank:
    ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"];

    % Define Blackjack values corresponding to each rank:
    values = [11, 2,3,4,5,6,7,8,9,10,10,10,10]; % Ace starts as 11

    % Preallocate deck array for efficiency
    myDeck(52) = struct('suit',"", 'rank',"", 'value',0);
    
    idx = 1; % Define index to track position in the deck

    % Loops through each suit and rank to build a full deck:
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
    % Randomly shuffles the input deck of cards
    % Input: myDeck (array of cards)
    % Output: shuffledDeck (randomly reordered deck)

    % Generate random permutation of deck indices:
    order = randperm(length(myDeck));

    % Reorder the deck based on random indices:
    shuffledDeck = myDeck(order);
end

function [playerHands, dealerHand, deck] = dealInitialHands(deck, numPlayers)
% Deals the initial two cards to each player and the dealer
% Inputs:
%    deck       - shuffled deck of cards
%    numPlayers - number of players in the game
% Outputs:
%    playerHands - cell array of player hands
%    dealerHand  - dealer's hand
%    deck        - updated deck after dealing

    % Initialize player hands as a cell array:
    playerHands = cell(1, numPlayers);

    % Initialize dealer hand:
    dealerHand = [];

    % Deal two cards to each player:
    for p = 1:numPlayers
        [playerHands{p}, deck] = dealCards(deck, playerHands{p});
        [playerHands{p}, deck] = dealCards(deck, playerHands{p});
    end

    % Deal two cards to the dealer:
    [dealerHand, deck] = dealCards(deck, dealerHand);
    [dealerHand, deck] = dealCards(deck, dealerHand);
end

function [hand, shuffledDeck] = dealCards(shuffledDeck, hand)
% Deals one card from the top of the deck to a hand
% Remove the dealt card from the deck
% Inputs
%    shuffledDeck - current deck of cards
%    hand         - current hand
% Outputs:
%    shuffledDeck - updated decj wutg tio card removed
%    hand -       updated hand with new card

    % Add top card of the deck to hand:
    hand = [hand, shuffledDeck(1)];

    % Remove top card from the deck:
    shuffledDeck(1) = [];
end

function displayHand(hand)
% Display all cards in a hand in the command window with the format "Rank of Suit"
    
    % Loop throug heach card in the hand
    for i = 1:length(hand)
        fprintf('%s of %s', hand(i).rank, hand(i).suit);

        % Add a comma between cards (except the last card):
        if i < length(hand)
            fprintf(', ');
        end
    end

    % Move to the next line after displaying hand:
    fprintf('\n');
end

function total = handValue(hand)
% Calculates the total Blackjack value of a hand
% Aces are counted as 11 unless total exceeds 21, in which case Aces are reduced to 1 as needed

    % Extract values from hand:
    vals = [hand.value];

    % Compute initial total:
    total = sum(vals);
    
    % Count the number of Aces in hand:
    numAces = sum(vals == 11);
    
    % Convert Aces from 11 to 1 if total exceeds 21:
    while (total > 21 && numAces > 0)
        % turn ace value from 11 -> 1
        total = total - 10; 
        numAces = numAces - 1;
    end
end

function [hand, shuffledDeck] = playHand(hand, shuffledDeck, isHuman, playerHands, dealerHand, playerIndex)
% Execute a single player's turn
% The real player can choose to hit or stand
% The bot players follow dealer rules (hit until >= 17)
    
    if isHuman
        % Real player's turn:
        while true
            fprintf('Your hand: ');
            displayHand(hand);
            fprintf('Value: %d\n', handValue(hand));
    
            % Check for bust:
            if handValue(hand) > 21
                fprintf('BUST!\n');
                break;
            end

            % Prompt the real player's decision to hit or stand:    
            choice = lower(input('Hit or Stand? (h/s): ', 's'));
            while ~(choice == 'h' || choice == 's')
                choice = lower(input('Enter h or s: ', 's'));
            end

            % Stand ends turn:
            if choice == 's'
                fprintf('Stand.\n');
                break;
            end
    
            % Hit deals another card
            [hand, shuffledDeck] = dealCards(shuffledDeck, hand);
            
            % Update the results after hitting:
            playerHands{playerIndex} = hand;
            showTable(playerHands, dealerHand, true);
            pause(1); % Pause 1 second for readability
        end
    else
        % Bot players' turn (dealer-rule logic):
        while handValue(hand) < 17
            [hand, shuffledDeck] = dealCards(shuffledDeck, hand);
            playerHands{playerIndex} = hand;
            showTable(playerHands, dealerHand, true);
            pause(1); % Pause 1 second for readability
        end
    
        fprintf('Bot stands with value %d.\n', handValue(hand));
    end
end

function showTable(playerHands, dealerHand, hideDealerHoleCard)
% Displays the current game state, including all players' hands and the dealer's hand
    
    fprintf('\nRESULTS\n');
    
    % Display dealer's hand:
    fprintf('Dealer: ');
    if hideDealerHoleCard && length(dealerHand) >= 1
        displayHand(dealerHand(1)); % Show only face-up card
    else
        displayHand(dealerHand);
        fprintf('Value: %d\n', handValue(dealerHand));
    end
    
    % Display each player's hand and value:
    for p = 1:length(playerHands)
        fprintf('Player %d: ', p);
        displayHand(playerHands{p});
        fprintf('Value: %d\n', handValue(playerHands{p}));
    end
end


%{ 
Original Pseudocode:

%% Blackjack Pseudocode

clear
clc

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
%}
