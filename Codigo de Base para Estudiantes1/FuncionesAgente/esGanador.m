% Función: esGanador.m
function ganador = esGanador(estado, jugador)
    estadoJugador = (estado == jugador);

    % Verificar filas
    for i = 1:size(estado, 1)
        fila = estadoJugador(i, :);
        if any(conv(double(fila), ones(1, 4), 'valid') == 4)
            ganador = true;
            fprintf('Jugador %d ha ganado en la fila %d.\n', jugador, i);
            return;
        end
    end

    % Verificar columnas
    for j = 1:size(estado, 2)
        columna = estadoJugador(:, j)';
        if any(conv(double(columna), ones(1, 4), 'valid') == 4)
            ganador = true;
            fprintf('Jugador %d ha ganado en la columna %d.\n', jugador, j);
            return;
        end
    end

    % Verificar diagonales
    diagonales = obtenerDiagonales(estadoJugador);
    for k = 1:length(diagonales)
        diagVec = diagonales{k};
        if length(diagVec) >= 4
            if any(conv(double(diagVec), ones(1, 4), 'valid') == 4)
                ganador = true;
                fprintf('Jugador %d ha ganado en la diagonal %d.\n', jugador, k);
                return;
            end
        end
    end

    ganador = false;
end