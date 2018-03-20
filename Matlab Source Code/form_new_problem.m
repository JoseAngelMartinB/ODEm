function varargout = form_new_problem(varargin)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Ródenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain

% FORM_NEW_PROBLEM MATLAB code for form_new_problem.fig
%      FORM_NEW_PROBLEM, by itself, creates a new FORM_NEW_PROBLEM or raises the existing
%      singleton*.
%
%      H = FORM_NEW_PROBLEM returns the handle to a new FORM_NEW_PROBLEM or the handle to
%      the existing singleton*.
%
%      FORM_NEW_PROBLEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_NEW_PROBLEM.M with the given input arguments.
%
%      FORM_NEW_PROBLEM('Property','Value',...) creates a new FORM_NEW_PROBLEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_new_problem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_new_problem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_new_problem

% Last Modified by GUIDE v2.5 22-Jan-2018 13:37:49

% Begin initialization code - DO NOT EDIThandles.('gradient_text')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_new_problem_OpeningFcn, ...
                   'gui_OutputFcn',  @form_new_problem_OutputFcn, ...
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



% --- Executes just before form_new_problem is made visible.
function form_new_problem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_new_problem (see VARARGIN)

% Choose default command line output for form_new_problem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes form_new_problem wait for user response (see UIRESUME)
% uiwait(handles.form_new_problem);


% --- Outputs from this function are returned to the command line.
function varargout = form_new_problem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global file;
error = 0;

% Obtain the line othe problem to be modify
line = -1;
h = findobj('Tag','form_problem');
if ~isempty(h)
    line = getappdata(h, 'line_problem_edit');
end

