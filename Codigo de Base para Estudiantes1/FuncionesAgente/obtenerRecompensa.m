% Función: obtenerRecompensa.m
function recompensa = obtenerRecompensa(estado, agent_player)
    if esGanador(estado, agent_player)
        recompensa.jugadorGanador = agent_player;
        recompensa.valor = 1; % Victoria
    elseif esGanador(estado, 3 - agent_player)
        recompensa.jugadorGanador = 3 - agent_player;
        recompensa.valor = -1; % Derrota
    else
        recompensa.jugadorGanador = 0;
        recompensa.valor = 0; % Empate
    end
end
