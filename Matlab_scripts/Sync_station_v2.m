function varargout = Sync_station_v2(varargin)
% SYNC_STATION_V2 MATLAB code for Sync_station_v2.fig
%      This code is an updated version of the accelerometer annotation
%      software designed for Galea et al., 2021 by Chris Clemente. The
%      function of this program is to annotate a raw accelerometer trace
%      with the behaviours it contains based on concurrently filmed video.
%      A video is loaded, the datetime of the connected 




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sync_station_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @Sync_station_v2_OutputFcn, ...
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


% --- Executes just before Sync_station_v2 is made visible.
function Sync_station_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sync_station_v2 (see VARARGIN)

% Choose default command line output for Sync_station_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sync_station_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sync_station_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function mydisplay(hObject, eventdata, handles)
% main update screen function

%handles.frame=round(get(handles.slider_frames,'Value'));
%set(handles.edit3_framenum,'String',num2str(handles.frame));
% angle=str2double(get(handles.rotation,'String'));
% low_in=str2double(get(handles.low_in,'String'))/handles.white;
% high_in=str2double(get(handles.high_in,'String'))/handles.white;
% gamma=str2double(get(handles.gamma,'String'));

axes(handles.axes1);

%% open and show video frame
if ~isempty(handles.videofile) 
    if strcmp(handles.ext,'.avi') || strcmp(handles.ext,'.AVI')|| strcmp(handles.ext,'.MP4') || strcmp(handles.ext,'.MPG') || strcmp(handles.ext,'.MOV')
            mov = read(handles.video, handles.frame);
%             
    end
    
%     mov = imrotate(mov,angle);
%     mov = imadjust(mov,[low_in; high_in],[0; 1],gamma);
    imshow(mov);
    pause(1/handles.framerate);
end


% axes(handles.axes2)
% vline(100)


guidata(hObject,handles)

% function for displaying the acclerometer
function mydisplay2(hObject, eventdata, handles)

axes(handles.axes2)

framerate=str2double(get(handles.edit4_getframe, 'String'));
samplingF=str2double(get(handles.edit_accelrate, 'String'));
handles.Cfact=samplingF/framerate;

    delay=str2double(get(handles.edit_delay,'String'));
    time_sec=round(handles.frame*handles.Cfact-delay+handles.start);


if get(handles.radiobutton1_zoom,'Value')==0
% displaying and colouring each of the axes
plot(handles.accel_chunk(:,2),'b')
hold on
plot(handles.accel_chunk(:,3),'r')
plot(handles.accel_chunk(:,4),'g')
hold off

 vline(time_sec)

else
 plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom,2),'b')
hold on
plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom,3),'r')
plot(handles.accel_chunk(handles.start_zoom:handles.end_zoom,4),'g')
hold off  

 vline(time_sec-handles.start_zoom)

end



% axes(handles.axes3)
% plot(handles.time,handles.act,'b')

guidata(hObject,handles)

% function for displaying the acclerometer
function mydisplay3(hObject, eventdata, handles)

axes(handles.axes3)

framerate=str2double(get(handles.edit4_getframe, 'String'));
samplingF=str2double(get(handles.edit_accelrate, 'String'));
handles.Cfact=samplingF/framerate;

    delay=str2double(get(handles.edit_delay,'String'));
    time_sec=round(handles.frame*handles.Cfact-delay+handles.start);


% displaying and colouring each of the axes
plot(handles.accel_chunk(:,2),'b')
hold on
plot(handles.behaviours,'r')
hold off
 vline(time_sec)

% axes(handles.axes3)
% plot(handles.time,handles.act,'b')


guidata(hObject,handles)


%PUSH BUTTONS 

% --- Executes on button press in pushbutton1_video.
% push button for accessing the video
function pushbutton1_video_Callback(hObject, eventdata, handles)
[handles.videofilename, handles.pathname]=uigetfile({'*.MOV;*.avi;*.MP4;*.seq','Video files';'*.tif;*.jpg;*.bmp', 'Image files'},'pick file');
handles.videofile = fullfile(handles.pathname,handles.videofilename);
[~,handles.name,handles.ext] = fileparts(handles.videofile);

%% MOV files, initialise
    video = VideoReader(handles.videofile);
        lastFrame = read(video, inf);
        numFrames = video.NumberOfFrames;
        handles.video=video;
        handles.totalframes = video.NumberOfFrames;
        handles.height = video.Height;
        handles.width = video.Width;
        handles.white= 2^(video.BitsPerPixel/3)-1; 
        handles.framerate = video.FrameRate;
        set(handles.edit4_getframe,'String',handles.framerate);
        set(handles.slider1,'max',handles.totalframes, 'min',1,'Value',1);
        set(handles.slider1, 'SliderStep', [1/handles.totalframes , 10/handles.totalframes ]);
