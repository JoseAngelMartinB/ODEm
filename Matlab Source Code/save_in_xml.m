function status = save_in_xml(file)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

global results problem_name design opt;

n_results = size(results,2);
status = -1;
line_in_summary = 1;
summary_alg = {};
summary_x = [];
summary_eff = {};


% Iterate over all the results computed
for i = 1:n_results
    % Store the name of the algorithm
    alg_name = results{i}.longName;
    sheet = results{i}.sortName;
    disp(strcat('Saving Result for method ', alg_name));
    [status,message] = xlswrite(file,{problem_name; alg_name},sheet,'A1');
    
    
    % Table with weigths and X
    xlRange = 4;
    data = results{i}.data;
    data_size = size(data);
    if design.exact == 0
        data_cabeceras = {'Weigth'};
    else
        data_cabeceras = {'Subject'};
        subjects = [1:1:opt.m];
        data(:,1) = subjects(1,:);
    end
    for j = (2:data_size(2))
        data_cabeceras(end + 1) = {strcat('X', num2str(j - 1))};
    end
    [status,message] = xlswrite(file,data_cabeceras,sheet,strcat('A',num2str(xlRange)));
    xlRange = xlRange + 1;
    [status,message] = xlswrite(file,data,sheet,strcat('A',num2str(xlRange)));
    xlRange = xlRange + data_size(1) + 1;
    
    
    % Design    
    if design.p == 0
        design_str = 'D-Design';
    elseif design.p == 1
        design_str = 'A-Design';
    else
        design_str = ['Other design: p = ' num2str(design.p)];
    end
    if design.exact == 0
        appr_exact_str = ['Approximated design.'];
    else
        appr_exact_str = ['Exact design. Experimental subjects = ' num2str(opt.m)];
    end
    [status,message] = xlswrite(file,{'Type of design:', design_str, appr_exact_str},sheet,strcat('A',num2str(xlRange)));
    xlRange = xlRange + 1;
    
    
    % Z
    if design.p == 0
        if results{i}.Phi == -1
            [status,message] = xlswrite(file,{'Z*:', '---'},sheet,strcat('A',num2str(xlRange)));
            z = '---';
        else
            f_opt = results{i}.Phi;
            [status,message] = xlswrite(file,{'Z*:', sprintf('%.2f%',f_opt)},sheet,strcat('A',num2str(xlRange)));
            z = sprintf('%.2f%',f_opt);
        end
    else
        f_opt = results{i}.f_opt;
        [status,message] = xlswrite(file,{'Z*:', sprintf('%.2f%',f_opt)},sheet,strcat('A',num2str(xlRange)));
        z = sprintf('%.2f%',f_opt);
    end
    xlRange = xlRange + 1;
    
    
    % CPU time
    time = results{i}.time;
    [status,message] = xlswrite(file,{'CPU time:', time},sheet,strcat('A',num2str(xlRange)));
    xlRange = xlRange + 1;
    
    
    % Efficiency
    if results{i}.efficiency > 1 || results{i}.efficiency < 0 % Avoid wrong efficiency
        eff_per = sprintf('---');
    else
        eff_per = sprintf('%.2f%%',100*results{i}.efficiency);
    end
    [status,message] = xlswrite(file,{'Efficiency:', eff_per},sheet,strcat('A',num2str(xlRange)));
    xlRange = xlRange + 1; 
    
    
    %Summary
    summary_alg(line_in_summary,1) = {sheet};
    for j = (0:data_size(2)-2)
        summary_alg(line_in_summary + j, 2) = {strcat('X', num2str(j+1))};
        new_data = data(:, j+2);
        size_new_data = size(new_data);
        summary_x(line_in_summary + j, 1:size_new_data(1)) = new_data';
    end
    if design.exact == 0
        summary_alg(line_in_summary + data_size(2) - 1, 2) = {'W'};
    else
        summary_alg(line_in_summary + data_size(2) - 1, 2) = {'Subject'};
    end
    new_data = data(:, 1);
    size_new_data = size(new_data);
    summary_x(line_in_summary + data_size(2) - 1, 1:size_new_data(1)) = new_data';
    summary_eff(line_in_summary, 1:3) = {eff_per,z,time};
    summary_eff(line_in_summary + data_size(2) - 1, 3) = {''}; % Prevents error in dimensions when writing XML
    line_in_summary = line_in_summary + data_size(2);
    
end


% Summary sheet
size_summary_x = size(summary_x);
head_summary(1,1) = {'Method'};
head_summary(1,size_summary_x(2)+3:size_summary_x(2)+5) = {'Efficiency', 'Z', 'CPU'};
[status,message] = xlswrite(file,{'Summary of all the results:'},'Summary','A1');
[status,message] = xlswrite(file,head_summary,'Summary','A3');
[status,message] = xlswrite(file,[summary_alg,num2cell(summary_x),summary_eff],'Summary','A4');

disp(strcat(file, {' has been saved'}));

end