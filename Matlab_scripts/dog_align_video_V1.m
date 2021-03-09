function varargout = dog_align_video_V1(varargin)
% DOG_ALIGN_VIDEO_V1 MATLAB code for dog_align_video_V1.fig
%      DOG_ALIGN_VIDEO_V1, by itself, creates a new DOG_ALIGN_VIDEO_V1 or raises the existing
%      singleton*.
%
%      H = DOG_ALIGN_VIDEO_V1 returns the handle to a new DOG_ALIGN_VIDEO_V1 or the handle to
%      the existing singleton*.
%
%      DOG_ALIGN_VIDEO_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOG_ALIGN_VIDEO_V1.M with the given input arguments.
%
%      DOG_ALIGN_VIDEO_V1('Property','Value',...) creates a new DOG_ALIGN_VIDEO_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dog_align_video_V1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dog_align_video_V1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dog_align_video_V1

% Last Modified by GUIDE v2.5 16-Feb-2021 13:37:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dog_align_video_V1_OpeningFcn, ...
                   'gui_OutputFcn',  @dog_align_video_V1_OutputFcn, ...
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


% --- Executes just before dog_align_video_V1 is made visible.
function dog_align_video_V1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dog_align_video_V1 (see VARARGIN)

% Choose default command line output for dog_align_video_V1
handles.output = hObject;
handles.accel_cut=[];
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = dog_align_video_V1_OutputFcn(hObject, eventdata, handles) 
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
    if strcmp(handles.ext,'.avi') || strcmp(handles.ext,'.AVI')|| strcmp(handles.ext,'.MP4') || strcmp(handles.ext,'.mp4') || strcmp(handles.ext,'.MPG') || strcmp(handles.ext,'.MOV')
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


function mydisplay2(hObject, eventdata, handles)

axes(handles.axes2)

plot(handles.accelMM(:,2),'r')
hold on
plot(handles.accelMM(:,3),'g')
plot(handles.accelMM(:,4),'b')
%delay=str2double(get(handles.edit9_delay,'String'));
% time_sec=round(handles.frame*handles.Cfact+delay);
% vline(time_sec, 'k')
hold off

axes(handles.axes3)
plot(handles.time,handles.act,'b')




%handles.timestart=get(handles.edit1,'string');
%time_vid_sec=60*60*str2num(handles.timestart(1:2))+60*str2num(handles.timestart(4:5))+str2num(handles.timestart(7:8));

% handles.timelength=str2num(get(handles.edit4_length,'string'));
% 
% Time_seconds=60*60*handles.accel_mat.timehours(1,1)+60*handles.accel_mat.timeminutes(1,1)+handles.accel_mat.timeseconds(1,1);
% set(handles.edit5_hour_accel,'String',num2str(handles.accel_mat.timehours(1,1)));
% set(handles.edit6_min_accel,'String',num2str(handles.accel_mat.timeminutes(1,1)));
% set(handles.edit7_sec_accel,'String',num2str(handles.accel_mat.timeseconds(1,1)));
% 
% time_diff=time_vid_sec-Time_seconds;
% start_time=round(time_diff*100);
% end_time=start_time+handles.timelength*100;
% accel_cut=handles.accel_mat.x1(round(time_diff*100):round((time_diff*100)-handles.timelength*100));
% handles.accel_cutx=handles.accel_mat.x1(start_time:end_time);
% handles.accel_cuty=handles.accel_mat.y1(start_time:end_time);
% handles.accel_cutz=handles.accel_mat.z1(start_time:end_time);
% axes(handles.axes2)
% plot(handles.accel_cutx,'b')
% hold on
% plot(handles.accel_cuty,'r')
% plot(handles.accel_cutz,'g')
% hold off


guidata(hObject,handles)