set(handles.edit_framenum,'String','1');
%set(handles.edit2_totalframes,'String',num2str(handles.totalframes));
set(handles.edit1,'String',handles.videofilename);
handles.frame=1;
handles.rect=[];
handles.stop=0;

guidata(hObject, handles);
mydisplay(hObject, eventdata, handles)


function pushbutton2_accel_Callback(hObject, eventdata, handles)

set(handles.edit_delay,'String','0')
set(handles.radiobutton1_zoom,'Value',0)

% find the video time (which happens to be the end)
videoendtime=get(handles.edit_acceldate, 'String');
DateNumber = datetime( videoendtime ); % convert to date time
% find the start time by getting the end time minus the duration
DateNumber_start = DateNumber - seconds((handles.totalframes*(1/handles.framerate)));

[handles.accelfilename, handles.pathname]=uigetfile('*.csv*','pick file');
handles.accelfile = fullfile(handles.pathname,handles.accelfilename);
%set(handles.edit15_timestamp,'String',handles.accelfilename);

% get the first 2 rows of the accelerometer trace
% we are going to use this to determine the frame rate
% indexing begins at 0 for this specific case

try
accel_temp=dlmread(handles.accelfile,',',[0,0,1,3]);
catch
accel_temp=importdata(handles.accelfile);
end


% get the time interval between the two instances
time_interval_in_seconds = etime(datevec(accel_temp(2,1)),datevec(accel_temp(1,1)));

% now we want to find the part of the accelerometer trace that aligns with
% the video content
%time interval from the start of the accel file to the start of the video
time_interval_in_seconds2 = etime(datevec(DateNumber_start),datevec(accel_temp(1,1)));

% calculate the first line of the accel trace you want to retrieve
start=round(time_interval_in_seconds2/time_interval_in_seconds);
handles.start=start;
% calaculate the last line of the accel trace you want to retrieve
% do this by getting the start, and then adding the number of frames equal
% to the duration of the video
end_vid=round(start+(handles.totalframes*(1/handles.framerate)/(1/str2double(get(handles.edit_accelrate,'String')))));

% add buffers (to account for rounding inaccuracies and drift)
start_buffer=start-str2double(get(handles.edit3_buffer,'String'));
end_buffer=round(end_vid+str2double(get(handles.edit3_buffer,'String')));

% the start buffer may be a negative frame number, so account for this by
% setting negative values to 0
if start_buffer<0
    start_buffer=0;
end
% the end buffer might be longer than the whole trace, so account for this
% by preventing the frame index exceeding the avaliable row index
try
   accel_chunk=dlmread(handles.accelfile,',',[start_buffer,0,end_buffer,3]);
catch
   accel_chunk=dlmread(handles.accelfile,',',[start_buffer,0,end_vid,3]);
end

handles.accel_chunk=accel_chunk;

set(handles.edit2,'String',datestr(accel_chunk(1,1)))


%create a vector of zeros which will become the behaviours
handles.behaviours=zeros(length(accel_chunk(:,1)),1);



guidata(hObject,handles)
mydisplay2(hObject, eventdata, handles)
mydisplay3(hObject, eventdata, handles)

% --- Executes on button press in pushbutton3_forward.
function pushbutton3_forward_Callback(hObject, eventdata, handles)
global stop
stop = true;

%axes(handles.axes1)
handles.stop = 0;

step=str2double(get(handles.edit5_frame_step, 'String')); 
handles.frame=str2double(get(handles.edit_framenum, 'String')); 

while(1)
%    frame = read(handles.video,handles.frame);
%    imshow(frame); % You may use button to host the image
   %drawnow
   
   % Stop playing
%     if handles.stop == 1
%        break;
%     end
    
    % Stop playing
    if stop == false
       break;
    end

    handles.frame = handles.frame+step;
    set(handles.slider1,'Value',handles.frame);
    set(handles.edit_framenum,'String',num2str(handles.frame));
    
    % If frame is finished, break
    
    if handles.frame>handles.totalframes
         break;
    end
    
    mydisplay(hObject, eventdata, handles)
    mydisplay2(hObject, eventdata, handles)
    mydisplay3(hObject, eventdata, handles)
end  
    
% --- Executes on button press in pushbutton4_stop.
function pushbutton4_stop_Callback(hObject, eventdata, handles)
% handles.stop = 1;
% print('you pressed stop')
% guidata(hObject, handles);

 global stop
     stop=false;

