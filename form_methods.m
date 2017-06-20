function varargout = form_methods(varargin)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% FORM_METHODS MATLAB code for form_methods.fig
%      FORM_METHODS, by itself, creates a new FORM_METHODS or raises the existing
%      singleton*.
%
%      H = FORM_METHODS returns the handle to a new FORM_METHODS or the handle to
%      the existing singleton*.
%
%      FORM_METHODS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_METHODS.M with the given input arguments.
%
%      FORM_METHODS('Property','Value',...) creates a new FORM_METHODS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_methods_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_methods_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_methods

% Last Modified by GUIDE v2.5 27-Mar-2017 00:25:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_methods_OpeningFcn, ...
                   'gui_OutputFcn',  @form_methods_OutputFcn, ...
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


% --- Executes just before form_methods is made visible.
function form_methods_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_methods (see VARARGIN)

% Choose default command line output for form_methods
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes form_methods wait for user response (see UIRESUME)
% uiwait(handles.form_methods);


% --- Outputs from this function are returned to the command line.
function varargout = form_methods_OutputFcn(hObject, eventdata, handles) 
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

global alg hybrid more_opt;

% spso
value = 1;
if get(handles.spso, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.spso, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% ga
value = 2;
if get(handles.ga, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.ga, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% sa
value = 3;
if get(handles.sa, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.sa, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% active set
value = 4;
if get(handles.activeset, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.activeset, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% interior point
value = 5;
if get(handles.interiorpoint, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.interiorpoint, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% sqp
value = 6;
if get(handles.sqp, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.sqp, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% nelder mead
value = 7;
if get(handles.neldermead, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.neldermead, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

% pattern search
value = 8;
if get(handles.patternsearch, 'Value') == 1.0
    if find(alg == value)
    else
        alg(end + 1) = value;
    end
elseif get(handles.patternsearch, 'Value') == 0.0 & find(alg == value)
    alg(find(alg == value)) = [];
end

if(get(handles.hybrids, 'Value') == 1.0)
    hybrid.hybrid = 1;
else
    hybrid.hybrid = 0;
end

hybrid.nc = str2num(get(handles.nc, 'String'));

more_opt.replicas = str2num(get(handles.replicas, 'String'));
more_opt.global_it = str2num(get(handles.global_it, 'String'));
more_opt.ill_cond = get(handles.ill_conditioning, 'Value');
more_opt.eta = str2num(get(handles.eta, 'String'));
more_opt.population = str2num(get(handles.population, 'String'));
more_opt.exacts_it = str2num(get(handles.exacts_it, 'String'));


close;



% --- Executes on button press in more.
function more_Callback(hObject, eventdata, handles)
% hObject    handle to more (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global more_opt;
if more_opt.more == 0
    more_opt.more = 1;
    set(handles.more_panel, 'Visible', 'on');
else
    more_opt.more = 0;
    set(handles.more_panel, 'Visible', 'off');
end


function replicas_Callback(hObject, eventdata, handles)
% hObject    handle to replicas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of replicas as text
%        str2double(get(hObject,'String')) returns contents of replicas as a double


% --- Executes during object creation, after setting all properties.
function replicas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to replicas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global more_opt;
set(hObject, 'String', more_opt.replicas);


function global_it_Callback(hObject, eventdata, handles)
% hObject    handle to global_it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of global_it as text
%        str2double(get(hObject,'String')) returns contents of global_it as a double


% --- Executes during object creation, after setting all properties.
function global_it_CreateFcn(hObject, eventdata, handles)
% hObject    handle to global_it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global more_opt;
set(hObject, 'String', more_opt.global_it);


function population_Callback(hObject, eventdata, handles)
% hObject    handle to population (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of population as text
%        str2double(get(hObject,'String')) returns contents of population as a double


% --- Executes during object creation, after setting all properties.
function population_CreateFcn(hObject, eventdata, handles)
% hObject    handle to population (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global more_opt;
set(hObject, 'String', num2str(more_opt.population));


function exacts_it_Callback(hObject, eventdata, handles)
% hObject    handle to exacts_it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exacts_it as text
%        str2double(get(hObject,'String')) returns contents of exacts_it as a double


% --- Executes during object creation, after setting all properties.
function exacts_it_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exacts_it (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global more_opt;
set(hObject, 'String', more_opt.exacts_it);


% --- Executes on button press in interiorpoint.
function interiorpoint_Callback(hObject, eventdata, handles)
% hObject    handle to interiorpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of interiorpoint


% --- Executes on button press in sqp.
function sqp_Callback(hObject, eventdata, handles)
% hObject    handle to sqp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sqp


% --- Executes on button press in neldermead.
function neldermead_Callback(hObject, eventdata, handles)
% hObject    handle to neldermead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of neldermead


% --- Executes on button press in patternsearch.
function patternsearch_Callback(hObject, eventdata, handles)
% hObject    handle to patternsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of patternsearch


% --- Executes on button press in activeset.
function activeset_Callback(hObject, eventdata, handles)
% hObject    handle to activeset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of activeset


% --- Executes on button press in ga.
function ga_Callback(hObject, eventdata, handles)
% hObject    handle to ga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ga


% --- Executes on button press in sa.
function sa_Callback(hObject, eventdata, handles)
% hObject    handle to sa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sa


% --- Executes on button press in spso.
function spso_Callback(hObject, eventdata, handles)
% hObject    handle to spso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spso


% --- Executes on button press in hybrids.
function hybrids_Callback(hObject, eventdata, handles)
% hObject    handle to hybrids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hybrids
if get(hObject, 'Value') == 1.0
    set(handles.nc_text, 'Visible', 'on');
    set(handles.nc, 'Visible', 'on');
    set(handles.info_nc, 'Visible', 'on');
    set(handles.nc, 'String', num2str([3]));
else
    set(handles.nc_text, 'Visible', 'off');
    set(handles.nc, 'Visible', 'off');
    set(handles.info_nc, 'Visible', 'off');
    set(handles.nc, 'String', num2str([0]));
end


function nc_Callback(hObject, eventdata, handles)
% hObject    handle to nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nc as text
%        str2double(get(hObject,'String')) returns contents of nc as a double


% --- Executes during object creation, after setting all properties.
function nc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global hybrid;
if hybrid.hybrid == 1
    set(hObject, 'Visible', 'on');
    set(hObject, 'String', num2str(hybrid.nc));
else
    set(hObject, 'Visible', 'off');
end
set(hObject, 'String', num2str(hybrid.nc));

% --- Executes during object creation, after setting all properties.
function spso_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 1)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function ga_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 2)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function sa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 3)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function activeset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to activeset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 4)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function interiorpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interiorpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 5)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function sqp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sqp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 6)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function neldermead_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neldermead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 7)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function patternsearch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to patternsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global alg;
if find(alg == 8)
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function hybrids_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hybrids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global hybrid;
if hybrid.hybrid == 1
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end


% --- Executes during object creation, after setting all properties.
function more_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to more_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global more_opt;
if more_opt.more == 1
    set(hObject, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function nc_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nc_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global hybrid;
if hybrid.hybrid == 1
    set(hObject, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function info_nc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global hybrid;
if hybrid.hybrid == 1
    set(hObject, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off');
end


% --- Executes on button press in ill_conditioning.
function ill_conditioning_Callback(hObject, eventdata, handles)
% hObject    handle to ill_conditioning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ill_conditioning
if get(hObject, 'Value') == 1.0
    set(handles.eta_text, 'Visible', 'on');
    set(handles.eta, 'Visible', 'on');
else
    set(handles.eta_text, 'Visible', 'off');
    set(handles.eta, 'Visible', 'off');
end



function eta_Callback(hObject, eventdata, handles)
% hObject    handle to eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta as text
%        str2double(get(hObject,'String')) returns contents of eta as a double


% --- Executes during object creation, after setting all properties.
function eta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global more_opt;
if more_opt.ill_cond == 1
    set(hObject, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off');
end
set(hObject, 'String', num2str(more_opt.eta));

% --- Executes during object creation, after setting all properties.
function eta_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global more_opt;
if more_opt.ill_cond == 1
    set(hObject, 'Visible', 'on');
else
    set(hObject, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function ill_conditioning_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ill_conditioning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global more_opt;
if more_opt.ill_cond == 1
    set(hObject, 'Value', 1.0);
else
    set(hObject, 'Value', 0.0);
end
