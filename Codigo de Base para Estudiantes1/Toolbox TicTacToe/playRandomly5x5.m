function [row, col] = playRandomly5x5(board)
% This function implements an agent that plays randomly
%
% Marco E. Benalc�zar, Ph.D.
% marco.benalcazar@epn.edu.ec
board = board';
board = board(:)';
% Encuentra las posiciones que no han sido ocupadas por ning�n jugador
vector = 1:25;
availablePositions = vector(board == 0);
% Selecciona aleatoriamente una posici�n vac�a
[dummy, idx] = sort(  rand( size(availablePositions) )  );
[col, row] = ind2sub(  [5 5], availablePositions( idx(1) )  );
return