if line == -1
    % CREATE A NEW PROBLEM
    % Open file and search for the END_PROBLEMS label
    fd = fopen(file,'r'); % r -> read, w -> write, r+ -> read and write
    if fd == -1
        set(handles.info,'String','Cannot open file.');
        error = 1;
    end
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    fclose(fd);

    Index = find(strcmp(CStr, '%%%END_PROBLEMS%%%'), 1);

    % Store the problem
    if error == 0
        fd = fopen(file,'r+');
        if fd == -1
            set(handles.info,'String','Cannot open file.')
            error = 1;
        end

        linear_model = get(handles.linear, 'Value'); % 1 Linear, 0 Non-Linear
        useIxi = get(handles.use_Ixi, 'Value'); % 0 use gradient vector
        name_design = get(handles.name_design, 'String');
        CStr(Index) = cellstr('%%%%PROBLEM%%%%');
        CStr(Index + 1) = cellstr(name_design);
        if linear_model == 1 % LINEAR MODEL
            CStr(Index + 2) = cellstr('linear_model');
            CStr(Index + 3) = cellstr(get(handles.f, 'String'));
            CStr(Index + 4) = cellstr(' ');
        elseif linear_model == 0 % Non-Linear
            CStr(Index + 2) = cellstr('non-linear_model');
            CStr(Index + 3) = cellstr(num2str(useIxi));
            Index = Index + 1;
            CStr(Index + 3) = cellstr(get(handles.f, 'String'));
            CStr(Index + 4) = cellstr(get(handles.theta_0, 'String'));
            auxiliar_functions = cellstr(get(handles.auxiliar_funts, 'String'));
            size_af = size(auxiliar_functions);
            lines = size_af(1);
            Index = Index + 1; 
            CStr(Index + 4) = cellstr(num2str(lines));
            for i = 1:lines
                Index = Index + 1; 
                CStr(Index + 4) = auxiliar_functions(i);
            end           
        end
        CStr(Index + 5) = cellstr(get(handles.k, 'String'));
        CStr(Index + 6) = cellstr(get(handles.m, 'String'));
        CStr(Index + 7) = cellstr(get(handles.co, 'String'));
        % Matrix to estimate
        M_e = get(handles.matrix_to_estimate, 'Data');
        % Delete the rows with all 0 form the matrix
        size_M_e = size(M_e);
        if norm(M_e(2:size_M_e(1),:)) == 0
            M_e = M_e(1,:)
        end
        
        k = str2num(get(handles.k, 'String'));
        matrix_to_estimate_string = '';
        [m,n] = size(M_e);
        for i = 1:m
            matrix_to_estimate_string = [matrix_to_estimate_string num2str(M_e(i,:))];
            if i ~= m
                matrix_to_estimate_string = [matrix_to_estimate_string ';  '];
            end
        end
        CStr(Index + 8) = cellstr(matrix_to_estimate_string);
        CStr(Index + 9) = cellstr(get(handles.bounds, 'String'));

        stage = get(handles.one_stage, 'Value'); % 1 one stage, 0 multistage design
        if stage == 1 % ONE STAGE
            CStr(Index + 10) = cellstr('one-stage');
            CStr(Index + 11) = cellstr('');
            CStr(Index + 12) = cellstr('');
            CStr(Index + 13) = cellstr('');
            CStr(Index + 14) = cellstr('');
            CStr(Index + 15) = cellstr('');
        elseif stage == 0 % MULTI STAGE
            CStr(Index + 10) = cellstr('multistage');
            CStr(Index + 11) = cellstr(get(handles.n0, 'String'));
            CStr(Index + 12) = cellstr(get(handles.n1, 'String'));
            % Initial weight
            n_points = str2num(get(handles.n_points, 'String'));
            omega_0 = get(handles.omega_0_table, 'Data');
            omega_0_string = '';
            for i = 1:n_points
                omega_0_string = [omega_0_string num2str(omega_0(i,:))];
                if i ~= n_points
                    omega_0_string = [omega_0_string ';  '];
                end
            end
            CStr(Index + 13) = cellstr(omega_0_string);
            CStr(Index + 14) = cellstr(get(handles.n_points, 'String'));
            x_0 = get(handles.X_0_table, 'Data');
            x_0_string = '';
            for i = 1:n_points
                x_0_string = [x_0_string num2str(x_0(i,:))];
                if i ~= n_points
                    x_0_string = [x_0_string ';  '];
                end
            end
            CStr(Index + 15) = cellstr(x_0_string);
        end
        CStr(Index + 16) = cellstr('%%%EOP%%%');
        CStr(Index + 17) = cellstr('');
        CStr(Index + 18) = cellstr('%%%END_PROBLEMS%%%');
        fprintf(fd, '%s\n',CStr{:});
        fclose(fd);
    end