function mydisplay3(hObject, eventdata, handles)

    framerate=str2double(get(handles.edit8_fr, 'String'));
    samplingF=str2double(get(handles.edit19, 'String'));
    handles.Cfact=samplingF/framerate;

    delay=str2double(get(handles.edit9_delay,'String'));
    time_sec=round(handles.frame*handles.Cfact+delay);
    
    set(handles.edit20_timeaccel,'String',num2str(time_sec))
    
    axes(handles.axes2)
    plot(handles.accelMM(:,2),'r')
    hold on
    plot(handles.accelMM(:,3),'g')
    plot(handles.accelMM(:,4),'b')
    hold off
    vline(time_sec, 'k')
    
    

guidata(hObject,handles)







%%%%PUSHBUTTONS

% --- Executes on button press in pushbutton1_video.
function pushbutton1_video_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.videofilename, handles.pathname]=uigetfile({'*.MOV;*.avi;*.MP4;*.seq','Video files';'*.tif;*.jpg;*.bmp', 'Image files'},'pick file');
handles.videofile = fullfile(handles.pathname,handles.videofilename);
[~,handles.name,handles.ext] = fileparts(handles.videofile);

cd (handles.pathname);


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
        set(handles.edit8_fr,'String',handles.framerate);
        set(handles.slider1,'max',handles.totalframes, 'min',1,'Value',1);
        set(handles.slider1, 'SliderStep', [1/handles.totalframes , 10/handles.totalframes ]);
set(handles.edit3_framenum,'String','1');
set(handles.edit2_totalframes,'String',num2str(handles.totalframes));
set(handles.edit14_filename,'String',handles.videofilename);
handles.frame=1;
handles.rect=[];
handles.stop=0;


handles.accelMM=handles.accelM;
handles.time=1:length(handles.accelMM(:,2));
handles.act=zeros(size(handles.accelMM(:,2)));


guidata(hObject, handles);
mydisplay(hObject, eventdata, handles)
mydisplay2(hObject, eventdata, handles)



% --- Executes on button press in pushbutton2_accel.
function pushbutton2_accel_Callback(hObject, eventdata, handles)

[handles.accelfilename, handles.pathname]=uigetfile('*.csv*','pick file');
handles.accelfile = fullfile(handles.pathname,handles.accelfilename);
set(handles.edit15_timestamp,'String',handles.accelfilename);

%formatSpec = '%{yyyy-MM-dd HH:mm:SS.FFF}D%f%f%f';
%T = readtable('43534_0000000001.csv','Delimiter',',', 'Format',formatSpec);
handles.accelM=dlmread(handles.accelfile,',');
cd (handles.pathname);
set(handles.edit15_timestamp,'String',datestr(handles.accelM(1,1)))

handles.accelMM=handles.accelM;
handles.time=1:length(handles.accelMM(:,2));
handles.act=zeros(size(handles.accelMM(:,2)));

%gets the time between the first two rows
for i=1:length(handles.accelM)-1
   
    e(i) = etime(datevec(handles.accelM(i+1,1)),datevec(handles.accelM(i,1)));

end

set(handles.edit19,'String',1/mean(e(200:end)))

framerate=str2double(get(handles.edit8_fr, 'String'));
samplingF=str2double(get(handles.edit19, 'String'));
handles.Cfact=samplingF/framerate;

guidata(hObject,handles)
mydisplay2(hObject, eventdata, handles)


% --- Executes on button press in pushbutton3_forward.
function pushbutton3_forward_Callback(hObject, eventdata, handles)
% step=str2double(get(handles.Playstep, 'String'));
%step=str2double(get(handles.edit10_step, 'String'));

step=str2double(get(handles.edit10_step, 'String'));
% step=1;

% while hasFrame(v)
%     video = readFrame(v);
% end




for i=handles.frame+1:step:handles.totalframes
    handles.frame=i;
    guidata(hObject,handles);
    set(handles.slider1,'Value',handles.frame);
    set(handles.edit3_framenum,'String',num2str(handles.frame));
    mydisplay(hObject, eventdata, handles);
    mydisplay3(hObject, eventdata, handles);
    pause(0.1)
    if get(handles.Stop,'Value')
        set(handles.Stop,'Value',0)
        break
    end
