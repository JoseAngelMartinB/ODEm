function varargout = form_result(varargin)

% ODEm - Optimal Design Experiments with Matlab
% Ricardo García Rodenas, José Ángel Martín Baos, José Carlos García García
% Department of Mathematics, Escuela Superior de Informática. University of
% Castilla-La Mancha. Ciudad Real, Spain.

% FORM_RESULT MATLAB code for form_result.fig
%      FORM_RESULT, by itself, creates a new FORM_RESULT or raises the existing
%      singleton*.
%
%      H = FORM_RESULT returns the handle to a new FORM_RESULT or the handle to
%      the existing singleton*.
%
%      FORM_RESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_RESULT.M with the given input arguments.
%
%      FORM_RESULT('Property','Value',...) creates a new FORM_RESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_result_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_result_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_result

% Last Modified by GUIDE v2.5 02-Aug-2017 12:50:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_result_OpeningFcn, ...
                   'gui_OutputFcn',  @form_result_OutputFcn, ...
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


% --- Executes just before form_result is made visible.
function form_result_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_result (see VARARGIN)

% Choose default command line output for form_result
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%% Allow LaTeX strings %%%
% TEXT annotations need an axes as parent so create an invisible axes which
% is as big as the figure
handles.laxis = axes('parent',hObject,'units','normalized','position',[0 0 1 1],'visible','off');
% Find all static text UICONTROLS whose 'Tag' starts with latex_
lbls = findobj(hObject,'-regexp','tag','latex_*');
for i=1:length(lbls)
      l = lbls(i);
      % Get current text, position and tag
      set(l,'units','normalized');
      s = get(l,'string');
      p = get(l,'position');
      t = get(l,'tag');
      % Remove the UICONTROL
      delete(l);
      % Replace it with a TEXT object 
      handles.(t) = text(p(1),p(2),s,'interpreter','latex');
end


% UIWAIT makes form_result wait for user response (see UIRESUME)
% uiwait(handles.results);


% --- Outputs from this function are returned to the command line.
function varargout = form_result_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function design_CreateFcn(hObject, eventdata, handles)
% hObject    handle to design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design;
if design.p == 0
    set(hObject, 'String', 'D-Design');
elseif design.p == 1
    set(hObject, 'String', 'A-Design');
else
    set(hObject, 'String', ['Other design: p = ' num2str(design.p)]);
end


% --- Executes during object creation, after setting all properties.
function w_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
fill_table(1, hObject);


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on selection change in method_popup.
function method_popup_Callback(hObject, eventdata, handles)
% hObject    handle to method_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_popup
global alg hybrid results;
set(handles.loading, 'String', 'Loading...');
drawnow;
pos = get(hObject, 'Value');




fill_table(pos, handles.w_table);
fill_z(pos, handles.z)
fill_time(pos, handles.cpu_time)
fill_eff(pos, handles.efficiency);
set(handles.loading, 'String', '');
set(handles.long_method_name, 'String', results{pos}.longName);
drawnow;


% --- Executes during object creation, after setting all properties.
function method_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global list_alg;

set(hObject, 'String', list_alg);


function fill_table(alg_pos, w_table)
global design results;

data = results{alg_pos}.data;

% Color of the weigth colum
data = reshape(strtrim(cellstr(num2str(data(:)))), size(data));

if design.exact == 0
    data(:,1) = cellfun(@(x) ['<html><table border=0 width=400 bgcolor=#B2ADB2><TR><TD>' x '</TD></TR> </table></html>'], data(:,1), 'UniformOutput', false);
else
    data(:,1) = cellfun(@(x) ['-----------------'], data(:,1), 'UniformOutput', false);
end

set(w_table, 'Data', data);
    

function fill_z(alg_pos, z)
global design results;
if design.p == 0
    if results{alg_pos}.Phi == -1
        f_opt = '---';
    else
        f_opt = results{alg_pos}.Phi;
    end
else
    f_opt = results{alg_pos}.f_opt;
end
set(z, 'String', f_opt);


function fill_time(alg_pos, cpu_time)
global results;
time = results{alg_pos}.time;
set(cpu_time, 'String', time);


function fill_eff(alg_pos, eff)
global results;

if results{alg_pos}.efficiency > 1 || results{alg_pos}.efficiency < 0 % Avoid wrong efficiency results
    eff_per = sprintf('---');
else
    eff_per = sprintf('%.2f%%',100*results{alg_pos}.efficiency);
end

set(eff, 'String', eff_per);


% --- Executes during object creation, after setting all properties.
function z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
fill_z(1, hObject);


% --- Executes during object creation, after setting all properties.
function cpu_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpu_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
fill_time(1, hObject);


% --- Executes during object creation, after setting all properties.
function efficiency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to efficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
fill_eff(1, hObject);


% --- Executes during object creation, after setting all properties.
function results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global problem_name;
[file,path] = uiputfile(strcat(problem_name, '.xls'), 'Save as');

% Obtain the full path name of the file
file = fullfile(path, file);

set(handles.saving, 'String', 'Saving...');
drawnow;

status = save_in_xml(file);

set(handles.saving, 'String', '');
drawnow;


% --- Executes during object creation, after setting all properties.
function appro_exact_design_CreateFcn(hObject, eventdata, handles)
% hObject    handle to appro_exact_design (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global design opt;
if design.exact == 0
    set(hObject, 'String', 'Approximated.');
else
    set(hObject, 'String', ['Exact. Experimental subjects = ' num2str(opt.m)]);
end


% --- Executes when entered data in editable cell(s) in uitable4.
function uitable4_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function long_method_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to long_method_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global results;
set(hObject, 'String', results{1}.longName);


% --- Executes during object creation, after setting all properties.
function latex_text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latex_text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
