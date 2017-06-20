 function [stop,options,optchanged]  = myoutputSA(options,optimvalues,flag) 
 
% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.
        
         % Possible parameters to read from state
         % state.Generation, state.StartTime, state.StopFlag, state.LastImprovement, 
         % state.LastImprovementTime, state.Best, state.how, state.FunEval, 
         % state.Expectation, state.Selection, state.Population, state.Score
 
         % Save each best element in the global variable
         global  best_solution_consola_sa best_fval_sa;
         
         if (best_fval_sa > optimvalues.bestfval)
            best_fval_sa = optimvalues.bestfval;
            best_solution_consola_sa =[best_solution_consola_sa; [optimvalues.bestfval, optimvalues.iteration, toc]] ; %get current generation number
         end
            % iteration
         
         stop = false;
        
         
         % Save each best element in the file
         %fid=fopen('resultado.txt','w');
         %fprintf(fid,'%d \n',state.Best);
         %fclose(fid);
         
         optchanged = false; % Don't remove

     end