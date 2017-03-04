function varargout = VoxDei(varargin)
global mfcc_file
global sbc_file
global wav_file
global signal
global cha_colour
  global max_1
  global max_2
  global max_3
  global i_max_1
  global i_max_2
  global i_max_3

% VoxDei M-file for VoxDei.fig

% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VoxDei

% Last Modified by GUIDE v2.5 21-Oct-2011 09:45:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VoxDei_OpeningFcn, ...
                   'gui_OutputFcn',  @VoxDei_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VoxDei is made visible.
function VoxDei_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for VoxDei
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes VoxDei wait for user response (see UIRESUME)
% uiwait(handles.VoxDei);
% splash('splash.jpg');









% --- Outputs from this function are returned to the command line.
function varargout = VoxDei_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
if ~exist( 'config.mat')
         warndlg('Default Configuration file not found select features file to use or create freash database','Error');
        no_of_fe=0;
else 
load('config.mat');
set(handles.tx_mfcc_file_name,'ForegroundColor',[0 0 0],'String',mfcc_file); 
set(handles.tx_sbc_file_name,'ForegroundColor',[0 0 0],'String',sbc_file);
end;
set(gcf,'CloseRequestFcn',@VoxDei_closefcn)



function VoxDei_closefcn(src,evnt)
global mfcc_file
global sbc_file

 selection = questdlg('Want to QUIT',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         save('config.mat','mfcc_file','sbc_file');
         delete(gcf)
      case 'No'
      return 
   end

% --------------------------------------------------------------------
function m_Select_Callback(hObject, eventdata, handles)
global mfcc_file
global sbc_file



[filename, pathname] = uigetfile('*.mat','Select MFCC Feature file');
  mfcc_file=[pathname filename];
 if mfcc_file== 0
        errordlg('ERROR! No file selected! Data Base settings NOT CHANGED');
        return;
 end 
 

[filename, pathname] = uigetfile('*.mat','Select SBC Feature file');
sbc_file=[pathname filename];
    if sbc_file== 0
        errordlg('ERROR! No file selected! Data Base settings NOT CHANGED');
        return;
    end 

set(handles.tx_sbc_file_name,'ForegroundColor',[0 0 0],'String',sbc_file);    
set(handles.tx_mfcc_file_name,'ForegroundColor',[0 0 0],'String',mfcc_file);    
save('config.mat','mfcc_file','sbc_file');


% --------------------------------------------------------------------
function m_sound_edit_Callback(hObject, eventdata, handles)
    gui();
%sound editer name  is gui
% --------------------------------------------------------------------


function m_Exit_Callback(hObject, eventdata, handles)
global mfcc_file
global sbc_file

 selection = questdlg('Want to QUIT ',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         save('config.mat','mfcc_file','sbc_file');
         delete(gcf)
      case 'No'
      return 
   end



% --- Executes on button press in bt_load.
function bt_load_Callback(hObject, eventdata, handles)
% hObject    handle to bt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global signal
global wav_file
[filename, pathname] = uigetfile('*.wav','select a wave file to load');
    if pathname == 0
        errordlg('ERROR! No file selected!');
        return;
    end    
    wav_file = [pathname filename] ;

    % check if file exist
    if ~exist('wav_file')
        errordlg('ERROR! File not found...');
        help pw;
        return;
    end;
signal=wavread(wav_file);
set(handles.tx_signal_name,'string',wav_file);
plot_sig;
set(handles.tx_result,'visible','off');
set(handles.tx_person_is,'visible','off');
set(handles.tx_Match_Quality,'visible','off');
set(handles.tx_Quality,'visible','off');
set(handles.tx_Algorithm,'visible','off');
set(handles.tx_Algorithm_Used,'visible','off');
set(handles.bt_Details,'visible','off');


% --- Executes on button press in bt_extract.
function bt_extract_Callback(hObject, eventdata, handles)
% hObject    handle to bt_extract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mfcc_file
global sbc_file
global wav_file
global signal

per_name=get(handles.tx_name,'String');
if (ischar(per_name)&(length(per_name)>1))
    load(mfcc_file);
    if (no_of_fe==0) 
        name={''} ;
    end
    if any(strcmp(per_name,cellstr(name))>0)  % find if the new name already exists in data base
        %note down the name that already exists
        matcher = find(strcmp(per_name,cellstr(name)))
        %warndlg (matcher);
        msgbox('Person Already exists and the data may strengthen it');
    else
        matcher = 0
    end   
    
    if 0  % Don't do anything here,find if the new name already exists in data base
        %note down the name that already exists
        errordlg('name Already exists');
    else   
        selection = questdlg(strcat('Save the Voice with name as :',per_name),...
            'Close Request Function',...
            'Yes','No','Yes'); 
        switch selection, 
            case 'Yes',
         
    
                if (length(signal)<10)|(length(mfcc_file)<2)
                 errordlg('Signal or Feature File to inject not sellected');
                else
                    set(handles.tx_msg,'String','Extracting MFCC Features');   
                    MFCC_feat_inject(signal,mfcc_file,per_name,matcher);
                    set(handles.tx_msg,'String','');   



                   set(handles.tx_msg,'String','Extracting SBC Features');  
                   SBC_feat_inject(signal,sbc_file,per_name,matcher);
  
                    set(handles.tx_msg,'ForegroundColor',[0 0 0],'String','Done');    

                end

             case 'No'
                return 
          end% end of switch
        
        end % end for if to check duplicate name 
else
errordlg('Enter Proper name');
     
end



% --- Executes on button press in bt_SBC.
function bt_SBC_Callback(hObject, eventdata, handles)
% hObject    handle to bt_SBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bt_SBC


% --- Executes on button press in rb_MFCC.
function rb_MFCC_Callback(hObject, eventdata, handles)
% hObject    handle to rb_MFCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_MFCC


% --- Executes on button press in bt_find.
function bt_find_Callback(hObject, eventdata, handles)
% hObject    handle to bt_find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mfcc_file
global sbc_file
global wav_file
global signal
global tmr
global feature_used
  global max_1
  global max_2
  global max_3
  global maxmfcc_hybrid
  global maxsbc_hybrid 
  global i_max_1
  global i_max_2
  global i_max_3
  global i_maxmfcc
  global i_maxsbc


if (length(signal)<10)|(length(mfcc_file)<2)
    errordlg('Signal or Feature File to test not sellected');
else
    
    if get(handles.ch_MFCC,'value')==1
        %match_v array contains the value of mathces with various features
    match_v= MFCC_feature_compare(signal,mfcc_file);
    load(mfcc_file);
    elseif get(handles.ch_SBC,'value')==1
     match_v=SBC_feature_compare(signal,sbc_file);
    load(sbc_file);
    elseif get(handles.ch_Hybrid,'value')==1
        matchmfcc_v= MFCC_feature_compare(signal,mfcc_file);
        matchsbc_v=SBC_feature_compare(signal,sbc_file);
    % finding out which is the closest match for the feature
       [maxmfcc_hybrid i_maxmfcc]=max(matchmfcc_v);
       [maxsbc_hybrid i_maxsbc]=max(matchsbc_v);
       if maxmfcc_hybrid>-6.8
       match_v= MFCC_feature_compare(signal,mfcc_file);
       load(mfcc_file);
       feature_used = 1;
       elseif maxsbc_hybrid>-21.5
       match_v=SBC_feature_compare(signal,sbc_file);
       load(sbc_file);
       feature_used = 2;
       else
       abs_diff_mfcc = (maxmfcc_hybrid * -1) - 6.8;
       abs_diff_mfcc = abs_diff_mfcc/6.8;
       abs_diff_sbc = (maxsbc_hybrid * -1) - 21.5;
       abs_diff_sbc = abs_diff_sbc/21.5;
            if abs_diff_mfcc < abs_diff_sbc
               match_v= MFCC_feature_compare(signal,mfcc_file);
               load(mfcc_file); 
               feature_used = 1;
            else
                if maxsbc_hybrid > -22
                match_v=SBC_feature_compare(signal,sbc_file);
                load(sbc_file);
                feature_used = 2;   
                else
                match_v= MFCC_feature_compare(signal,mfcc_file);
                load(mfcc_file); 
                feature_used = 1;                    
                end
            end       
      end  
 end 
 
   amax=-1000;
   

   
   [max_1 i_max_1]=max(match_v);    % Find the index of the person with closest match
   match_v(i_max_1)=[];             % Remove it to next value
   [max_2 i_max_2]=max(match_v);    % Find the index of the person with next closest match
   match_v(i_max_2)=[];             % Remove it to next value
   
   [max_3 i_max_3]=max(match_v);

            
   %Now Deside on the Quality     
   
    if get(handles.ch_MFCC,'value')==1
        %match_v array contains the value of mathces with various features
        if max_1>-9
            set(handles.tx_Quality,'string','PERFECT');
            set(handles.tx_result,'string',name(i_max_1,:),'visible','on');
        else
            set(handles.tx_Quality,'string','POOR');
            set(handles.tx_result,'string','UNKNOWN(REF DETAILS)','visible','on');
        end
    elseif get(handles.ch_SBC,'value')==1
        if max_1>-22
            set(handles.tx_Quality,'string','PERFECT');
            set(handles.tx_result,'string',name(i_max_1,:),'visible','on');
        else
            set(handles.tx_Quality,'string','POOR');
            set(handles.tx_result,'string','UNKNOWN(REF DETAILS)','visible','on');
        end
        
    elseif get(handles.ch_Hybrid,'value')==1
            if feature_used ==1 
            set(handles.tx_Algorithm_Used,'string','MFCC');            
                if (max_1>-9) & (max_1 <-2)  % this is to avoid noisy samples, the MFCC is not good at avoiding them
            set(handles.tx_Quality,'string','PERFECT');
            set(handles.tx_result,'string',name(i_max_1,:),'visible','on');
                else
            set(handles.tx_Quality,'string','POOR');
            set(handles.tx_result,'string','UNKNOWN(REF DETAILS)','visible','on');
                end
            else
            set(handles.tx_Algorithm_Used,'string','SBC');    
                if max_1>-23
            set(handles.tx_Quality,'string','PERFECT');
            set(handles.tx_result,'string',name(i_max_1,:),'visible','on');
                else
            set(handles.tx_Quality,'string','POOR');
            set(handles.tx_result,'string','UNKNOWN(REF DETAILS)','visible','on');
                end 
            end

    
        
  end 
 
   
            % Now showing the result
           
            
            set(handles.tx_person_is,'visible','on');
            set(handles.tx_Match_Quality,'visible','on');
            set(handles.tx_Algorithm,'visible','on');
            set(handles.tx_Algorithm_Used,'visible','on');
            set(handles.bt_Details,'visible','on');
             set(handles.tx_Quality,'Visible','on');
             
             
             if(no_of_fe<3)
                set(handles.bt_Details,'visible','off');
            end
       
end
% --------------------------------------------------------------------
















function plot_sig()
global signal
            samp_len = length(signal)/8000;
            delta_t = 1/8000;
            t = 0:delta_t:(samp_len-delta_t);

            % display the signal
            plot(t,signal), xlabel('Time [sec]'), ylabel('Amplitude')
            axis([0 t(length(signal)-1) -1 1 ]);

            


% --- Executes on button press in ch_SBC.
function ch_SBC_Callback(hObject, eventdata, handles)
% hObject    handle to ch_SBC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%un check other Feature parameter
if get(handles.ch_SBC,'value')==1;
    set(handles.ch_MFCC,'value',0);
    set(handles.ch_Hybrid,'value',0);
else
    % Do nothing now
    %set(handles.ch_MFCC,'value',1); 
end

% --- Executes on button press in ch_MFCC.
function ch_MFCC_Callback(hObject, eventdata, handles)
% hObject    handle to ch_MFCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%un check other Feature parameter
if get(handles.ch_MFCC,'value')==1;
    set(handles.ch_SBC,'value',0);
    set(handles.ch_Hybrid,'value',0); 
else
    % Do nothing now
    %set(handles.ch_SBC,'value',1); 
end

% Hint: get(hObject,'Value') returns toggle state of ch_MFCC



% --- Executes on button press in ch_MFCC.
function ch_Hybrid_Callback(hObject, eventdata, handles)
% hObject    handle to ch_Hybrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%un check other Feature parameter
if get(handles.ch_Hybrid,'value')==1;
    set(handles.ch_MFCC,'value',0);
    set(handles.ch_SBC,'value',0); 
else
    % Do nothing now
    %set(handles.ch_SBC,'value',1); 
end




% --- Executes on button press in bt_play.
function bt_play_Callback(hObject, eventdata, handles)

global signal
% hObject    handle to bt_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(signal) ~= 0
      wavplay(signal,8000)
end


% --- Executes during object creation, after setting all properties.
function tx_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_name_Callback(hObject, eventdata, handles)
% hObject    handle to tx_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_name as text
%        str2double(get(hObject,'String')) returns contents of tx_name as a double




% --------------------------------------------------------------------
function fresh_database_Callback(hObject, eventdata, handles)
% hObject    handle to fresh_database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mfcc_file
global sbc_file
no_of_fe=0;
 
 save('MFCC_feature.mat','no_of_fe');
 save('SBC_feature.mat','no_of_fe');
 
 
 sbc_file='SBC_feature.mat';
 mfcc_file='mfcc_feature.mat';
 save('config.mat','mfcc_file','sbc_file');
 msgbox('feature files MFCC_features and SBC_feature and config.mat created');
 
 load('config.mat');
set(handles.tx_mfcc_file_name,'ForegroundColor',[0 0 0],'String',mfcc_file); 
set(handles.tx_sbc_file_name,'ForegroundColor',[0 0 0],'String',sbc_file);


% --------------------------------------------------------------------
function m_DataBase_Callback(hObject, eventdata, handles)
% hObject    handle to m_DataBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
db_manage;



% --------------------------------------------------------------------
function m_About_Callback(hObject, eventdata, handles)
% hObject    handle to m_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

About();


% --- Executes on button press in bt_Details.
function bt_Details_Callback(hObject, eventdata, handles)
% hObject    handle to bt_Details (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mfcc_file
global sbc_file
global wav_file
global signal
global tmr
  global max_1
  global max_2
  global max_3
  global i_max_1
  global i_max_2
  global i_max_3


    if get(handles.ch_MFCC,'value')==1
        %match_v array contains the value of mathces with various features
        load(mfcc_file);
    else
        load(sbc_file);
    end 
    
result( name(i_max_1,:),max_1,name(i_max_2,:),max_2,name(i_max_3,:),max_3);