end



% --- Executes on button press in pushbutton11_back.
function pushbutton11_back_Callback(hObject, eventdata, handles)
step=str2double(get(handles.edit10_step, 'String'));
% step=1;

% while hasFrame(v)
%     video = readFrame(v);
% end




for i=handles.frame-1:-step:1
    handles.frame=i;
    guidata(hObject,handles);
    set(handles.slider1,'Value',handles.frame);
    set(handles.edit3_framenum,'String',num2str(handles.frame));
    mydisplay(hObject, eventdata, handles);
    mydisplay3(hObject, eventdata, handles);
    pause(0.1)
    if get(handles.Stop,'Value')
        set(handles.Stop,'Value',0)
        break
    end
end



% --- SAVE DELAY BUTTON
function pushbutton4_clock_Callback(hObject, eventdata, handles)
%%%%Saves delay values
set(handles.edit27,'String',get(handles.edit9_delay,'String'))
%set(handles.edit9_delay,'String','0')

% set(handles.edit16,'String',num2str(framediff))


% set(handles.radiobutton1_act1,'Value',1)

% --- Executes on button press in pushbutton5_refresh.
function pushbutton5_refresh_Callback(hObject, eventdata, handles)
%mydisplay2(hObject, eventdata, handles)% hObject    handle to pushbutton5_refresh (see GCBO)

if get(handles.radiobutton4_ml,'value')==1
    max_length=str2double(get(handles.edit18,'String'));
    %min_length=str2double(get(handles.edit30,'String'));
    handles.accelMM=handles.accelM(1:max_length,:);
    %handles.accelMM=handles.accelM(min_length:max_length,:);
end

handles.time=1:length(handles.accelMM(:,2));
handles.act=zeros(size(handles.accelMM(:,2)));

guidata(hObject,handles)
mydisplay2(hObject, eventdata, handles)


% --- CALC TIME DIFF BUTTON
function pushbutton6_times_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Calc time difference button
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diffdays=str2double(get(handles.edit28,'String'))-str2double(get(handles.edit29,'String'));
diffhour=str2double(get(handles.edit11_hour_video,'String'))-str2double(get(handles.edit24,'String'));
diffmin=str2double(get(handles.edit12_min_video,'String'))-str2double(get(handles.edit25,'String'));
diffsec=str2double(get(handles.edit13_sec_video,'String'))-str2double(get(handles.edit26,'String'));

timediff=diffsec+diffmin*60+diffhour*3600+diffdays*86400;
timediff=timediff*-1;

%should we use video frame rate or accelerometer frame rate??? 
%should be accel i think 9/10/2018
accel_frame=str2double(get(handles.edit19,'String'));
framediff=timediff*accel_frame;


set(handles.edit17_framestart,'String',num2str(framediff))
set(handles.edit1,'String',num2str(timediff))


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton8_sel.
function pushbutton8_sel_Callback(hObject, eventdata, handles)

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
                

start=handles.act(1:xmin1);
ending=handles.act(xmax1+1:length(handles.time));


if get(handles.radiobutton1_act1,'Value')
    activity=1;
    %%sitting
elseif get(handles.radiobutton17,'Value')
    activity=2;
    %%Lying/Resting
elseif get(handles.radiobutton7,'Value')
    activity=3;
    %%Drinking
elseif get(handles.radiobutton14,'Value')
    activity=4;
    %%Eating  
elseif get(handles.radiobutton2_act2,'Value')
    activity=5;
    %%Grooming  
elseif get(handles.radiobutton5,'Value')
    activity=6;
    %%Vigilance
elseif get(handles.radiobutton6,'Value')
    activity=7;
    %%Standing Vig
