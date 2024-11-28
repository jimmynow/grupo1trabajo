function [fila, columna] = playAgentStudent(tablero)
    % playAgentProfessor implementa un agente que juega el 'tic-tac-toe' usando MCTS puro.
    %
    % Entradas:
    %
    %         - tablero: [5x5] matriz conteniendo el estado actual del juego.
    %                   Cada posici�n de esta matriz contiene un elemento del conjunto
    %                   {0, 1, 2}. La codificaci�n es la siguiente:
    %                   0 = posici�n disponible
    %                   1 = posici�n ocupada por el agente del estudiante
    %                   2 = posici�n ocupada por el agente del profesor o el
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

    % Definir tiempo m�ximo permitido en segundos
    tiempoMaximo = 5.0; % Ajusta seg�n sea necesario
    startTime = tic; % Iniciar temporizador

    % Asignar el jugador actual (1 o 2)
    agent_player = 1; % Cambia a 1 si el agente es Jugador 1

    % Contar movimientos de cada jugador
    num_player1 = sum(tablero(:) == 1);
    num_player2 = sum(tablero(:) == 2);

    % Determinar el �ltimo jugador que movi�
    if num_player1 > num_player2
        ultimoJugador = 1; % Jugador 1 fue el �ltimo en mover
    else
        ultimoJugador = 2; % Jugador 2 fue el �ltimo en mover
    end

    % Inicializar el �rbol con la ra�z
    nodoRaiz = NodoMCTS(tablero, [], ultimoJugador, []);

    % Verificar si el estado inicial es terminal
    if esEstadoTerminal(nodoRaiz.estado)
        error('El estado inicial es terminal. No se pueden realizar movimientos.');
    end

    % Realizar simulaciones hasta que se agote el tiempo
    simulacionesRealizadas = 0;
    while toc(startTime) < tiempoMaximo
        nodoActual = nodoRaiz;

        % Fase de Selecci�n
        while ~isempty(nodoActual.hijos)
            nodoActual = nodoActual.seleccionarHijoUCB1();
            if nodoActual.visitas == 0
                break; % Nodo no visitado, detener la selecci�n
            end
        end

        % Fase de Expansi�n
        if nodoActual.visitas > 0 && ~esEstadoTerminal(nodoActual.estado)
            nodoActual.expandir();
            if ~isempty(nodoActual.hijos)
                idx = randi(length(nodoActual.hijos));
                nodoActual = nodoActual.hijos(idx); % Seleccionar un hijo aleatorio para la simulaci�n
            end
        end

        % Fase de Simulaci�n
        resultado = nodoActual.simular(agent_player);

        % Fase de Retropropagaci�n
        nodoActual.retropropagar(resultado, agent_player);

        simulacionesRealizadas = simulacionesRealizadas + 1;
    end

    tiempoTotal = toc(startTime); % Tiempo total de simulaciones
    fprintf('Simulaciones realizadas: %d en %.2f segundos\n', simulacionesRealizadas, tiempoTotal);

    % Seleccionar la mejor jugada basada en el mayor n�mero de visitas
    if isempty(nodoRaiz.hijos)
        error('No se generaron movimientos durante las simulaciones.');
    end
    mejorHijo = nodoRaiz.seleccionarMejorHijo();
    movimiento = mejorHijo.movimiento;
    fila = movimiento(1);
    columna = movimiento(2);

    % Opcional: Inspeccionar las tasas de �xito de cada movimiento
    % Descomenta el siguiente bloque si deseas ver las tasas de �xito

    % fprintf('Tasas de �xito de los movimientos hijos:\n');
    % for i = 1:length(nodoRaiz.hijos)
    %     tasaExito = nodoRaiz.hijos(i).wins / nodoRaiz.hijos(i).visitas;
    %     fprintf('Movimiento (%d, %d): %.2f (Wins: %.2f, Visitas: %d)\n', ...
    %         nodoRaiz.hijos(i).movimiento(1), nodoRaiz.hijos(i).movimiento(2), ...
    %         tasaExito, nodoRaiz.hijos(i).wins, nodoRaiz.hijos(i).visitas);
    % end
end
