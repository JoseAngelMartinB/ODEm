function varargout = form_main(varargin)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% THIS IS THE MAIN FILE OF THE PROGRAM. 
% YOU SHOULD EXECUTE ONLY THIS FILE. THIS FILE WILL LOAD THE INTERFACE.

% FORM_MAIN MATLAB code for form_main.fig
%      FORM_MAIN, by itself, creates a new FORM_MAIN or raises the existing
%      singleton*.
%
%      H = FORM_MAIN returns the handle to a new FORM_MAIN or the handle to
%      the existing singleton*.
%
%      FORM_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_MAIN.M with the given input arguments.
%
%      FORM_MAIN('Property','Value',...) creates a new FORM_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_main

% Last Modified by GUIDE v2.5 13-Nov-2016 16:30:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_main_OpeningFcn, ...
                   'gui_OutputFcn',  @form_main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before form_main is made visible.
function form_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_main (see VARARGIN)

% Choose default command line output for form_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes form_main wait for user response (see UIRESUME)
% uiwait(handles.form_main);


% --- Outputs from this function are returned to the command line.
function varargout = form_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in problem.
function problem_Callback(hObject, eventdata, handles)
% hObject    handle to problem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global design;
form_problem;
set(handles.run_info, 'String', '');
set(handles.run_info, 'ForegroundColor', 'black');
set(handles.design_text,'ForegroundColor','black');
if design.p == 0
    design_text = 'Appro. D-design';
elseif design.p == 1
    design_text = 'Appro. A-Design';
else
    design_text = ['Appro. Other: p = ' num2str(design.p) ' design'];
end
set(handles.design_text,'String',design_text);



% --- Executes on button press in design.
function design_Callback(hObject, eventdata, handles)
% hObject    handle to design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global problem_name;
if strcmp(problem_name, '%%%none%%%')
    set(handles.design_text,'String','Select a problem first');
    set(handles.design_text,'ForegroundColor','red');
else
    form_design;
end