elseif get(handles.radiobutton9,'Value')
    activity=8;
    %%Walking
elseif get(handles.radiobutton18,'Value')
    activity=9;
    %%Vig Walking  
elseif get(handles.radiobutton10,'Value')
    activity=10;
    %%Defensive Pos
elseif get(handles.radiobutton11,'Value')
    activity=11;
    %%Jumping
elseif get(handles.radiobutton13,'Value')
    activity=12;
    %%Galloping
elseif get(handles.radiobutton12,'Value')
    activity=13;
    %%Climbing
elseif get(handles.radiobutton15,'Value')
    activity=14;
    %%Bounding
end

act_mat=ones(xmax1-xmin1,1)*activity;
handles.act=[start;act_mat;ending];

guidata(hObject,handles);
mydisplay2(hObject, eventdata, handles)
                
         
%
% --- TRIM ACCEL BUTTON
function pushbutton_trim_Callback(hObject, eventdata, handles)

format longE

framerate=str2double(get(handles.edit8_fr, 'String'));
samplingF=str2double(get(handles.edit19, 'String'));
handles.Cfact=samplingF/framerate;

% clock=str2double(get(handles.edit16,'String'));

%get the total number of frames in video 2
video_frames=str2double(get(handles.edit2_totalframes,'String'));

%get the cali frame for reference
accel_cali=str2double(get(handles.edit27,'String'));

%get accel frames between video ends
accel_fr=str2double(get(handles.edit17_framestart,'String'));

%get the number of video frames between cali video and new video
% video_frame_diff=str2double(get(handles.edit17_framestart,'String'));



%units of accel frames
MinA=round(accel_cali+accel_fr);
% Min=Max-(video_frames*handles.Cfact);
% Min2=Min-200;

%units of accel frames
%Max=accel_cali+(video_frame_diff*handles.Cfact);
MaxA=round(MinA+(video_frames*handles.Cfact));
% Max2=Max+200;

% for i=round(Min):round(Max)
%    ee(i) = etime(datevec(handles.accelM(i+1,1)),datevec(handles.accelM(i,1)));
% end
% 
% mean(ee)


set(handles.edit9_delay,'String',num2str(0))
set(handles.edit31,'String',num2str(length(handles.accelMM(:,2)) ))
set(handles.edit4_length,'String',num2str(1))

zoom_fact=str2double(get(handles.edit32_zoom, 'String'));
Frames_edit= (((MaxA-MinA)*zoom_fact) - (MaxA-MinA))/2;

MinB = round(MinA-Frames_edit);
MaxB = round(MaxA+Frames_edit);

if MinB < 1
    MinB = 1;
end

handles.accelMM=handles.accelM(MinB:MaxB,:);
handles.time=1:length(handles.accelMM(:,2));
handles.act=zeros(size(handles.accelMM(:,2)));


%gets the time between the first two rows
% for i=1:length(handles.accelMM)-1
%    
%     e(i) = etime(datevec(handles.accelMM(i+1,1)),datevec(handles.accelMM(i,1)));
% 
% end
% 
% 
% set(handles.edit19,'String',1/mean(e(200:end)))



guidata(hObject,handles)
mydisplay2(hObject, eventdata, handles)



% --- ANALYSE STRIDE BUTTON
function pushbutton9_export_Callback(hObject, eventdata, handles)

%analyse stride
minA=str2num(get(handles.edit4_length,'String'));
maxA=str2num(get(handles.edit31,'String'));

minA2=minA-100;
Time_Acc_Temp_Activity_Mat=handles.accelMM(minA:maxA,:);

% Figure 1

% figure
% plot(Time_Acc_Temp_Activity_Mat(:,2),'b')
% hold on
% plot(Time_Acc_Temp_Activity_Mat(:,3),'r')
% plot(Time_Acc_Temp_Activity_Mat(:,4),'g')
% xlabel('Time (accel samples)')
% ylabel('Accel (G)')
% hold off


