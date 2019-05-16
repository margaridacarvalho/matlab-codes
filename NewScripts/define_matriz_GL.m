function [G,L] = define_matriz_GL(euler)
%% ESta função define as matrizes G e L de um corpo com parametros de euler euler

% Matriz G
G = [-euler(2) euler(1) -euler(4) euler(3); -euler(3) euler(4) euler(1) -euler(2); -euler(4) -euler(3) euler(2) euler(1)];
% Matriz L
L = [-euler(2) euler(1) euler(4) -euler(3); -euler(3) -euler(4) euler(1) euler(2); -euler(4) euler(3) -euler(2) euler(1)];

% Fim da função
end