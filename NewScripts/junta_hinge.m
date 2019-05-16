function resultado = junta_hinge (vector_q,vector_v,n_corpo1,A_corpo1,pos_local_centro1,pos_local_ponto1,n_corpo2,A_corpo2,pos_local_centro2,pos_local_ponto2,tipo_analise,parametros)

%SCRIPT SEM VECTOR V
% Actualização a 25/03/2014 - Verifico se o vector_q é simbolico para
% alterar a inicialização dos vectores.
%Nota: o vector_v são as velocidades de rotação (w) -> Não são as derivadas
%dos parametros de euler

% Verifico se o vector é simbolico
simbolico = 0;
if (isa(vector_q,'sym') == 1)
    simbolico = 1;
end

%Vector paralelo ao eixo de rotação no corpo1 e corpo2
vec_local_corpo1 = pos_local_ponto1 - pos_local_centro1;
vec_local_corpo2 = pos_local_ponto2 - pos_local_centro2;

%Transformação dos vector para coordenadas globais
vec_corpo1 = A_corpo1 * vec_local_corpo1;
vec_corpo2 = A_corpo2 * vec_local_corpo2;

%Calculo os vectores perpendiculares
[s1,s2] = vectores_perperndiculares (pos_local_centro1,pos_local_ponto1);

