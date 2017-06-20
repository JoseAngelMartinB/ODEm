function varargout = form_design(varargin)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% FORM_DESIGN MATLAB code for form_design.fig
%      FORM_DESIGN, by itself, creates a new FORM_DESIGN or raises the existing
%      singleton*.
%
%      H = FORM_DESIGN returns the handle to a new FORM_DESIGN or the handle to
%      the existing singleton*.
%
%      FORM_DESIGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_DESIGN.M with the given input arguments.
%
%      FORM_DESIGN('Property','Value',...) creates a new FORM_DESIGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_design_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_design_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_design

% Last Modified by GUIDE v2.5 17-Dec-2016 23:47:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_design_OpeningFcn, ...
                   'gui_OutputFcn',  @form_design_OutputFcn, ...
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


% --- Executes just before form_design is made visible.
function form_design_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_design (see VARARGIN)

% Choose default command line output for form_design
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes form_design wait for user response (see UIRESUME)
% uiwait(handles.form_design);


% --- Outputs from this function are returned to the command line.
function varargout = form_design_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function other_p_Callback(hObject, eventdata, handles)
% hObject    handle to other_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of other_p as text
%        str2double(get(hObject,'String')) returns contents of other_p as a double


% --- Executes during object creation, after setting all properties.
function other_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to other_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global design;

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.p = design.p;
set(hObject, 'String', handles.p);
if design.p == 0 || design.p == 1
    set(hObject, 'Enable', 'off');
else
    set(hObject, 'Enable', 'on');
end


% --- Executes during object creation, after setting all properties.
function form_design_CreateFcn(hObject, eventdata, handles)
% hObject    handle to form_design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Initial data:
global design;
if design.exact == 0
    handles.approximated = 1.0;
else
    handles.approximated = 0.0;
end
handles.p = design.p;



guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function approximated_CreateFcn(hObject, eventdata, handles)
% hObject    handle to approximated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', handles.approximated);



% --- Executes during object creation, after setting all properties.
function exact_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design;
if design.exact == 1
    set(hObject, 'Value', 1);
else
    set(hObject, 'Value', 0);
end;


% --- Executes on button press in approximated.
function approximated_Callback(hObject, eventdata, handles)
% hObject    handle to approximated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of approximated


% --- Executes on button press in exact.
function exact_Callback(hObject, eventdata, handles)
% hObject    handle to exact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exact


% --- Executes when selected object is changed in design_buttongroup.
function design_buttongroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in design_buttongroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.approximated, 'Value') == 1.0
    set(handles.exact_buttongroup, 'Visible', 'off');
elseif get(handles.exact, 'Value') == 1.0
    set(handles.exact_buttongroup, 'Visible', 'on');
end


% --- Executes during object creation, after setting all properties.
function exact_buttongroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exact_buttongroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if handles.approximated == 0
    set(hObject, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function AD_buttongroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AD_buttongroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in AD_buttongroup.
function AD_buttongroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in AD_buttongroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.dDesign, 'Value') == 1.0
    set(handles.other_p, 'Enable', 'off');
    handles.p = 0;
    set(handles.other_p, 'String', handles.p);
elseif get(handles.aDesign, 'Value') == 1.0
    set(handles.other_p, 'Enable', 'off');
    handles.p = 1;
    set(handles.other_p, 'String', handles.p);
elseif get(handles.other, 'Value') == 1.0
    set(handles.other_p, 'Enable', 'on');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global design opt file problem_line;
old_exact = design.exact;
design.p = str2num(get(handles.other_p, 'String'));
design.exact = get(handles.exact, 'Value'); 

% Change desgin_text in form_main
if design.exact == 0
    if design.p == 0
        design_text = 'Appro. D-design';
    elseif design.p == 1
        design_text = 'Appro. A-Design';
    else
        design_text = ['Appro. Other: p = ' num2str(design.p) ' design'];
    end
    if old_exact == 1 % Reload problem original m
        opt = design_opt_load(file,problem_line);
    end
else
    if design.p == 0
        design_text = 'Exact. D-design';
    elseif design.p == 1
        design_text = 'Exact. A-Design';
    else
        design_text = ['Exact. Other: p = ' num2str(design.p) ' design'];
    end
    opt.m = str2num(get(handles.n_expsub, 'String'));
end

design_text_ob = findobj('Tag','design_text');
set(design_text_ob, 'String', design_text);

close;


% --- Executes during object creation, after setting all properties.
function dDesign_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dDesign (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design;
if design.p == 0
    set(hObject, 'Value', 1);
end


% --- Executes during object creation, after setting all properties.
function aDesign_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aDesign (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design;
if design.p == 1
    set(hObject, 'Value', 1);
end


% --- Executes during object creation, after setting all properties.
function other_CreateFcn(hObject, eventdata, handles)
% hObject    handle to other (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design;
if design.p ~= 0 | design.p ~= 1
    set(hObject, 'Value', 1);
end



function n_expsub_Callback(hObject, eventdata, handles)
% hObject    handle to n_expsub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_expsub as text
%        str2double(get(hObject,'String')) returns contents of n_expsub as a double


% --- Executes during object creation, after setting all properties.
function n_expsub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_expsub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global opt;
set(hObject, 'String', opt.m);
