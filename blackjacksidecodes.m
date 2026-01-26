clc
clear
myDeck = [1:52]
shuffledDeck = myDeck(randperm(length(myDeck)))
playerHand = shuffledDeck(1:2)
shuffledDeck (playerHand) = []
