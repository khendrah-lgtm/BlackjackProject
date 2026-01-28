clc
clear
newDeck = [1:52]
shuffledDeck = myDeck(randperm(length(myDeck)))
playerHand = shuffledDeck(1:2)
shuffledDeck (playerHand) = []
% can look up heart, diamond, spades, clubs symbols, matlab character
% reshape function -> 