function varargout = form_problem(varargin)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% FORM_PROBLEM MATLAB code for form_problem.fig
%      FORM_PROBLEM, by itself, creates a new FORM_PROBLEM or raises the existing
%      singleton*.
%
%      H = FORM_PROBLEM returns the handle to a new FORM_PROBLEM or the handle to
%      the existing singleton*.
%
%      FORM_PROBLEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_PROBLEM.M with the given input arguments.
%
%      FORM_PROBLEM('Property','Value',...) creates a new FORM_PROBLEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_problem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_problem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_problem

% Last Modified by GUIDE v2.5 19-Sep-2016 11:02:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_problem_OpeningFcn, ...
                   'gui_OutputFcn',  @form_problem_OutputFcn, ...
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


% --- Executes just before form_problem is made visible.
function form_problem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_problem (see VARARGIN)

% Choose default command line output for form_problem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes form_problem wait for user response (see UIRESUME)
% uiwait(handles.form_problem);


% --- Outputs from this function are returned to the command line.
function varargout = form_problem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in new_problem.
function new_problem_Callback(hObject, eventdata, handles)
% hObject    handle to new_problem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.form_problem, 'line_problem_edit', -1);
form_new_problem;


% --- Executes on selection change in problems.
function problems_Callback(hObject, eventdata, handles)
% hObject    handle to problems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns problems contents as cell array
%        contents{get(hObject,'Value')} returns selected item from problems


% --- Executes during object creation, after setting all properties.
function problems_CreateFcn(hObject, eventdata, handles)
% hObject    handle to problems (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Load problems
refresh(hObject);


% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global file problem_line;
problem = get(handles.problems, 'Value');
n_problem = 0;
error = 0;
problem_finded = false;
problem_line = -1;
% Open file and search for problems
fd = fopen(file,'r');
if fd == -1
    set(handles.info,'String','Cannot open file.');
    set(handles.info,'FontSize',12);
    error = 1;
else
    set(handles.info,'FontSize',10);
    
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    fclose(fd);

    i = 1;
    while strcmp(CStr(i), '%%%END_PROBLEMS%%%') ~= true && ~problem_finded
        if strcmp(CStr(i), '%%%%PROBLEM%%%%')
            n_problem = n_problem + 1;
            if problem == n_problem
                % Line of the file where the problem starts
                problem_finded = true;
                % Store the line where the problem selected start 
                h = findobj('Tag','form_main');
                setappdata(h, 'line_problem', i);
                problem_name_cell = CStr(i + 1);
                problem_line = i;
                error = 0;
            end
        end
        i = i + 1;
    end 
end

if error == 0  
   % LOAD PROBLEM FUNCTIONS
   global problem_name opt design;
   opt = design_opt_load(file,problem_line);
   problem_name = problem_name_cell{:};
   design.exact = 0;
   design.p = 0;
   
   problem_name_label = findobj('Tag','problem_name');
   set(problem_name_label, 'String', problem_name_cell{:});
   set(problem_name_label, 'ForegroundColor' , 'black');
    
end

close;


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refresh(handles.problems);


function refresh(problems)
% Refresh the problem list
global file;
error = 0;
% Open file and search for problems
fd = fopen(file,'r');
if fd == -1
    set(problems,'String','Cannot open file.');
    set(problems,'FontSize',14);
    error = 1;
else
    set(problems,'FontSize',10);
    problems_str = '';
    
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    fclose(fd);

    i = 1;
    while strcmp(CStr(i), '%%%END_PROBLEMS%%%') ~= true
        if strcmp(CStr(i), '%%%%PROBLEM%%%%')
            problems_str = [problems_str CStr(i + 1)];
        end
        i = i + 1;
    end
    set(problems, 'Value', 1);
    set(problems, 'String', problems_str);

    
end


% --- Executes during object creation, after setting all properties.
function form_problem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to form_problem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% refresh(handles);


% --- Executes on button press in edit.
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global file;
problem = get(handles.problems, 'Value');
n_problem = 0;
error = 0;
problem_finded = false;
% Open file and search for problems
fd = fopen(file,'r');
if fd == -1
    set(handles.info,'String','Cannot open file.');
    set(handles.info,'FontSize',12);
    error = 1;
else
    set(handles.info,'FontSize',10);
    
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    fclose(fd);

    i = 1;
    while strcmp(CStr(i), '%%%END_PROBLEMS%%%') ~= true && ~problem_finded
        if strcmp(CStr(i), '%%%%PROBLEM%%%%')
            n_problem = n_problem + 1;
            if problem == n_problem
                % Line of the file where the problem starts
                problem_finded = true;
                % Store the line where the problem start for the form_edit_problem
                setappdata(handles.form_problem, 'line_problem_edit', i);
                form_new_problem;
            end
        end
        i = i + 1;
    end 
end
    


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global file;
problem = get(handles.problems, 'Value');
n_problem = 0;
error = 0;
problem_finded = false;
% Open file and search for problems
fd = fopen(file,'r');
if fd == -1
    set(handles.info,'String','Cannot open file.');
    error = 1;
else   
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    fclose(fd);

    i = 1;
    while strcmp(CStr(i), '%%%END_PROBLEMS%%%') ~= true && ~problem_finded
        if strcmp(CStr(i), '%%%%PROBLEM%%%%')
            n_problem = n_problem + 1;
            if problem == n_problem
                % i --> Line of the file where the problem starts
                problem_start_line = i;
                while strcmp(CStr(i), '%%%EOP%%%') ~= true
                    i = i + 1;
                end 
                problem_finish_line = i + 1;
                problem_finded = true;
            end
        end
        i = i + 1;
    end    
    
    % Delete the problem
    if problem_finded
        CStr(problem_start_line:problem_finish_line) = [];
    end
        
    fd = fopen(file,'r+');
    if fd == -1
        set(handles.info,'String','Cannot open file.')
        error = 1;
    else
        fprintf(fd, '%s\n',CStr{:});
        fclose(fd);
        refresh(handles.problems);
    end    
end