resultado = [];
if (tipo_analise == 1)
    
    %Definição constrangimentos da junta esférica
    constr = junta_esferica_complex (vector_q,[],n_corpo1,A_corpo1,pos_local_centro1,n_corpo2,A_corpo2,pos_local_centro2,1,parametros);
    resultado = [resultado; constr];
    
    constr = [(A_corpo1 * s1')' * vec_corpo2; (A_corpo1 * s2')' * vec_corpo2]; 
    resultado = [resultado; constr];
elseif (tipo_analise == 2)
    %Jacobiana dos constrangimentos de junta esferica
    jacob = junta_esferica_complex (vector_q,[],n_corpo1,A_corpo1,pos_local_centro1,n_corpo2,A_corpo2,pos_local_centro2,2,parametros);
    resultado= [resultado; jacob];
    
    %Construção matriz Gi e Gj
    %Parametros de euler do corpo1 e corpo2
    euler1 = vector_q(n_corpo1(1)+3:n_corpo1(1)+6);
    euler2 = vector_q(n_corpo2(1)+3:n_corpo2(1)+6);
    Gi = [-euler1(2) euler1(1) -euler1(4) euler1(3); -euler1(3) euler1(4) euler1(1) -euler1(2); -euler1(4) -euler1(3) euler1(2) euler1(1)];
    Gj = [-euler2(2) euler2(1) -euler2(4) euler2(3); -euler2(3) euler2(4) euler2(1) -euler2(2); -euler2(4) -euler2(3) euler2(2) euler2(1)];
    %Calculo da matriz Li e Lj
    Li = [-euler1(2) euler1(1) euler1(4) -euler1(3); -euler1(3) -euler1(4) euler1(1) euler1(2); -euler1(4) euler1(3) -euler1(2) euler1(1)];
    Lj = [-euler2(2) euler2(1) euler2(4) -euler2(3); -euler2(3) -euler2(4) euler2(1) euler2(2); -euler2(4) euler2(3) -euler2(2) euler2(1)];
    
    %Definição matriz vector_local-
    si1 = [0 -s1; s1' -skewmatrix(s1)];
    si2 = [0 -s2; s2' -skewmatrix(s2)];
    sj = [0 -vec_local_corpo2'; vec_local_corpo2 -skewmatrix(vec_local_corpo2)];
    
    %Calculo dos coeficientes da matriz jacobiana
    coefi1 = 2 * vec_corpo2' * Gi * si1;
    coefj1 = 2 * (A_corpo1 * s1')' * Gj * sj;
    coefi2 = 2 * vec_corpo2' * Gi * si2;    
    coefj2 = 2 * (A_corpo1 * s2')' * Gj * sj;
    
    if (parametros == 1)
        % Verifico se é simbolico (25/03/2014)
        if (simbolico == 0)           
            jacob = zeros(2,length(vector_q));
        else
            jacob = sym(zeros(2,length(vector_q)));
        end
        
        jacob(1,n_corpo1(1)+3:n_corpo1(1)+6) = coefi1;
        jacob(1,n_corpo2(1)+3:n_corpo2(1)+6) = coefj1;
        jacob(2,n_corpo1(1)+3:n_corpo1(1)+6) = coefi2;
        jacob(2,n_corpo2(1)+3:n_corpo2(1)+6) = coefj2;
        resultado= [resultado; jacob];  
    end
    if (parametros == 2)
        % Verifico se é simbolico (25/03/2014)
%         if (simbolico == 0)           
%             jacob = zeros(2,length(vector_v));
%         else
%             jacob = sym(zeros(2,length(vector_v)));
%         end
        
        jacob(1,n_corpo1(2)+3:n_corpo1(2)+5) = 1/2 * coefi1 * Li';
        jacob(1,n_corpo2(2)+3:n_corpo2(2)+5) = 1/2 * coefj1 * Lj';
        jacob(2,n_corpo1(2)+3:n_corpo1(2)+5) = 1/2 * coefi2 * Li';
        jacob(2,n_corpo2(2)+3:n_corpo2(2)+5) = 1/2 * coefj2 * Lj';
        resultado= [resultado; jacob];  
    end
elseif (tipo_analise == 3)
    %Matriz gama dos constrangimentos de junta esferica
    gama = junta_esferica_complex (vector_q,vector_v,n_corpo1,A_corpo1,pos_local_centro1,n_corpo2,A_corpo2,pos_local_centro2,3,parametros);
    resultado= [resultado; gama];

    %Definição das velocidade wi' e wj'
    rotacao1 = vector_v(n_corpo1(2)+3:n_corpo1(2)+5);
    rotacao2 = vector_v(n_corpo2(2)+3:n_corpo2(2)+5);
    %Nota: Neste caso precisamos das velocidade wi e das derivadas de p
    %Parametros de euler
    euler1 = vector_q(n_corpo1(1)+3:n_corpo1(1)+6);
    euler2 = vector_q(n_corpo2(1)+3:n_corpo2(1)+6);

    %derivada de s = derivada A * s' = A * skewmatriz(w') * s';
    si1_ponto = A_corpo1 * skewmatrix(rotacao1) * s1';
    si2_ponto = A_corpo1 * skewmatrix(rotacao1) * s2';
    sj_ponto = A_corpo2 * skewmatrix(rotacao2) * vec_local_corpo2;
    
    if (parametros == 1)
        Li = [-euler1(2) euler1(1) euler1(4) -euler1(3); -euler1(3) -euler1(4) euler1(1) euler1(2); -euler1(4) euler1(3) -euler1(2) euler1(1)];
        Lj = [-euler2(2) euler2(1) euler2(4) -euler2(3); -euler2(3) -euler2(4) euler2(1) euler2(2); -euler2(4) euler2(3) -euler2(2) euler2(1)];
        veuler1 = 0.5 * Li' * rotacao1;
        veuler2 = 0.5 * Lj' * rotacao2;
    
        deriv_Gi = [-veuler1(2) veuler1(1) -veuler1(4) veuler1(3); -veuler1(3) veuler1(4) veuler1(1) -veuler1(2); -veuler1(4) -veuler1(3) veuler1(2) veuler1(1)];
        deriv_Gj = [-veuler2(2) veuler2(1) -veuler2(4) veuler2(3); -veuler2(3) veuler2(4) veuler2(1) -veuler2(2); -veuler2(4) -veuler2(3) veuler2(2) veuler2(1)];
        deriv_Li = [-veuler1(2) veuler1(1) veuler1(4) -veuler1(3); -veuler1(3) -veuler1(4) veuler1(1) veuler1(2); -veuler1(4) veuler1(3) -veuler1(2) veuler1(1)];
        deriv_Lj = [-veuler2(2) veuler2(1) veuler2(4) -veuler2(3); -veuler2(3) -veuler2(4) veuler2(1) veuler2(2); -veuler2(4) veuler2(3) -veuler2(2) veuler2(1)];
    
        hi1 = -2 * deriv_Gi * deriv_Li' * s1;
        hi2 = -2 * deriv_Gi * deriv_Li' * s2;
        hj = -2 * deriv_Gj * deriv_Lj' * vec_local_corpo2;
    
        gama1 = (A_corpo1 * s1')' * hj + vec_corpo2' * hi1 - 2 * si1_ponto' * sj_ponto;
        gama2 = (A_corpo1 * s2')' * hj + vec_corpo2' * hi2 - 2 * si2_ponto' * sj_ponto;
        resultado = [resultado;gama1;gama2];
    end
    if (parametros == 2)
        %Matriz skewsymmetric da rotacao global w~
        rotacao1_global = (A_corpo1 * skewmatrix(rotacao1)) / A_corpo1;
        rotacao2_global = (A_corpo2 * skewmatrix(rotacao2)) / A_corpo2;

        % Tabela 11.1 Nikravesh Pag.299
        gama1 = - 2 * si1_ponto' * sj_ponto + si1_ponto' * rotacao1_global * vec_corpo2 + sj_ponto' * rotacao2_global * (A_corpo1 * s1');
        gama2 = - 2 * si2_ponto' * sj_ponto + si2_ponto' * rotacao1_global * vec_corpo2 + sj_ponto' * rotacao2_global * (A_corpo1 * s2');
        resultado = [resultado;gama1;gama2];
    end
elseif (tipo_analise == 4 || strcmpi(tipo_analise,'Niu') == 1)
    % Vector Niu
    resultado = zeros(5,1);
end
    
end