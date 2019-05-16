function resultado = junta_esferica_complex (vector_q,vector_v,n_corpo1,A_corpo1,pos_local_corpo1,n_corpo2,A_corpo2,pos_local_corpo2,tipo_analise,parametros)
% Actualização a 25/03/2014 - Verifico se o vector_q é simbolico para
% alterar a inicialização dos vectores.
%n_corpo1 é o indice onde começam as coordenadas do corpo 1;
%Tipo de analise => se 1 calculo dos constrangimentos, se 2 calculo do
%jacobiano

% Verifico se o vector é simbolico
simbolico = 0;
if (isa(vector_q,'sym') == 1)
    simbolico = 1;
end

if (tipo_analise == 1)
    resultado = vector_q(n_corpo1(1):n_corpo1(1)+2) + A_corpo1 * pos_local_corpo1 - vector_q(n_corpo2(1):n_corpo2(1)+2) - A_corpo2 * pos_local_corpo2;
end
if (tipo_analise == 2 || tipo_analise == 3)
    %Coordenada local da junta no referencial corpo1
    s_local_1 = pos_local_corpo1';
    %Coordenada local da junta no referencial corpo2
    s_local_2 = pos_local_corpo2';
    %Parametros de Euler corpo1 e velocidade
    euler1 = vector_q(n_corpo1(1)+3:n_corpo1(1)+6);
    %Parametros de Euler corpo2 e velocidade
    euler2 = vector_q(n_corpo2(1)+3:n_corpo2(1)+6);
    
    %Matriz s_ corpo1 e corpo2
    si = [0 -s_local_1; s_local_1' -skewmatrix(s_local_1)];
    sj = [0 -s_local_2; s_local_2' -skewmatrix(s_local_2)];    

    if (tipo_analise == 2)
        
        %Construção matriz Gi e Gj e Li e Lj
        %Parametros de euler do corpo1 e corpo2
        Gi = [-euler1(2) euler1(1) -euler1(4) euler1(3); -euler1(3) euler1(4) euler1(1) -euler1(2); -euler1(4) -euler1(3) euler1(2) euler1(1)];
        Gj = [-euler2(2) euler2(1) -euler2(4) euler2(3); -euler2(3) euler2(4) euler2(1) -euler2(2); -euler2(4) -euler2(3) euler2(2) euler2(1)];
        Li = [-euler1(2) euler1(1) euler1(4) -euler1(3); -euler1(3) -euler1(4) euler1(1) euler1(2); -euler1(4) euler1(3) -euler1(2) euler1(1)];
        Lj = [-euler2(2) euler2(1) euler2(4) -euler2(3); -euler2(3) -euler2(4) euler2(1) euler2(2); -euler2(4) euler2(3) -euler2(2) euler2(1)];
        
        if (parametros == 1)
            % Verifico se é simbolico (25/03/2014)
            if (simbolico == 0)
                resultado = zeros(3,length(vector_q));
            else
                resultado = sym(zeros(3,length(vector_q)));
            end
            
            %Coeficientes parametros Euler
            coef1 = 2 * Gi * si;
            coef2 = - 2 * Gj * sj;
            %Construção da resultado
            for i=1:3
                resultado(i,n_corpo1(1)+(i-1)) = 1;
                resultado(i,n_corpo2(1)+(i-1)) = -1;
                resultado(i,n_corpo1(1)+3:n_corpo1(1)+6) = coef1(i,:);
                resultado(i,n_corpo2(1)+3:n_corpo2(1)+6) = coef2(i,:);
            end
        end
        if (parametros == 2)
            %Coeficientes parametros w'
            coef1 = Gi * si * Li';
            coef2 = - Gj * sj * Lj';
            
            % Verifico se é simbolico (25/03/2014)
%             if (simbolico == 0)
%                 resultado = zeros(3,length(vector_v));
%             else
%                 resultado = sym(zeros(3,length(vector_v)));
%             end
            
            %Construção da resultado
            for i=1:3
                resultado(i,n_corpo1(2)+(i-1)) = 1;
                resultado(i,n_corpo2(2)+(i-1)) = -1;
                resultado(i,n_corpo1(2)+3:n_corpo1(2)+5) = coef1(i,:);
                resultado(i,n_corpo2(2)+3:n_corpo2(2)+5) = coef2(i,:);
            end
        end
    end
    if (tipo_analise == 3)
        %Derivada dos parametros de euler 
        %Nota: O vector_v sao velocidade w -> e preciso transformar isso em
        %derivadas p
        %Rotacoes
        rotai = vector_v(n_corpo1(2)+3:n_corpo1(2)+5);
        rotaj = vector_v(n_corpo2(2)+3:n_corpo2(2)+5);
        %Matriz Li e Lj
        %parametros euler
        Li = [-euler1(2) euler1(1) euler1(4) -euler1(3); -euler1(3) -euler1(4) euler1(1) euler1(2); -euler1(4) euler1(3) -euler1(2) euler1(1)];
        Lj = [-euler2(2) euler2(1) euler2(4) -euler2(3); -euler2(3) -euler2(4) euler2(1) euler2(2); -euler2(4) euler2(3) -euler2(2) euler2(1)];
        %Calculo da matriz Gi e Gj
        Gi = [-euler1(2) euler1(1) -euler1(4) euler1(3); -euler1(3) euler1(4) euler1(1) -euler1(2); -euler1(4) -euler1(3) euler1(2) euler1(1)];
        Gj = [-euler2(2) euler2(1) -euler2(4) euler2(3); -euler2(3) euler2(4) euler2(1) -euler2(2); -euler2(4) -euler2(3) euler2(2) euler2(1)];

        veuler1 = 0.5 * Li' * rotai;
        veuler2 = 0.5 * Lj' * rotaj;

        deriv_Gi = [-veuler1(2) veuler1(1) -veuler1(4) veuler1(3); -veuler1(3) veuler1(4) veuler1(1) -veuler1(2); -veuler1(4) -veuler1(3) veuler1(2) veuler1(1)];
        deriv_Gj = [-veuler2(2) veuler2(1) -veuler2(4) veuler2(3); -veuler2(3) veuler2(4) veuler2(1) -veuler2(2); -veuler2(4) -veuler2(3) veuler2(2) veuler2(1)];
        
        if (parametros ==1)
            hi = -2 * (deriv_Gi * si) * veuler1;
            hj = -2 * (deriv_Gj * sj) * veuler2;
            
            resultado = hi - hj;
        end
        if (parametros == 2)
            resultado = deriv_Gj * sj * Lj' * rotaj - deriv_Gi * si * Li' * rotai + 0.5*Gi*si*(rotai'*rotai)*euler1 - 0.5*Gj*sj*(rotaj'*rotaj)*euler2;
        end
    end
    
elseif (tipo_analise == 4 || strcmpi(tipo_analise,'Niu') == 1)
    % Vector Niu
    resultado = zeros(3,1);
    
end

end
