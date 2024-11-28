% Función: esEstadoTerminal.m
function terminal = esEstadoTerminal(estado)
    % Verificar si alguien ha ganado
    if esGanador(estado, 1) || esGanador(estado, 2)
        terminal = true;
        return;
    end
    % Verificar si hay empate (tablero lleno)
    terminal = all(estado(:) ~= 0);
end






