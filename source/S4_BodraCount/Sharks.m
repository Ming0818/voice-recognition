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

% Last Modified by GUIDE v2.5 18-Nov-2011 02:41:27

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
  global maxborda
  global i_max_1
  global i_max_2
  global i_max_3
  global i_maxmfcc
  global i_maxmfcc1
  global i_maxmfcc2
  global i_maxmfcc3
  global i_maxmfcc4
  global i_maxmfcc5
  global i_maxmfcc6
  global i_maxmfcc7
  global i_maxsbc
  global i_maxsbc1
  global i_maxsbc2
  global i_maxsbc3
  global i_maxsbc4
  global i_maxsbc5
  global i_maxsbc6
  global i_maxsbc7
  global i_maxborda


if (length(signal)<10)|(length(mfcc_file)<2)
    errordlg('Signal or Feature File to test not sellected');
else
    
    if get(handles.ch_MFCC,'value')==1
        %match_v array contains the value of mathces with various features
    match_v= MFCC_feature_compare(signal,mfcc_file);
    load(mfcc_file);
    feature_used = 1;
    elseif get(handles.ch_SBC,'value')==1
    match_v=SBC_feature_compare(signal,sbc_file);
    load(sbc_file);
    feature_used = 2;
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
      
   elseif get(handles.ch_BordaCount,'value')==1
   matchmfcc_v= MFCC_feature_compare(signal,mfcc_file);
   matchsbc_v=SBC_feature_compare(signal,sbc_file);
   % finding out which is the closest match for the feature
       [maxmfcc_hybrid i_maxmfcc1]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc1)= -1000;             % Remove it to next value
       [maxmfcc_hybrid i_maxmfcc2]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc2)= -1000;             % Remove it to next value
       [maxmfcc_hybrid i_maxmfcc3]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc3)= -1000;             % Remove it to next value
       [maxmfcc_hybrid i_maxmfcc4]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc4)= -1000;             % Remove it to next value
       [maxmfcc_hybrid i_maxmfcc5]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc5)= -1000;             % Remove it to next value
       [maxmfcc_hybrid i_maxmfcc6]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc6)= -1000;             % Remove it to next value
       [maxmfcc_hybrid i_maxmfcc7]=max(matchmfcc_v);
       matchmfcc_v(i_maxmfcc7)= -1000;             % Remove it to next value
       
       rankmfcc = [i_maxmfcc1,i_maxmfcc2,i_maxmfcc3,i_maxmfcc4,i_maxmfcc5,i_maxmfcc6,i_maxmfcc7];
       rankmfcc
       actualrankmfcc(i_maxmfcc1) = 7;
       actualrankmfcc(i_maxmfcc2) = 6;
       actualrankmfcc(i_maxmfcc3) = 5;
       actualrankmfcc(i_maxmfcc4) = 4;
       actualrankmfcc(i_maxmfcc5) = 3;
       actualrankmfcc(i_maxmfcc6) = 2;
       actualrankmfcc(i_maxmfcc7) = 1;
       
       actualrankmfcc
       
       [maxsbc_hybrid i_maxsbc1]=max(matchsbc_v);
       matchsbc_v(i_maxsbc1)=-1000;             % Remove it to next value
        [maxsbc_hybrid i_maxsbc2]=max(matchsbc_v);
       matchsbc_v(i_maxsbc2)=-1000;             % Remove it to next value
        [maxsbc_hybrid i_maxsbc3]=max(matchsbc_v);
       matchsbc_v(i_maxsbc3)=-1000;             % Remove it to next value
        [maxsbc_hybrid i_maxsbc4]=max(matchsbc_v);
       matchsbc_v(i_maxsbc4)=-1000;             % Remove it to next value
        [maxsbc_hybrid i_maxsbc5]=max(matchsbc_v);
       matchsbc_v(i_maxsbc5)=-1000;             % Remove it to next value
        [maxsbc_hybrid i_maxsbc6]=max(matchsbc_v);
       matchsbc_v(i_maxsbc6)=-1000;             % Remove it to next value
       [maxsbc_hybrid i_maxsbc7]=max(matchsbc_v);
       matchsbc_v(i_maxsbc7)=-1000;             % Remove it to next value
       
       ranksbc = [i_maxsbc1,i_maxsbc2,i_maxsbc3,i_maxsbc4,i_maxsbc5,i_maxsbc6,i_maxsbc7];
       ranksbc
       actualranksbc(i_maxsbc1) = 7;
       actualranksbc(i_maxsbc2) = 6;
       actualranksbc(i_maxsbc3) = 5;
       actualranksbc(i_maxsbc4) = 4;
       actualranksbc(i_maxsbc5) = 3;
       actualranksbc(i_maxsbc6) = 2;
       actualranksbc(i_maxsbc7) = 1;
       
       actualranksbc
       
       TotalRank = [actualrankmfcc(1)+actualranksbc(1),actualrankmfcc(2)+actualranksbc(2),actualrankmfcc(3)+actualranksbc(3),actualrankmfcc(4)+actualranksbc(4),actualrankmfcc(5)+actualranksbc(5),actualrankmfcc(6)+actualranksbc(6),actualrankmfcc(7)+actualranksbc(7)]
       match_v = TotalRank;
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
                if max_1>-8
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
elseif get(handles.ch_BordaCount,'value')==1
            load(mfcc_file);
            matchmfcc_v= MFCC_feature_compare(signal,mfcc_file);
            matchsbc_v=SBC_feature_compare(signal,sbc_file);
            if( max(matchmfcc_v) <-8 || max(matchsbc_v)<-23)
              set(handles.tx_Quality,'string','POOR');
            set(handles.tx_result,'string','UNKNOWN(REF DETAILS)','visible','on');  
                
            
    else
            set(handles.tx_Quality,'string','PERFECT');
            set(handles.tx_result,'string',name(i_max_1,:),'visible','on');
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
  global feature_used


    if get(handles.ch_MFCC,'value')==1 || feature_used == 1
        %match_v array contains the value of mathces with various features
        load(mfcc_file);
    else
        load(sbc_file);
    end 
    
result( name(i_max_1,:),max_1,name(i_max_2,:),max_2,name(i_max_3,:),max_3);





% --- Executes on button press in ch_BordaCount.
function ch_BordaCount_Callback(hObject, eventdata, handles)
% hObject    handle to ch_BordaCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_BordaCount