Fs=str2num(get(handles.edit19,'String'));

    [Px_x,f] = pwelch(Time_Acc_Temp_Activity_Mat(:,2),[],[],[],Fs,'onesided');
    [Px_y,f] = pwelch(Time_Acc_Temp_Activity_Mat(:,3),[],[],[],Fs,'onesided');
    [Px_z,f] = pwelch(Time_Acc_Temp_Activity_Mat(:,4),[],[],[],Fs,'onesided');
    
     [maxF,ind]=max(Px_x+Px_y+Px_z);
     
     format short g
     sigF=f(ind);
     disp('The dominant stride frequency is...')
     round(sigF, 3)
     
%      Figure 2
        figure    
        semilogy(f,(Px_x),'r')
        hold on
        semilogy(f,(Px_y))
        semilogy(f,(Px_z),'g')
        %semilogy(f,(Px_Mag),'g')
        semilogy(f,(Px_x+Px_y+Px_z),'k')
        xlabel('Frequency (Hz)')
        ylabel('Power')
        hold off
        
        %sigF=3;
        [b,a]=butter(2,sigF/Fs,'low'); 
        [d,c]=butter(2,sigF/Fs,'high');
        time=(1:length(Time_Acc_Temp_Activity_Mat(:,2)))/Fs;
        time=time';
        order=4;
        framelen=13;
        
        %%%result using filter
        x_accel_ms2=Time_Acc_Temp_Activity_Mat(:,2).*9.8;
        acc_x=filter(b,a,x_accel_ms2); 
        v_x=cumtrapz(time,acc_x);
        v_x=filter(d,c,v_x);
        s_x=cumtrapz(time,v_x);
        
        y_accel_ms2=Time_Acc_Temp_Activity_Mat(:,3).*9.8;
        acc_y=filter(b,a,y_accel_ms2);
        v_y=cumtrapz(time,acc_y);
        v_y=filter(d,c,v_y);
        s_y=cumtrapz(time,v_y);
        
        z_accel_ms2=Time_Acc_Temp_Activity_Mat(:,4).*9.8;
        acc_z=filter(b,a,z_accel_ms2);
        v_z=cumtrapz(time,acc_z);
        v_z=filter(d,c,v_z);
        s_z=cumtrapz(time,v_z);
        
        
        
        dist3d= sqrt( ((s_x).^2) + ((s_y).^2) + ((s_z).^2) );
        disp('filtered result distance estimates: NOTE TWO DIFFERENT METHODS USED')
        round(sum(dist3d),3)
        dist3d2 = sqrt( ((sum(s_x)).^2) + ((sum(s_y)).^2) + ((sum(s_z)).^2) );
        round(dist3d2, 3)
        time2=(1:length(dist3d))/Fs;
        
        
%         trim=sum(dist3d(100:end))
        
        
% %         
%         %%%result using filter
%         x_accel_ms2=Time_Acc_Temp_Activity_Mat(:,2).*9.8;
%         acc_x2=filtfilt(b,a,x_accel_ms2); 
%         v_x2=cumtrapz(time,acc_x2);
%         v_x2=filtfilt(d,c,acc_x2);
%         s_x2=cumtrapz(time,v_x2);
%         
%         y_accel_ms2=Time_Acc_Temp_Activity_Mat(:,3).*9.8;
%         acc_y2=filtfilt(b,a,y_accel_ms2);
%         v_y2=cumtrapz(time,acc_y2);
%         v_y2=filtfilt(d,c,acc_y2);
%         s_y2=cumtrapz(time,v_y2);
%         
%         z_accel_ms2=Time_Acc_Temp_Activity_Mat(:,4).*9.8;
%         acc_z2=filtfilt(b,a,z_accel_ms2);
%         v_z2=cumtrapz(time,acc_z2);
%         v_z2=filtfilt(d,c,v_z2);
%         s_z2=cumtrapz(time,v_z2);
%         
%         dist3d= sqrt( ((s_x2).^2) + ((s_y2).^2) + ((s_z2).^2) );
%         print('filtfilt result')
%         sum(dist3d)
%         dist3d2 = sqrt( ((sum(s_x2)).^2) + ((sum(s_y2)).^2) + ((sum(s_z2)).^2) )
%         time2=(1:length(dist3d))/Fs;
        
               
% where:
% f- signal frequency.
% Fs- sampling frequency
% signal - acceleration signal (input)
% a - acceleration vector without noise (after filtering)
% v,s,t - velocity, displacement and time vectors
        