% --- Executes on button press in pushbutton_setdelay.
function pushbutton_setdelay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setdelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xmin=[];
xmax=[];
[x,y]=ginput(1);

xmin=round(x(1));
xmin1=xmin(1);

                if xmin1<0
                    xmin1=1;
                end
                
framerate=str2double(get(handles.edit4_getframe, 'String'));
samplingF=str2double(get(handles.edit_accelrate, 'String'));
handles.Cfact=samplingF/framerate;


%currently this doesn't work in zoom mode. 
%would need to have an IF loop maybe? 

if get(handles.radiobutton1_zoom, 'Value')==0
    %delay=str2double(get(handles.edit_delay,'String'));
    %gets the current frame then removes the cursor position. 
    time_sec=round(handles.frame*handles.Cfact+handles.start); 
    set(handles.edit_delay,'String',num2str(time_sec-xmin1))
else
    %delay=str2double(get(handles.edit_delay,'String'));
    %old version
    %time_sec=round(handles.frame*handles.Cfact-delay+handles.start-handles.start_zoom); 
    
    %this is the current frame if it wasn't zoomed in. 
    time_sec=round(handles.frame*handles.Cfact+handles.start); 
    
    %delay will now be the difference between time_sec and 
    new_delay=round(time_sec-(handles.start_zoom+xmin1));
    set(handles.edit_delay,'String',num2str(new_delay))

end
    
%set(handles.edit_delay,'String',num2str(time_sec-xmin1))
guidata(hObject, handles);
mydisplay2(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_zoom.
function pushbutton_zoom_Callback(hObject, eventdata, handles)
xmin=[];
xmax=[];
xmin1=[];
xmax1=[];
[x,y]=ginput(2);
xmin=round(x(1));
xmin1=xmin(1);
xmax=round(x(2));
xmax1=xmax(1);
                if xmin1<0
                    xmin1=1;
                end
                if xmin1>xmax1
                    xmax1=xmin1;
                    xmin1=xmax1;
                else
                    xmin1=xmin1;
                    xmax1=xmax1;
                end

set(handles.radiobutton1_zoom,'Value',1)                
                
%set the start and end points to zoom into. This will be read by the
%mydisplay2 function when the zoom radio button is checked. 
handles.start_zoom=xmin1;
handles.end_zoom=xmax1;
guidata(hObject, handles);
mydisplay2(hObject, eventdata, handles)

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
%loads behaviours
[handles.behaviourfilename, handles.pathname]=uigetfile('*.csv*','pick file');
handles.behfile = fullfile(handles.pathname,handles.behaviourfilename);

delimiterIn = ',';
handles.beh=readtable(handles.behfile);

% age = [32 ;23; 15; 17; 21]; 
% names = {'Howard';'Harry'; 'Mark'; 'Nik'; 'Mike'}; 
% gen = {'M'  ;'M' ; 'M'; 'F'; 'M'}; 
%tab = table(handles.beh);

set(handles.uitable1, 'Data', table2cell(handles.beh));
set(handles.uitable1, 'ColumnName', {'number','behaviour'});
guidata(hObject,handles)


% --- Executes on button press in pushbutton_tagbeh.
function pushbutton_tagbeh_Callback(hObject, eventdata, handles)

behnum=str2num(get(handles.edit_behnum,'String'));

xmin=[];
xmax=[];
xmin1=[];
xmax1=[];
[x,y]=ginput(2);
xmin=round(x(1));
xmin1=xmin(1);
xmax=round(x(2));
xmax1=xmax(1);
                if xmin1<0
                    xmin1=1;
                end
                if xmin1>xmax1
                    xmax1=xmin1;
                    xmin1=xmax1;
                else
                    xmin1=xmin1;
                    xmax1=xmax1;
                end


if get(handles.radiobutton1_zoom, 'Value')==0         
    handles.behaviours(xmin1:xmax1)=behnum;
else
    handles.behaviours(handles.start_zoom+xmin1:handles.start_zoom+xmax1)=behnum;
end

guidata(hObject,handles)
mydisplay3(hObject, eventdata, handles)



% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)

%get filename
filename=get(handles.edit1,'String');
newStr = extractBefore(filename,'.');
outfile = [handles.pathname,newStr,'_tagged.csv'];

time=handles.accel_chunk(:,1);
x=handles.accel_chunk(:,2);
y=handles.accel_chunk(:,3); 
z=handles.accel_chunk(:,4); 
behnum=handles.behaviours;

act = NaN( length(handles.accel_chunk(:,2)), 1 ) ;
activity = num2cell( act );