else
    % MODIFY AN EXISTING PROBLEM
    % Open file and read it
    fd = fopen(file,'r');
    if fd == -1
        set(handles.info,'String','Cannot open file.');
        error = 1;
    end
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    CStr_old = Data{1};
    size_old_CStr = size(CStr_old);
    finish_line = size_old_CStr(1);
    fclose(fd);    

    % Store the problem
    if error == 0
        fd = fopen(file,'r+');
        if fd == -1
            set(handles.info,'String','Cannot open file to modify Problem.')
            error = 1;
        end
        
        Index = line;
        Index_old = line;
        % Was the problem not linear? Necesary to calculate the new of lines
        if strcmp(CStr(line + 2), 'non-linear_model')
            n_auxiliarf_cell = CStr(line + 5);
            n_auxiliarf = str2num(n_auxiliarf_cell{:});
            Index_old = Index_old + n_auxiliarf + 2;
        end        
        
        linear_model = get(handles.linear, 'Value'); % 1 Linear, 0 Non-Linear
        useIxi = get(handles.use_Ixi, 'Value'); % 0 use gradient vector
        name_design = get(handles.name_design, 'String');
        CStr(Index) = cellstr('%%%%PROBLEM%%%%');
        CStr(Index + 1) = cellstr(name_design);
        if linear_model == 1 % LINEAR MODEL
            CStr(Index + 2) = cellstr('linear_model');
            CStr(Index + 3) = cellstr(get(handles.f, 'String'));
            CStr(Index + 4) = cellstr(' ');
        elseif linear_model == 0 % Non-Linear
            CStr(Index + 2) = cellstr('non-linear_model');
            CStr(Index + 3) = cellstr(num2str(useIxi));
            Index = Index + 1;
            CStr(Index + 3) = cellstr(get(handles.f, 'String'));
            CStr(Index + 4) = cellstr(get(handles.theta_0, 'String'));
            auxiliar_functions = cellstr(get(handles.auxiliar_funts, 'String'));
            size_af = size(auxiliar_functions);
            lines = size_af(1);
            Index = Index + 1; 
            CStr(Index + 4) = cellstr(num2str(lines));
            for i = 1:lines
                Index = Index + 1; 
                CStr(Index + 4) = auxiliar_functions(i);
            end  
        end
        CStr(Index + 5) = cellstr(get(handles.k, 'String'));
        CStr(Index + 6) = cellstr(get(handles.m, 'String'));
        CStr(Index + 7) = cellstr(get(handles.co, 'String'));
        % Matrix to estimate
        M_e = get(handles.matrix_to_estimate, 'Data');
        k = str2num(get(handles.k, 'String'));
        % Delete the rows with all 0 form the matrix
        size_M_e = size(M_e);
        if norm(M_e(2:size_M_e(1),:)) == 0
            M_e = M_e(1,:)
        end
        
        matrix_to_estimate_string = '';
        [m,n] = size(M_e);
        for i = 1:m
            matrix_to_estimate_string = [matrix_to_estimate_string num2str(M_e(i,:))];
            if i ~= m
                matrix_to_estimate_string = [matrix_to_estimate_string ';  '];
            end
        end
        CStr(Index + 8) = cellstr(matrix_to_estimate_string);
        CStr(Index + 9) = cellstr(get(handles.bounds, 'String'));

        stage = get(handles.one_stage, 'Value'); % 1 one stage, 0 multistage design
        if stage == 1 % ONE STAGE
            CStr(Index + 10) = cellstr('one-stage');
            CStr(Index + 11) = cellstr('');
            CStr(Index + 12) = cellstr('');
            CStr(Index + 13) = cellstr('');
            CStr(Index + 14) = cellstr('');
            CStr(Index + 15) = cellstr('');
        elseif stage == 0 % MULTI STAGE
            CStr(Index + 10) = cellstr('multistage');
            CStr(Index + 11) = cellstr(get(handles.n0, 'String'));
            CStr(Index + 12) = cellstr(get(handles.n1, 'String'));
            % Initial weight
            n_points = str2num(get(handles.n_points, 'String'));
            omega_0 = get(handles.omega_0_table, 'Data');
            omega_0_string = '';
            for i = 1:n_points
                omega_0_string = [omega_0_string num2str(omega_0(i,:))];
                if i ~= n_points
                    omega_0_string = [omega_0_string ';  '];
                end
            end
            CStr(Index + 13) = cellstr(omega_0_string);
            CStr(Index + 14) = cellstr(get(handles.n_points, 'String'));
            W = get(handles.X_0_table, 'Data');
            weight_string = '';
            for i = 1:n_points
                weight_string = [weight_string num2str(W(i,:))];
                if i ~= n_points
                    weight_string = [weight_string ';  '];
                end
            end
            CStr(Index + 15) = cellstr(weight_string);
        end
        CStr(Index + 16) = cellstr('%%%EOP%%%');
        % Store the rest of the file as it was
        CStr(Index + 17:finish_line + (Index - Index_old)) = CStr_old(Index_old + 17:finish_line);
        if (Index - Index_old) < 0
            CStr(finish_line + (Index - Index_old)+1:finish_line) = [];
        end
        fprintf(fd, '%s\n',CStr{:});
        fclose(fd);
    end