% cla(handles.axes1)
%AccFrequencyAnalysis(Time_Acc_Temp_Activity_Mat, Fs, 1)        


        figure
         plot(acc_x, 'r')
         hold on
%          plot(acc_x2, 'g')
         plot(x_accel_ms2, 'b')
         xlabel('Time')
        ylabel('accel')
         hold off
                
         figure    
        plot(time2,v_x,'b')
         hold on
%         plot(time2,v_x2,'g')
        xlabel('Time')
        ylabel('velocity')
        hold off
        
        figure    
%         
        plot(time2,s_x,'r')
        hold on
%         plot(time2,s_x2,'g')
        xlabel('Time')
        ylabel('displacement')
        hold off
        
       


% --- Executes on button press in pushbutton10_gettime.
function pushbutton10_gettime_Callback(hObject, eventdata, handles)

currentframe=str2double(get(handles.edit20_timeaccel,'String'));

set(handles.edit15_timestamp,'String',datestr(handles.accelM(currentframe,1)))


% --- EXPORT ACCEL BUTTON
function pushbutton12_exp_accel_Callback(hObject, eventdata, handles)

% handles.accelMM

[pathstr,name,ext]=fileparts(handles.videofile);

filename=strcat(pathstr,'\',name,'_accel_out.txt');

% exports data from start to end

minA=str2num(get(handles.edit4_length,'String'));
maxA=str2num(get(handles.edit31,'String'));

Time_Acc_Temp_Activity_Mat=handles.accelMM(minA:maxA,:);
act=handles.act(minA:maxA);

for i=1:length(Time_Acc_Temp_Activity_Mat)
fid = fopen(filename,'a+');
fprintf(fid,'%6.6f\t %6.6f\t %6.6f\t %6.6f\t %6.6f\n',Time_Acc_Temp_Activity_Mat(i,1),Time_Acc_Temp_Activity_Mat(i,2),Time_Acc_Temp_Activity_Mat(i,3),Time_Acc_Temp_Activity_Mat(i,4),act(i));
    fclose(fid);
    fclose('all');
end


% --- Executes on button press in pushbutton13_start.
function pushbutton13_start_Callback(hObject, eventdata, handles)

set(handles.edit4_length,'String',get(handles.edit20_timeaccel,'String'))

% --- Executes on button press in pushbutton14_end.
function pushbutton14_end_Callback(hObject, eventdata, handles)

set(handles.edit31,'String',get(handles.edit20_timeaccel,'String'))











%%%%%%%%%%%%%%SLIDER
 

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
set(handles.edit3_framenum,'String',num2str(handles.frame));

% axes(handles.axes2)
% plot(handles.accelM(:,2),'b')
% hold on
% plot(handles.accelM(:,3),'r')
% plot(handles.accelM(:,4),'g')
% hold off
% 
% %delay=str2double(get(handles.edit9_delay,'Value'))
%delay=str2double(get(handles.edit9_delay,'String'));
% 
% %this appears to pull out a number instead of a string?? 
% 
% % if handles.frame<delay
% %     lineat=0;
% % else
% %     lineat=handles.frame+delay;
% % end
% 
% lineat=handles.frame+delay;
% vline(lineat)

guidata(hObject,handles);
mydisplay(hObject, eventdata, handles);
mydisplay3(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





%%%RADIO BUTTONS


% --- Executes on button press in radiobutton3_trim.
function radiobutton3_trim_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton4_ml.
function radiobutton4_ml_Callback(hObject, eventdata, handles)




%%Sitting
% --- Executes on button press in radiobutton1_act1.
function radiobutton1_act1_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)

%%Grooming
% --- Executes on button press in radiobutton2_act2.
function radiobutton2_act2_Callback(hObject, eventdata, handles)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)

