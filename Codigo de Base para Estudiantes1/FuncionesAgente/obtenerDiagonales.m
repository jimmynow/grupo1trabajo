% Función: obtenerDiagonales.m
function diagonales = obtenerDiagonales(matrix)
    diagonales = {};
    [rows, cols] = size(matrix);

    % Diagonales principales
    for offset = -rows+1:cols-1
        diagVec = diag(matrix, offset);
        if length(diagVec) >= 4
            diagonales{end+1} = diagVec;
        end
    end

    % Diagonales secundarias
    flippedMatrix = fliplr(matrix);
    for offset = -rows+1:cols-1
        diagVec = diag(flippedMatrix, offset);
        if length(diagVec) >= 4
            diagonales{end+1} = diagVec;
        end
    end
end