end
    
if error == 0
    close;
end


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;



function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double


% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', handles.f);



function name_design_Callback(hObject, eventdata, handles)
% hObject    handle to name_design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of name_design as text
%        str2double(get(hObject,'String')) returns contents of name_design as a double


% --- Executes during object creation, after setting all properties.
function name_design_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', handles.name);


% --- Executes on button press in linear.
function linear_Callback(hObject, eventdata, handles)
% hObject    handle to linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linear


% --- Executes on button press in non_linear.
function non_linear_Callback(hObject, eventdata, handles)
% hObject    handle to non_linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of non_linear


function model_CreateFcn(hObject, eventdata, handles)


% --- Executes when selected object is changed in model.
function model_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in model 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.linear 
    % We have a lineral model
    set(handles.f_text,'String','f');
    set(handles.theta_0,'Visible','off');
    set(handles.theta_0_text,'Visible','off');
    % We change the example input
    set(handles.f,'String','@(x) [1,x(1),x(1)^2,x(2),x(1)*x(2)]''');
    set(handles.k,'String','5');
    set(handles.m,'String','10');
    set(handles.co,'String','2');
    set(handles.matrix_to_estimate,'Data',eye(5));
    set(handles.bounds,'String','-1 1; 0 1; 0 1');
    set(handles.auxiliar_funts,'Visible','off');
    set(handles.auxiliar_funts_text1,'Visible','off');
    set(handles.auxiliar_funts_text2,'Visible','off');
    set(handles.InformationMatrix, 'Visible','off');
    set(handles.use_gradient, 'Value', 1);
    
elseif hObject == handles.non_linear
    set(handles.f_text,'String','Ixi');
    set(handles.theta_0,'Visible','on');
    set(handles.theta_0_text,'Visible','on');
    % We change the example input
    set(handles.f,'String','@(x,theta) [exp(-theta(2)*x); -x*theta(1)*exp(-theta(2)*x); exp(-theta(4)*x);-x*theta(3)*exp(-theta(4)*x)]');
    set(handles.k,'String','4');
    set(handles.m,'String','4');
    set(handles.co,'String','1');
    set(handles.matrix_to_estimate,'Data',[1 0 0 0; 0 0 1 0]);
    set(handles.bounds,'String','0 3; 0 1');
    set(handles.auxiliar_funts,'Visible','on');
    set(handles.auxiliar_funts_text1,'Visible','on');
    set(handles.auxiliar_funts_text2,'Visible','on');
    set(handles.InformationMatrix, 'Visible','on');
    if handles.useIxi_value == 0
        set(handles.f_text, 'String', 'f');
    else    
        set(handles.f_text, 'String', 'Ixi');
    end
end


% --- Executes on button press in all_matrix.
function all_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to all_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_matrix



function matrix_to_estimate_Callback(hObject, eventdata, handles)
% hObject    handle to matrix_to_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of matrix_to_estimate as text
%        str2double(get(hObject,'String')) returns contents of matrix_to_estimate as a double


% --- Executes during object creation, after setting all properties.
function matrix_to_estimate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matrix_to_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'ColumnEditable', true);
set(hObject,'Data', handles.matrix_to_estimate);



function theta_0_Callback(hObject, eventdata, handles)
% hObject    handle to theta_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta_0 as text
%        str2double(get(hObject,'String')) returns contents of theta_0 as a double


% --- Executes during object creation, after setting all properties.
function theta_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', handles.theta_0);
if handles.linear == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end



function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k as text
%        str2double(get(hObject,'String')) returns contents of k as a double

% Change the matrix to estimate
set(handles.matrix_to_estimate, 'Data', eye(str2num((get(handles.k, 'String'))))); 


% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', handles.k);