%%Vigilance
% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)

%%Standing Vigilance
% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)

%%Drinking
% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)

%%Walking
% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%Defensive Posturing
% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%Jumping
% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%Climbing
% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%Galloping
% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%Eating
% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)

%%Bounding
% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton18,'value',0)


%%Vigilant Walking
% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton17,'value',0)
set(handles.radiobutton15,'value',0)

%%Lying/Resting
% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
set(handles.radiobutton2_act2,'value',0)
set(handles.radiobutton1_act1,'value',0)
set(handles.radiobutton6,'value',0)
set(handles.radiobutton7,'value',0)
set(handles.radiobutton13,'value',0)
set(handles.radiobutton9,'value',0)
set(handles.radiobutton10,'value',0)
set(handles.radiobutton11,'value',0)
set(handles.radiobutton12,'value',0)
set(handles.radiobutton5,'value',0)
set(handles.radiobutton14,'value',0)
set(handles.radiobutton15,'value',0)
set(handles.radiobutton18,'value',0)





%%%%%%EDIT BUTTONS



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


function edit2_totalframes_Callback(hObject, eventdata, handles)
% hObject    handle to edit2_totalframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit2_totalframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2_totalframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_framenum_Callback(hObject, eventdata, handles)
% hObject    handle to edit3_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit3_framenum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3_framenum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_length_Callback(hObject, eventdata, handles)
% hObject    handle to edit4_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit4_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_hour_accel_Callback(hObject, eventdata, handles)
% hObject    handle to edit5_hour_accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit5_hour_accel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5_hour_accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_min_accel_Callback(hObject, eventdata, handles)
% hObject    handle to edit6_min_accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit6_min_accel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6_min_accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit7_sec_accel_Callback(hObject, eventdata, handles)
% hObject    handle to edit7_sec_accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit7_sec_accel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7_sec_accel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_fr_Callback(hObject, eventdata, handles)
% hObject    handle to edit8_fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit8_fr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8_fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit9_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit9_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_step_Callback(hObject, eventdata, handles)
% hObject    handle to edit10_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit10_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_hour_video_Callback(hObject, eventdata, handles)
% hObject    handle to edit11_hour_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit11_hour_video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11_hour_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit12_min_video_Callback(hObject, eventdata, handles)
% hObject    handle to edit12_min_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit12_min_video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12_min_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_sec_video_Callback(hObject, eventdata, handles)
% hObject    handle to edit13_sec_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit13_sec_video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13_sec_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit14_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit14_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit14_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit15_timestamp_Callback(hObject, eventdata, handles)
% hObject    handle to edit15_timestamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit15_timestamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15_timestamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_framestart_Callback(hObject, eventdata, handles)
% hObject    handle to edit17_framestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17_framestart as text
%        str2double(get(hObject,'String')) returns contents of edit17_framestart as a double


% --- Executes during object creation, after setting all properties.
function edit17_framestart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17_framestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_timeaccel_Callback(hObject, eventdata, handles)
% hObject    handle to edit20_timeaccel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20_timeaccel as text
%        str2double(get(hObject,'String')) returns contents of edit20_timeaccel as a double


% --- Executes during object creation, after setting all properties.
function edit20_timeaccel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20_timeaccel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to edit32_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32_zoom as text
%        str2double(get(hObject,'String')) returns contents of edit32_zoom as a double


% --- Executes during object creation, after setting all properties.
function edit32_zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
