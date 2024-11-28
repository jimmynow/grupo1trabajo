classdef NodoMCTS < handle
    properties
        estado          % Estado del tablero en este nodo (5x5 matriz)
        padre           % Referencia al nodo padre (NodoMCTS)
        hijos           % Arreglo de nodos hijos (NodoMCTS)
        visitas = 0     % Número de veces que este nodo ha sido visitado
        wins = 0        % Suma de recompensas obtenidas a través de este nodo
        ultimoJugador   % Jugador que realizó el movimiento para llegar a este nodo (1 o 2)
        movimiento      % Movimiento que llevó a este estado ([fila, columna])
    end
    methods
        function obj = NodoMCTS(estado, padre, ultimoJugador, movimiento)
            obj.estado = estado;
            obj.padre = padre;
            obj.ultimoJugador = ultimoJugador; % Jugador que realizó el movimiento
            obj.movimiento = movimiento;       % Movimiento que llevó a este nodo
            obj.hijos = [];                    % Inicializar arreglo de hijos
        end

        function hijo = seleccionarHijoUCB1(obj)
            % Selecciona el hijo con el mayor valor UCB1
            c = 1.4; % Ajusta este valor para equilibrar exploración y explotación
            totalVisitas = obj.visitas;

            visitasHijos = [obj.hijos.visitas];
            valorHijos = [obj.hijos.wins];

            % Evitar división por cero
            visitasHijos(visitasHijos == 0) = eps;

            % Calcular la tasa media de recompensas
            exploit = valorHijos ./ visitasHijos;

            % Calcular el término de exploración
            explore = c * sqrt(log(totalVisitas) ./ visitasHijos);

            % Calcular los valores UCB1
            valoresUCB1 = exploit + explore;

            % Seleccionar el hijo con el valor UCB1 máximo
            [~, idx] = max(valoresUCB1);
            hijo = obj.hijos(idx);
        end

        function expandir(obj)
            % Expande el nodo generando todos los posibles movimientos hijos
            if ~isempty(obj.hijos)
                return; % Ya está expandido
            end

            movimientos = obtenerMovimientos(obj.estado);
            numMovimientos = size(movimientos, 1);
            if numMovimientos == 0
                return; % No hay movimientos para expandir
            end

            % Crear hijos para cada movimiento válido
            for i = 1:numMovimientos
                movimiento = movimientos(i, :);
                nuevoEstado = obj.estado;
                nuevoEstado(movimiento(1), movimiento(2)) = 3 - obj.ultimoJugador;

                % Crear nuevo nodo hijo
                nuevoNodo = NodoMCTS(nuevoEstado, obj, 3 - obj.ultimoJugador, movimiento); % Cambiar de jugador
                obj.hijos = [obj.hijos, nuevoNodo];
            end
        end

        function mejorHijo = seleccionarMejorHijo(obj)
            % Selecciona el hijo con la mejor tasa de éxito
            hijos = [obj.hijos];
            visitas = [hijos.visitas];
            wins = [hijos.wins];
            tasasExito = wins ./ visitas;
            [~, idx] = max(tasasExito);
            mejorHijo = hijos(idx);
        end

        function resultado = simular(obj, agent_player)
            % Realiza una simulación desde este nodo hasta un estado terminal de forma completamente aleatoria
            estadoActual = obj.estado;
            jugadorSimulacion = 3 - obj.ultimoJugador; % Jugador que realizará el próximo movimiento

            while ~esEstadoTerminal(estadoActual)
                movimientos = obtenerMovimientos(estadoActual);
                if isempty(movimientos)
                    break; % No hay movimientos disponibles
                end

                % Seleccionar un movimiento aleatorio
                idx = randi(size(movimientos, 1));
                movimiento = movimientos(idx, :);
                estadoActual(movimiento(1), movimiento(2)) = jugadorSimulacion;

                % Cambiar de jugador
                jugadorSimulacion = 3 - jugadorSimulacion;
            end

            % Recompensa para el agente
            recompensa = obtenerRecompensa(estadoActual, agent_player);
            resultado = recompensa.valor;
        end

        function retropropagar(obj, recompensa, agent_player)
            % Retropropaga la recompensa desde este nodo hasta la raíz
            nodoActual = obj;
            recompensaActual = recompensa;

            while ~isempty(nodoActual)
                nodoActual.visitas = nodoActual.visitas + 1;

                if nodoActual.ultimoJugador == agent_player
                    nodoActual.wins = nodoActual.wins + recompensaActual;
                else
                    nodoActual.wins = nodoActual.wins - recompensaActual;
                end

                % Solo imprimir si el nodo tiene un movimiento válido
                if ~isempty(nodoActual.movimiento)
                    fprintf('Retropropagando: Nodo (Movimiento: [%d, %d]) - Wins: %.2f, Visitas: %d\n', ...
                        nodoActual.movimiento(1), nodoActual.movimiento(2), nodoActual.wins, nodoActual.visitas);
                else
                    fprintf('Retropropagando: Nodo raíz - Wins: %.2f, Visitas: %d\n', ...
                        nodoActual.wins, nodoActual.visitas);
                end

                nodoActual = nodoActual.padre;
            end
        end
    end
end
