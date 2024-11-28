% Función: obtenerMovimientos.m
function movimientos = obtenerMovimientos(estado)
    [filas, columnas] = find(estado == 0);
    movimientos = [filas, columnas];
end