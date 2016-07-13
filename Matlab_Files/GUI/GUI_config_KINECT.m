function varargout = GUI_config_KINECT(varargin)
% GUI_CONFIG_KINECT MATLAB code for GUI_config_KINECT.fig
%      GUI_CONFIG_KINECT, by itself, creates a new GUI_CONFIG_KINECT or raises the existing
%      singleton*.
%
%      H = GUI_CONFIG_KINECT returns the handle to a new GUI_CONFIG_KINECT or the handle to
%      the existing singleton*.
%
%      GUI_CONFIG_KINECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONFIG_KINECT.M with the given input arguments.
%
%      GUI_CONFIG_KINECT('Property','Value',...) creates a new GUI_CONFIG_KINECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_config_KINECT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_config_KINECT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_config_KINECT

% Last Modified by GUIDE v2.5 13-Jul-2016 11:08:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_config_KINECT_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_config_KINECT_OutputFcn, ...
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


% --- Executes just before GUI_config_KINECT is made visible.
function GUI_config_KINECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_config_KINECT (see VARARGIN)

% Choose default command line output for GUI_config_KINECT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_config_KINECT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_config_KINECT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
addpath('KINECT');


% --- Executes on button press in button_takeSnapshot.
function button_takeSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to button_takeSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

serialNumber    = str2double(handles.edit_serialNumber.String);
scanArea        = [str2double(handles.edit_scanAreaHor.String) str2double(handles.edit_scanAreaVertical.String)];
minDist         = str2double(handles.edit_minDist.String);
maxDist         = str2double(handles.edit_maxDist.String);
thresh          = str2double(handles.edit_threshold.String);
pixSizeMin      = str2double(handles.edit_pixSizeMin.String);
pixSizeMax      = str2double(handles.edit_pixSizeMax.String);

handles.kin     = KINECT_initialize( 'head', serialNumber, 'scanArea',scanArea, 'minDist', minDist, 'maxDist',maxDist,'threshold',thresh,'pixelSizeMin',pixSizeMin,'pixelSizeMax',pixSizeMax); 
[vidDp, vidIR]  = KINECT_startImage( handles.kin );

while(~KINECT_imageReady( vidDp, vidIR ))
end

[ imgD,imgIR ] = KINECT_getImages( vidDp,vidIR );

handles.imgIR   = imgIR;
handles.imgD    = imgD;
imshow(handles.imgIR, 'Parent', handles.axes_Preview)
guidata(hObject, handles);



% --- Executes on button press in pushbutton_analyze.
function pushbutton_analyze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
serialNumber    = str2double(handles.edit_serialNumber.String);
scanArea        = [str2double(handles.edit_scanAreaVertical.String) str2double(handles.edit_scanAreaHor.String)];
minDist         = str2double(handles.edit_minDist.String);
maxDist         = str2double(handles.edit_maxDist.String);
thresh          = str2double(handles.edit_threshold.String);
pixSizeMin      = str2double(handles.edit_pixSizeMin.String);
pixSizeMax      = str2double(handles.edit_pixSizeMax.String);

handles.kin = KINECT_initialize( 'head', serialNumber, 'scanArea',scanArea, 'minDist', minDist, 'maxDist',maxDist,'threshold',thresh,'pixelSizeMin',pixSizeMin,'pixelSizeMax',pixSizeMax); 

pixelTracked = KINECT_trackFiducialPixel(handles.imgIR,handles.imgD,'kinObj',handles.kin);

imshow(handles.imgIR, 'Parent', handles.axes_Preview);
hold on;
if(pixelTracked)
    plot(pixelTracked(:,1),pixelTracked(:,2),'r*')
end
%% Plot lines for scan area
picArea    	= size(handles.imgIR);
scanBoarders = round((picArea - scanArea)./2);
endX = picArea(1);
endY = picArea(2);
y1 = scanBoarders(1);
y2 = endX-scanBoarders(1);
x1 = scanBoarders(2);
x2 = endY-scanBoarders(2);

plot([x1,x1],[y1,y2],'y');
plot([x1,x2],[y2,y2],'y');
plot([x2,x2],[y2,y1],'y');
plot([x2,x1],[y1,y1],'y');

hold off
guidata(hObject, handles);



function edit_scanAreaHor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scanAreaHor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scanAreaHor as text
%        str2double(get(hObject,'String')) returns contents of edit_scanAreaHor as a double


% --- Executes during object creation, after setting all properties.
function edit_scanAreaHor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scanAreaHor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scanAreaVertical_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scanAreaVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scanAreaVertical as text
%        str2double(get(hObject,'String')) returns contents of edit_scanAreaVertical as a double


% --- Executes during object creation, after setting all properties.
function edit_scanAreaVertical_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scanAreaVertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_minDist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minDist as text
%        str2double(get(hObject,'String')) returns contents of edit_minDist as a double


% --- Executes during object creation, after setting all properties.
function edit_minDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxDist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxDist as text
%        str2double(get(hObject,'String')) returns contents of edit_maxDist as a double


% --- Executes during object creation, after setting all properties.
function edit_maxDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixSizeMin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixSizeMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixSizeMin as text
%        str2double(get(hObject,'String')) returns contents of edit_pixSizeMin as a double


% --- Executes during object creation, after setting all properties.
function edit_pixSizeMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixSizeMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixSizeMax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixSizeMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixSizeMax as text
%        str2double(get(hObject,'String')) returns contents of edit_pixSizeMax as a double


% --- Executes during object creation, after setting all properties.
function edit_pixSizeMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixSizeMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_serialNumber_Callback(hObject, eventdata, handles)
% hObject    handle to edit_serialNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_serialNumber as text
%        str2double(get(hObject,'String')) returns contents of edit_serialNumber as a double


% --- Executes during object creation, after setting all properties.
function edit_serialNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_serialNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Initialize.
function pushbutton_Initialize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Initialize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_trackObj_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trackObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trackObj as text
%        str2double(get(hObject,'String')) returns contents of edit_trackObj as a double


% --- Executes during object creation, after setting all properties.
function edit_trackObj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trackObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Save.
function pushbutton_Save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
kin = handles.kin;
save('KINECT/kinObj.mat','kin');


% --- Executes on button press in pushbutton_Load.
function pushbutton_Load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('KINECT\Snapshots\Snapshot1.mat');
handles.imgIR   = imgIR;
handles.imgD    = imgD;
imshow(handles.imgIR, 'Parent', handles.axes_Preview)
guidata(hObject, handles);