% --- Executes on button press in methods.
function methods_Callback(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
form_methods;


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% opt = evalin('base', 'opt');
global problem_name opt design alg algs_exacts hybrid more_opt sol solution results;

% Check if problem is selected
if ~strcmp(problem_name, '%%%none%%%') & isempty(alg) == 0
    set(handles.run_info, 'String', 'Computing results...');
    set(handles.run_info, 'ForegroundColor', 'black');
    drawnow;
    
    N = opt.m*(opt.co+1);
    auxX=@(x) reshape(x(1:(N-opt.m)),[opt.m,opt.co]);
    auxW=@(x) reshape(x(N-opt.m+1:N),[opt.m,1])/sum(reshape(x(N-opt.m+1:N),[opt.m,1]));

    % Check if the design is exact or approximated
    if design.exact == 0
        f = @(x) criterion(auxX(x),auxW(x),opt);
    else
        f = @(x) criterion(auxX(x),(1/opt.m)*ones(1,opt.m),opt);
    end

    [LB, UB] = generate_LB_UB(opt.bounds, opt.co, opt.m, 2);
    
    algs_exacts = [];
    
    for element = alg
        if hybrid.hybrid == 1
           if element > 3
              algs_exacts(end + 1) = element - 3;
           end
        end
    end    
    
    % GENERATE THE LIST OF ALGORITHMS FOR THE RESULT FORM
    global alg_names hybrid_combinations list_alg;
    list_alg = [];
    if hybrid.hybrid == 1 % It is an hybrid experiment
        hybrid_combinations = [];
        for element = alg
            if element < 4 % Heuristic algorithm of the hybrid combination
                for element_exact = algs_exacts % Exact algorithm of the hybrid combination
                    if ~isempty(list_alg)
                        list_alg = [list_alg char(10)];
                    end
                        list_alg = [list_alg strcat(alg_names{element,1}, '+', alg_names{element_exact + 3,1})]; 
                        hybrid_combinations = [hybrid_combinations; element element_exact];
                end
            end
        end
    else
        for element = alg
            if ~isempty(list_alg)
                list_alg = [list_alg char(10)];
            end
                list_alg = [list_alg alg_names{element,1}];
        end
    end
    

    % EXECUTE THE ALGORITTHM
    if hybrid.hybrid == 0
        % Create auxiliar structure for simulated anealing
        if ismember(3, alg)
            info_sa.co = opt.co;
            info_sa.bounds = opt.bounds;
            info_sa.m = opt.m;
            info_sa.type = 1;
            [sol, solution.CPU] = Fmin_Experiments(f, LB, UB, 'name-problem', problem_name, 'Iters', more_opt.global_it, 'ItersExact', more_opt.exacts_it, 'Alg', alg, 'Pop', more_opt.population, 'Nc', Inf, 'replicas', more_opt.replicas, 'OptSa', info_sa);
        else
            [sol, solution.CPU] = Fmin_Experiments(f, LB, UB, 'name-problem', problem_name, 'Iters', more_opt.global_it, 'ItersExact', more_opt.exacts_it, 'Alg', alg, 'Pop', more_opt.population, 'Nc', Inf, 'replicas', more_opt.replicas);
        end
    elseif hybrid.hybrid == 1
        % Create auxiliar structure for simulated anealing
        if ismember(3, alg)
            info_sa.co = opt.co;
            info_sa.bounds = opt.bounds;
            info_sa.m = opt.m;
            info_sa.type = 1;
            [sol, solution.CPU] = Fmin_Experiments(f, LB, UB, 'name-problem', problem_name, 'Iters', more_opt.global_it, 'ItersExact', more_opt.exacts_it, 'Alg', alg, 'AlgExact', algs_exacts, 'Pop', more_opt.population, 'Nc', hybrid.nc, 'replicas', more_opt.replicas, 'OptSa', info_sa);
        else
            [sol, solution.CPU] = Fmin_Experiments(f, LB, UB, 'name-problem', problem_name, 'Iters', more_opt.global_it, 'ItersExact', more_opt.exacts_it, 'Alg', alg, 'AlgExact', algs_exacts, 'Pop', more_opt.population, 'Nc', hybrid.nc, 'replicas', more_opt.replicas);
        end
    end
    
    solution.aux_x = auxX(sol.best_solution);
    solution.aux_w = auxW(sol.best_solution);

    % Generate result data
    make_result_table();
        
    % For depuration porpouses:
    %assignin('base','alg_exacts',algs_exacts);
    %assignin('base','alg',alg);
    %assignin('base','solution',solution);
    assignin('base','results',results);
    
    % Show the results
    form_result();
    set(handles.run_info, 'String', '');
   
else
    if strcmp(problem_name, '%%%none%%%')
        set(handles.run_info,'String','Select a problem first');
        set(handles.run_info,'ForegroundColor','red');
    elseif isempty(alg) == 1
        set(handles.run_info,'String','Select at least one method');
        set(handles.run_info,'ForegroundColor','red');
    end
end


% --- Executes during object creation, after setting all properties.
function form_main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to form_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
evalin('base', 'clearvars *')
clc;
warning ('off','all'); % Turn warnings off
global file problem_name opt design alg hybrid more_opt problem_line alg_names;
file = 'ProblemData.dat'; % Default location of the problems
problem_name = '%%%none%%%';
problem_line = 0;
design.p = 0;
design.exact = 0;
design.MM = 0;
alg = [];
hybrid.hybrid = 0;
hybrid.nc = 0;
more_opt.more = 0;
more_opt.replicas = 1;
more_opt.global_it = 500;
more_opt.ill_cond = 0;
more_opt.eta = 1e-10;
more_opt.population = 50;
more_opt.exacts_it = 100;
alg_names = {'PSO';     % H - 1
    'GA';               % H - 2
    'SA';               % H - 3
    'AS';               % E - 4
    'IP';               % E - 5
    'SQP';              % E - 6
    'NM';               % E - 7
    'PS'};              % E - 8

%Show the logo
logo = imread('logo.jpg');
axes('Position',[0 0.5 0.28 0.6]);
imshow(logo);


% --- Executes during object creation, after setting all properties.
function problem_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to problem_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'String', 'No problem selected.');
set(hObject, 'ForegroundColor' , 'red');


% --- Executes during object creation, after setting all properties.
function design_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to design_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design;

if design.exact == 0
    if design.p == 0
        design_text = 'Appro. D-design';
    elseif design.p == 1
        design_text = 'Appro. A-Design';
    else
        design_text = ['Appro. Other: p = ' num2str(design.p) ' design'];
    end
else
    if design.p == 0
        design_text = 'Exact. D-design';
    elseif design.p == 1
        design_text = 'Exact. A-Design';
    else
        design_text = ['Exact. Other: p = ' num2str(design.p) ' design'];
    end
end

set(hObject, 'String', design_text);


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
