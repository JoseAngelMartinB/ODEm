 function [state,options,optchanged] = myoutputGA(options,state,flag,interval) 
   
% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.
      
    % Possible parameters to read from state
    % state.Generation, state.StartTime, state.StopFlag, state.LastImprovement, 
    % state.LastImprovementTime, state.Best, state.how, state.FunEval, 
    % state.Expectation, state.Selection, state.Population, state.Score
     
    %Save each best element in the global variable
    global  best_solution_consola iter_cont_consola time_cont_consola GAdatos;
    
    % iteration
    optchanged = false; %no quitar
    
    % From all the best points (states), we keep the value of the last one
    if length(state.Best)>0
        Bestf=state.Best(length(state.Best));
    else
        Bestf=realmax;      
    end 
    
    % The golobal variable with the best value is updated 
    % And the number of hits is increased
    if  Bestf<GAdatos.fval
        GAdatos.M=GAdatos.M+1;
        GAdatos.fval=Bestf;
        
        best_solution_consola =[best_solution_consola,Bestf] ; % get current generation number
        iter_cont_consola=[iter_cont_consola,state.FunEval];
        time_cont_consola=[time_cont_consola,toc];
    end
    
    % If we have reached the number of hits defined, it is sped up with an exact algorithm.
    if(GAdatos.M==GAdatos.Mfinal) 
        
        MINAUX=min(state.Score);
        fila=find(state.Score==MINAUX);    
        best_x=state.Population(fila(1),:);
        
        fun_auxi2 = GAdatos.fun;
        LB = GAdatos.LB;
        UB = GAdatos.UB;
        options_exact = GAdatos.options_exact;
        
        [ x_opt, f_opt, exitflag, output] = optExact( fun_auxi2, LB, UB, best_x, options_exact );

        state.FunEval=state.FunEval+output.funcCount;
        GAdatos.M=0;
        
        if  f_opt<GAdatos.fval
            GAdatos.fval=f_opt;
            state.Population(fila(1),:)=x_opt;
            state.Best(length(state.Best))=f_opt;
            
            best_solution_consola =[best_solution_consola,f_opt]; % get current generation number
            iter_cont_consola=[iter_cont_consola,state.FunEval];
            time_cont_consola=[time_cont_consola,output.time];
        end 
    end 
    
    GAdatos.funcCount = state.FunEval; 
   
 end
     
 