for kk=1:(length(handles.accel_chunk(:,2)))

    if handles.behaviours(kk)~=0
        activity{kk}=table2array(handles.beh((find(table2array(handles.beh(:,1))==handles.behaviours(kk))),2));  
    end

end


tableout = table(time,x,y,z,activity,behnum);

writetable(tableout,outfile)



% 
% 
% for kk=1:(length(handles.accel_chunk(:,2)))
% 
% if handles.behaviours(kk)==0
%     behnum=0;
%     act='NA';
% else
%     behnum=handles.behaviours(kk);
%     act=table2array(handles.beh((find(table2array(handles.beh(:,1))==handles.behaviours(kk))),2));  
%     act=act{1};
% end
% 
% 
% 
% fid = fopen(outfile,'a+');
%           %       fid = fopen('C:\Users\DrClemente\Desktop\copout.txt','a+');
%  fprintf(fid, '%s\t %6.6f\t %6.6f\t %6.6f\t %6.6f\t %s\t %6.6f\n',newStr,handles.accel_chunk(kk,1),handles.accel_chunk(kk,2),handles.accel_chunk(kk,3), handles.accel_chunk(kk,4), act, behnum);
%  fclose(fid);
%  fclose('all');
% 
% end

fprintf('finished writing accel file\n')





%radio buttons

% --- Executes on button press in radiobutton1_zoom.
function radiobutton1_zoom_Callback(hObject, eventdata, handles)
guidata(hObject,handles)
mydisplay2(hObject, eventdata, handles)
mydisplay3(hObject, eventdata, handles)

% hObject    handle to radiobutton1_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      
 



%Sliders

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.frame=round(get(handles.slider1,'Value'));

if handles.frame>handles.totalframes
    handles.frame=handles.totalframes;
elseif handles.frame<1
    handles.frame=1;
end

set(handles.slider1,'Value',handles.frame);
set(handles.edit_framenum,'String',num2str(handles.frame));

guidata(hObject,handles);
mydisplay(hObject, eventdata, handles);
mydisplay2(hObject, eventdata, handles);
mydisplay3(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end






%EDIT BUTTONS 

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_buffer_Callback(hObject, eventdata, handles)
% hObject    handle to edit3_buffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit3_buffer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3_buffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_getframe_Callback(hObject, eventdata, handles)
% hObject    handle to edit4_getframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit4_getframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4_getframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_frame_step_Callback(hObject, eventdata, handles)
% hObject    handle to edit5_frame_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit5_frame_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5_frame_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_framenum_Callback(hObject, eventdata, handles)

handles.frame=str2double(get(handles.edit_framenum, 'String'));
guidata(hObject, handles);
mydisplay(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_framenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_acceldate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_acceldate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit_acceldate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_acceldate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_accelrate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_accelrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit_accelrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_accelrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_behnum_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_behnum_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%%functions

function hhh=vline(x,in1,in2)
% function h=vline(x, linetype, label)
% 
% Draws a vertical line on the current axes at the location specified by
% 'x'.  Optional arguments are 'linetype' (default is 'r:') and 'label',
% which applies a text label to the graph near the line.  The label appears
% in the same color as the line.
%
% The line is held on the current axes, and after plotting the line, the
% function returns the axes to its prior hold state.
%
% The HandleVisibility property of the line object is set to "off", so not
% only does it not appear on legends, but it is not findable by using
% findobj.  Specifying an output argument causes the function to return a
% handle to the line, so it can be manipulated or deleted.  Also, the
% HandleVisibility can be overridden by setting the root's ShowHiddenHandles
% property to on.
%
% h = vline(42,'g','The Answer')
%
% returns a handle to a green vertical line on the current axes at x=42, and
% creates a text object on the current axes, close to the line, which reads
% "The Answer".
%
% vline also supports vector inputs to draw multiple lines at once.  For
% example,
%
% vline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
%
% draws three lines with the appropriate labels and colors.
% 
% By Brandon Kuczenski for Kensington Labs.
% brandon_kuczenski@kensingtonlabs.com
% 8 November 2001

if length(x)>1  % vector input
    for I=1:length(x)
        switch nargin
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=vline(x(I),linetype,label);
    end
else
    switch nargin
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    case 3
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(gca);
    hold on

    y=get(gca,'ylim');
    h=plot([x x],y,linetype);
    if length(label)
        xx=get(gca,'xlim');
        xrange=xx(2)-xx(1);
        xunit=(x-xx(1))/xrange;
        if xunit<0.8
            text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        else
            text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),label,'color',get(h,'color'))
        end
    end     

    if g==0
    hold off
    end
    set(h,'tag','vline','handlevisibility','off')
end % else

if nargout
    hhh=h;
end