function m_Callback(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m as text
%        str2double(get(hObject,'String')) returns contents of m as a double


% --- Executes during object creation, after setting all properties.
function m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', handles.m);



function co_Callback(hObject, eventdata, handles)
% hObject    handle to co (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of co as text
%        str2double(get(hObject,'String')) returns contents of co as a double

X_0 = zeros(str2num(get(handles.n_points, 'String')), str2num(get(handles.co, 'String')));
set(handles.X_0_table, 'Data', X_0);


% --- Executes during object creation, after setting all properties.
function co_CreateFcn(hObject, eventdata, handles)
% hObject    handle to co (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', handles.co);



function bounds_Callback(hObject, eventdata, handles)
% hObject    handle to bounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bounds as text
%        str2double(get(hObject,'String')) returns contents of bounds as a double


% --- Executes during object creation, after setting all properties.
function bounds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', handles.bounds);


% --- Executes on key press with focus on all_matrix and none of its controls.
function all_matrix_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to all_matrix (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over all_matrix.
function all_matrix_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to all_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in matrix_to_estimate_box.
function matrix_to_estimate_box_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in matrix_to_estimate_box 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.matrix_all
    k = str2num(get(handles.k,'string'));
    Eye_matrix = eye(k);
    set(handles.matrix_to_estimate,'Data',Eye_matrix);
    set(handles.matrix_to_estimate,'Enable','off');
elseif hObject == handles.matrix_specify
    set(handles.matrix_to_estimate,'Enable','on');
end


% --- Executes on button press in matrix_specify.
function matrix_specify_Callback(hObject, eventdata, handles)
% hObject    handle to matrix_specify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of matrix_specify


% --- Executes on button press in matrix_all.
function matrix_all_Callback(hObject, eventdata, handles)
% hObject    handle to matrix_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of matrix_all



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on save and none of its controls.
function save_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on cancel and none of its controls.
function cancel_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function X_0_Callback(hObject, eventdata, handles)
% hObject    handle to X_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_0 as text
%        str2double(get(hObject,'String')) returns contents of X_0 as a double


% --- Executes during object creation, after setting all properties.
function X_0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n0_Callback(hObject, eventdata, handles)
% hObject    handle to n0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n0 as text
%        str2double(get(hObject,'String')) returns contents of n0 as a double


% --- Executes during object creation, after setting all properties.
function n0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end
set(hObject, 'String', handles.n0);



function n1_Callback(hObject, eventdata, handles)
% hObject    handle to n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n1 as text
%        str2double(get(hObject,'String')) returns contents of n1 as a double


% --- Executes during object creation, after setting all properties.
function n1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end
set(hObject, 'String', handles.n1);


% --------------------------------------------------------------------
function X_0_table_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to X_0_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function n_points_Callback(hObject, eventdata, handles)
% hObject    handle to n_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_points as text
%        str2double(get(hObject,'String')) returns contents of n_points as a double
X_0 = zeros(str2num(get(handles.n_points, 'String')), str2num(get(handles.co, 'String')));
omega_0 = zeros(str2num(get(handles.n_points, 'String')), 1);
set(handles.X_0_table, 'Data', X_0);
set(handles.omega_0_table, 'Data', omega_0);


% --- Executes during object creation, after setting all properties.
function n_points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end
set(hObject, 'String', handles.n_points);

% --- Executes during object creation, after setting all properties.
function form_new_problem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to form_new_problem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global file;

% Obtain the line othe problem to be modify
line = -1;
h = findobj('Tag','form_problem');
if ~isempty(h)
    line = getappdata(h, 'line_problem_edit');
end

    handles.name='Example1';
    handles.linear = 1;
    handles.useIxi_value = 0;
    handles.f = '@(x) [1,x(1),x(1)^2,x(2),x(1)*x(2)]''';
    handles.auxiliar_funts = sprintf('g=@(x) [1,x]''\nJ=@(x) g(x)*g(x)''\nPI=@(x,i) exp(g(x)''*theta(:,i))/(1+exp(g(x)''*theta(:,1))+exp(g(x)''*theta(:,2)))');
    handles.theta_0 = '1,1,1,2';
    handles.k = 5;
    handles.m = 10;
    handles.co = 2;
    handles.matrix_to_estimate = eye (handles.k);
    handles.bounds = '-1 1; 0 1; 0 1';
    handles.stage = 1; % 1 one stage, 0 multistage design
    handles.n0 = 0;
    handles.n1 = 1;
    handles.omega_0 = str2num('1/4; 1/4; 1/4; 1/4');
    handles.n_points = 4;
    handles.X_0 = zeros(handles.n_points, handles.co);
    
if line == -1 % This will be a new problem
    % NEW PROBLEM
else % This is an existing problem
    error = 0;
    
    % Open file and search for the line where the problem starts
    fd = fopen(file, 'r'); 
    if fd == -1
        error = 1;
    end
    Data = textscan(fd, '%s', 'delimiter', '\n', 'whitespace', '');
    CStr = Data{1};
    fclose(fd);

    % Name
    name = CStr(line + 1);
    handles.name = name{:};
    % Type
    if strcmp(CStr(line + 2), 'linear_model')
        handles.linear = 1;
        handles.useIxi_value = 0;
    elseif strcmp(CStr(line + 2), 'non-linear_model')
        handles.linear = 0;
        useIxi = CStr(line + 3);
        handles.useIxi_value = str2num(useIxi{:});
        line = line + 1;
    end
    % Function
    f = CStr(line + 3);
    handles.f = f{:};
    % Theta_0
    theta_0 = CStr(line + 4);
    handles.theta_0 = theta_0{:};
    % Auxiliar functions
    auxiliarf = [];
    if handles.linear == 0
        line = line + 1;
        n_auxiliarf_cell = CStr(line + 4);
        n_auxiliarf = str2num(n_auxiliarf_cell{:});
        for i = 1:n_auxiliarf
            line = line + 1;
            auxiliarf_cell = CStr(line + 4);
            auxiliarf = [auxiliarf auxiliarf_cell];
        end
    end
    handles.auxiliar_funts = auxiliarf;
    % k
    k = CStr(line + 5);
    handles.k = k{:};
    % m
    m = CStr(line + 6);
    handles.m = m{:};
    % co
    co = CStr(line + 7);
    handles.co = co{:};
    % Matrix to estimate
    matrix_cell = CStr(line + 8);
    handles.matrix_to_estimate = str2num(matrix_cell{:});
    % Bounds
    bounds = CStr(line + 9);
    handles.bounds = bounds{:};
    % Stage
    if strcmp(CStr(line + 10), 'one-stage')
        handles.stage = 1;
    elseif strcmp(CStr(line + 10), 'multistage')
        handles.stage = 0;
    end
    % n0
    n0 = CStr(line + 11);
    handles.n0 = n0{:};
    % n1
    n1 = CStr(line + 12);
    handles.n1 = n1{:};
    % omega_0
    omega_0 =  CStr(line + 13);
    handles.omega_0 = str2num(omega_0{:});
    % n_points
    n_points = CStr(line + 14);
    handles.n_points = n_points{:};
    % Weigth
    weigth = CStr(line + 15);
    handles.X_0 = str2num(weigth{:});
    
end

guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function X_0_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_0_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'ColumnEditable', true);
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end
set(hObject, 'Data', handles.X_0);


% --- Executes during object deletion, before destroying properties.
function matrix_to_estimate_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to matrix_to_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in stages.
function stages_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in stages 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.one_stage 
    % One stage design
    set(handles.n0,'Visible','off');
    set(handles.n0_text,'Visible','off');
    set(handles.n1,'Visible','off');
    set(handles.n1_text,'Visible','off');
    set(handles.omega_0_table,'Visible','off');
    set(handles.omega_0_text,'Visible','off');
    set(handles.n_points,'Visible','off');
    set(handles.n_points_text,'Visible','off');
    set(handles.X_0_table,'Visible','off');
    set(handles.X_0_text,'Visible','off');
elseif hObject == handles.multistage
    % Multistage design
    X_0 = zeros(str2num(get(handles.n_points, 'String')), str2num(get(handles.co, 'String')));
    set(handles.X_0_table, 'Data', X_0);
    
    set(handles.n0,'Visible','on');
    set(handles.n0_text,'Visible','on');
    set(handles.n1,'Visible','on');
    set(handles.n1_text,'Visible','on');
    set(handles.omega_0_table,'Visible','on');
    set(handles.omega_0_text,'Visible','on');
    set(handles.n_points,'Visible','on');
    set(handles.n_points_text,'Visible','on');
    set(handles.X_0_table,'Visible','on');
    set(handles.X_0_text,'Visible','on');
end


% --- Executes during object creation, after setting all properties.
function linear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', handles.linear);


% --- Executes during object creation, after setting all properties.
function non_linear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to non_linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.linear == 0
    set(hObject, 'Value', 1);
else
    set(hObject, 'Value', 0);
end;


% --- Executes during object creation, after setting all properties.
function f_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.linear == 1
    set(hObject, 'String', 'f');
else
    if handles.useIxi_value == 0
        set(hObject, 'String', 'f');
    else    
        set(hObject, 'String', 'Ixi');
    end
end;


% --- Executes during object creation, after setting all properties.
function theta_0_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_0_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.linear == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function one_stage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to one_stage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', handles.stage);


% --- Executes during object creation, after setting all properties.
function multistage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multistage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.stage == 0
    set(hObject, 'Value', 1);
else
    set(hObject, 'Value', 0);
end


% --- Executes during object creation, after setting all properties.
function n0_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n0_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function n1_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function omega_0_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omega_0_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function n_points_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_points_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function X_0_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_0_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function omega_0_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omega_0_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'ColumnEditable', true);
if handles.stage == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end
set(hObject, 'Data', handles.omega_0);



function auxiliar_functions_Callback(hObject, eventdata, handles)
% hObject    handle to auxiliar_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auxiliar_functions as text
%        str2double(get(hObject,'String')) returns contents of auxiliar_functions as a double


% --- Executes during object creation, after setting all properties.
function auxiliar_functions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auxiliar_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function auxiliar_funts_Callback(hObject, eventdata, handles)
% hObject    handle to auxiliar_funts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auxiliar_funts as text
%        str2double(get(hObject,'String')) returns contents of auxiliar_funts as a double


% --- Executes during object creation, after setting all properties.
function auxiliar_funts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auxiliar_funts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',handles.auxiliar_funts);
if handles.linear == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes when model is resized.
function model_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function auxiliar_funts_text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auxiliar_funts_text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.linear == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function auxiliar_funts_text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auxiliar_funts_text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.linear == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes when selected object is changed in InformationMatrix.
function InformationMatrix_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in InformationMatrix 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.use_gradient
    set(handles.f_text,'String','f');
    handles.useIxi_value = 0;
elseif hObject == handles.use_Ixi
    set(handles.f_text,'String','Ixi');
    handles.useIxi_value = 1;
end


% --- Executes during object creation, after setting all properties.
function InformationMatrix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InformationMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.linear == 1
    set(hObject, 'Visible', 'off');
else
    set(hObject, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function use_gradient_CreateFcn(hObject, eventdata, handles)
% hObject    handle to use_gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.useIxi_value == 0
    set(hObject, 'Value', 1);
else
    set(hObject, 'Value', 0);
end;


% --- Executes during object creation, after setting all properties.
function use_Ixi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to use_Ixi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.useIxi_value == 1
    set(hObject, 'Value', 1);
else
    set(hObject, 'Value', 0);
end;
