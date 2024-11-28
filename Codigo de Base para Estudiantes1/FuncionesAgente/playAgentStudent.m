function [fila, columna] = playAgentStudent(tablero)
    % playAgentProfessor implementa un agente que juega el 'tic-tac-toe' usando MCTS puro.
    %
    % Entradas:
    %
    %         - tablero: [5x5] matriz conteniendo el estado actual del juego.
    %                   Cada posición de esta matriz contiene un elemento del conjunto
    %                   {0, 1, 2}. La codificación es la siguiente:
    %                   0 = posición disponible
    %                   1 = posición ocupada por el agente del estudiante
    %                   2 = posición ocupada por el agente del profesor o el
    %                       agente manual
    % Salidas:
    %
    %           - fila: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la fila donde
    %                  el agente ha colocado la marca actual
    %           - columna: [1x1] entero del conjunto {1, 2, 3, 4, 5} que indica la columna donde
    %                     el agente ha colocado la marca actual
    %
    % Autor: Tu Nombre
    % Email: tu.email@ejemplo.com

    % Definir tiempo máximo permitido en segundos
    tiempoMaximo = 5.0; % Ajusta según sea necesario
    startTime = tic; % Iniciar temporizador

    % Asignar el jugador actual (1 o 2)
    agent_player = 1; % Cambia a 1 si el agente es Jugador 1

    % Contar movimientos de cada jugador
    num_player1 = sum(tablero(:) == 1);
    num_player2 = sum(tablero(:) == 2);

    % Determinar el último jugador que movió
    if num_player1 > num_player2
        ultimoJugador = 1; % Jugador 1 fue el último en mover
    else
        ultimoJugador = 2; % Jugador 2 fue el último en mover
    end

    % Inicializar el árbol con la raíz
    nodoRaiz = NodoMCTS(tablero, [], ultimoJugador, []);

    % Verificar si el estado inicial es terminal
    if esEstadoTerminal(nodoRaiz.estado)
        error('El estado inicial es terminal. No se pueden realizar movimientos.');
    end

    % Realizar simulaciones hasta que se agote el tiempo
    simulacionesRealizadas = 0;
    while toc(startTime) < tiempoMaximo
        nodoActual = nodoRaiz;

        % Fase de Selección
        while ~isempty(nodoActual.hijos)
            nodoActual = nodoActual.seleccionarHijoUCB1();
            if nodoActual.visitas == 0
                break; % Nodo no visitado, detener la selección
            end
        end

        % Fase de Expansión
        if nodoActual.visitas > 0 && ~esEstadoTerminal(nodoActual.estado)
            nodoActual.expandir();
            if ~isempty(nodoActual.hijos)
                idx = randi(length(nodoActual.hijos));
                nodoActual = nodoActual.hijos(idx); % Seleccionar un hijo aleatorio para la simulación
            end
        end

        % Fase de Simulación
        resultado = nodoActual.simular(agent_player);

        % Fase de Retropropagación
        nodoActual.retropropagar(resultado, agent_player);

        simulacionesRealizadas = simulacionesRealizadas + 1;
    end

    tiempoTotal = toc(startTime); % Tiempo total de simulaciones
    fprintf('Simulaciones realizadas: %d en %.2f segundos\n', simulacionesRealizadas, tiempoTotal);

    % Seleccionar la mejor jugada basada en el mayor número de visitas
    if isempty(nodoRaiz.hijos)
        error('No se generaron movimientos durante las simulaciones.');
    end
    mejorHijo = nodoRaiz.seleccionarMejorHijo();
    movimiento = mejorHijo.movimiento;
    fila = movimiento(1);
    columna = movimiento(2);

    % Opcional: Inspeccionar las tasas de éxito de cada movimiento
    % Descomenta el siguiente bloque si deseas ver las tasas de éxito

    % fprintf('Tasas de éxito de los movimientos hijos:\n');
    % for i = 1:length(nodoRaiz.hijos)
    %     tasaExito = nodoRaiz.hijos(i).wins / nodoRaiz.hijos(i).visitas;
    %     fprintf('Movimiento (%d, %d): %.2f (Wins: %.2f, Visitas: %d)\n', ...
    %         nodoRaiz.hijos(i).movimiento(1), nodoRaiz.hijos(i).movimiento(2), ...
    %         tasaExito, nodoRaiz.hijos(i).wins, nodoRaiz.hijos(i).visitas);
    % end
end
