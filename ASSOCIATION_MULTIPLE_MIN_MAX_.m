function varargout = ASSOCIATION_MULTIPLE_MIN_MAX(varargin)
% ASSOCIATION_MULTIPLE_MIN_MAX M-file for ASSOCIATION_MULTIPLE_MIN_MAX.fig
%      ASSOCIATION_MULTIPLE_MIN_MAX, by itself, creates a new ASSOCIATION_MULTIPLE_MIN_MAX or raises the existing
%      singleton*.
%
%      H = ASSOCIATION_MULTIPLE_MIN_MAX returns the handle to a new ASSOCIATION_MULTIPLE_MIN_MAX or the handle to
%      the existing singleton*.
%
%      ASSOCIATION_MULTIPLE_MIN_MAX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSOCIATION_MULTIPLE_MIN_MAX.M with the given input arguments.
%
%      ASSOCIATION_MULTIPLE_MIN_MAX('Property','Value',...) creates a new ASSOCIATION_MULTIPLE_MIN_MAX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ASSOCIATION_MULTIPLE_MIN_MAX_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ASSOCIATION_MULTIPLE_MIN_MAX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ASSOCIATION_MULTIPLE_MIN_MAX

% Last Modified by GUIDE v2.5 19-Feb-2013 15:46:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ASSOCIATION_MULTIPLE_MIN_MAX_OpeningFcn, ...
                   'gui_OutputFcn',  @ASSOCIATION_MULTIPLE_MIN_MAX_OutputFcn, ...
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


% --- Executes just before ASSOCIATION_MULTIPLE_MIN_MAX is made visible.
function ASSOCIATION_MULTIPLE_MIN_MAX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ASSOCIATION_MULTIPLE_MIN_MAX (see VARARGIN)

% Choose default command line output for ASSOCIATION_MULTIPLE_MIN_MAX
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ASSOCIATION_MULTIPLE_MIN_MAX wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ASSOCIATION_MULTIPLE_MIN_MAX_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
clc; 
a = uiimport();
dataset = a.dataset;
dataset = dataset(6,5);
PrintTransactions(dataset);
tic
a1 = get(handles.e1,'String');
t2=str2double(a)
a = get(handles.e1,'String');
t1=str2double(a)
min_sup = handles.metricdata.edit1;
set(handles.edit1, 'String', min_sup);
min_conf = handles.metricdata.edit2;
set(handles.edit2, 'String', min_conf);
[m,n]=size(dataset);
Apriori{1}=orar1(A,t1,m,n);
Apriori{2}=orar2(A,t2,m,n,Apriori{1});
for maink=3:n
if(Apriori{maink-1}==0)
break;
end
Apriori{maink}=transaction(A,t,m,n,Apriori{1},Apriori{maink-1});
end
function Apriorik=transaction(A,t,m,n,Apriori1,Apriorik0)
[mApriorik0 nApriorik0]=size(Apriorik0);
[m1,n1]=size(Apriori1);
labelk=0;
for j=1:mApriorik0

for i=1:n1
ki=Apriori1(i);
flag=0;
for k=1:nApriorik0
    if(ki==Apriorik0(j,k))
        flag=1;
        break;
    end
end
if(flag==1)
    continue;
else
    f=0;
    f=sum(A(:,ki)&A(:,Apriorik0(j,nApriorik0)));
    f=f/m;
    if(f>=t)
            C=[Apriorik0(j,:),ki];
            C=sort(C);
            if(labelk==0)
                labelk=labelk+1;
                Ck{labelk}=C;
            else
                repeatlabel=0;
                for rep=1:labelk
                    digtal=C==Ck{rep};
                    find0=find(digtal==0);
                    findrepeat=sum(find0);
                    if(findrepeat==0)
                        repeatlabel=1;break;
                    end
                end                            
                if(repeatlabel==0)
                    labelk=labelk+1;
                    Ck{labelk}=C;
                end
            end
    end
end         
end
end
if(labelk~=0)
relationk=0;
for j=1:labelk
S{j}=A(:,Ck{j}(1));
for i=2:nApriorik0+1
    S{j}=S{j}(:)&A(:,Ck{j}(i));
end
f(j)=sum(S{j});
f(j)=f(j)/m;
if(f(j)>=t)
    relationk=relationk+1;
    relation{relationk}=Ck{j};
end
end
label3=0;
for j=1:relationk
    label3=label3+1;
    Apriorik(label3,:)=relation{j}(:);
end
if(label3==0)
Apriorik=0;
end
else
Apriorik=0;
end
function Apriori2=orar2(A,t,m,n,Apriori1)
[mApriori1 nApriori1]=size(Apriori1);
label=1;
for i=1:nApriori1-1
for j=i+1:nApriori1
f=0;
f=sum(A(:,Apriori1(i))&A(:,Apriori1(j)));
f=f/m;
if(f>=t)
    Apriori2(label,1)=Apriori1(i);
    Apriori2(label,2)=Apriori1(j);
    label=label+1;
end
end
end

if(label==1)
Apriori2=0;
end      
function sup = FindSup(item, L, supports)

for i=1:size(L,1)
l = nonzeros(L(i,:));
if(isequal(l', item))
sup = supports(i);
end
end
function a = func(b)
if (b < 2) 
a = 1;
else
a = b*func(b-1);
end

function pattern(L, supports)
fprintf('  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n');
fprintf(' ++++++++++++++++++++++++++++Frequent Item with Frequency+++++++++++\n');
fprintf('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
for i =1:size(L,1)
fprintf('                ');
items = nonzeros(L(i,:));
for j=1:size(items,1)
fprintf('%d', L(i, j));
if(j == size(items,1))
   fprintf(' Frequency support ');
else
   fprintf(', '); 
end           
end
fprintf('%d\n', supports(i));
end
fprintf('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n\n');
function PrintRules(rules_left, rules_right)

fprintf('*******************************************************************\n');
fprintf('*******************---Minine Valied  Rule---**************************\n');
fprintf('*******************************************************************\n');
for i =1:size(rules_left,1)
    fprintf('                      ');
    items = nonzeros(rules_left(i,:));
    for j=1:size(items,1)
       fprintf('%d', rules_left(i, j));
       if(j == size(items,1))
           fprintf(' ==> ');
       else
           fprintf(', '); 
       end           
    end
 
    items = nonzeros(rules_right(i,:));
    for j=1:size(items,1)
       fprintf('%d', rules_right(i, j));
       if(j == size(items,1))
           fprintf('\n');
       else
           fprintf(', '); 
       end           
    end
end

fprintf('***********************************************************************\n');
function PrintTransactions(dataset)

fprintf('***********************************************************************\n');
fprintf('*************************---Data table---***********************\n');
fprintf('***********************************************************************\n');
for i =1:size(dataset,1)
    fprintf('                ');
    items = nonzeros(dataset(i,:));
    for j=1:size(items,1)
       fprintf('%d', dataset(i, j));
       if(j == size(items,1))
           fprintf('                                       \n');
       else
           fprintf(', '); 
       end           
    end    
end

fprintf('********************************************************************\n\n\n');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
msgbox ('Thank You Verymuch.....');
close all;
msgbox ('Designed By :- Shailesh Thakare.....');
fprintf ('\nDesigned By :- Sunshine Developers\n');

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
edit4 = str2double(get(hObject, 'String'));
if isnan(edit4)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer number ');
end
handles.metricdata.edit4 = edit4;
guidata(hObject,handles)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
edit2 = str2double(get(hObject, 'String'));
if isnan(edit2)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer number ');
end
handles.metricdata.edit2 = edit2;
guidata(hObject,handles)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
a = uiimport();
dataset = a.dataset;
PrintTransactions(dataset);
a = get(handles.e1,'String');
t1=str2double(a)
a1 = get(handles.e2,'String');
t2=str2double(a)
min_sup = handles.metricdata.edit1;
set(handles.edit1, 'String', min_sup);
min_conf = handles.metricdata.edit2;
set(handles.edit2, 'String', min_conf);
ft1nction [d, pre, post, cycle, f, pred] = dfs(min_st1pp, start, min_confi)
n = length(dataset);
d = zeros(1,n);
f = zeros(1,n);
pred = zeros(1,n);
pre = [];
post = [];
if ~isempty(start)
trans_set(start, min_st1pp, min_confi);
end
ft1nction Tree(t1, min_st1pp, min_confi)
pre = [pre t1];
min(t1) = gray;
time_stamp = time_stamp + 1;
d(t1) = time_stamp;
if min_confi
ns = children(min_st1pp, t1);
else
ns = neighbors(min_st1pp, t1);
ns = setdiff(ns, pred(t1)); 
end
for t2=ns(:)'
switch min(t2)
case white, 
pred(t2)=t1;
dfs_t2isit(t2, min_st1pp, min_confi);
case min 
cycle = 1;
case Max, 
end
end
min(t1) = Max;
post = [post t1];
time_stamp = time_stamp + 1;
f(t1) = time_stamp;
toc

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
edit1 = str2double(get(hObject, 'String'));
if isnan(edit1)
    set(hObject, 'String', 0);
    errordlg('Input must be an integer number ');
end
handles.metricdata.edit1 = edit1;
guidata(hObject,handles)


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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
a = uiimport();
dataset = a.dataset;
a = get(handles.e1,'String');
t1=str2double(a)
a1 = get(handles.e1,'String');
t2=str2double(a);
min_sup = handles.metricdata.edit1;
set(handles.edit1, 'String', min_sup);
min_conf = handles.metricdata.edit2;
set(handles.edit2, 'String', min_conf);
sinc = min_max(t1,t2)
if n~=round(dataset)
sinc = 0;
return
end
if n<0
sinc = 0;
return
end
sinc=1;
i=0;
for i=0:n+1
i = n+1;
addterm = ((-1)^i)*(x^(2*i))/factorial(2*i);
sinc = sinc + addterm;
end

toc
function rules = genMultiCand(file_data,new_candidates,max_length,min_support)
temp_cand=[1];
i = 2;
rules{1} = 0;
while (~isempty(temp_cand) & i ~= max_length)
for i=3:max_length
cand_length = size(new_candidates,1);
next_elem = 1;
temp_cand = [];
for j=1:(cand_length - 1)
for k=(j+1):cand_length
match = 0;
for l=1:(i-1)
for m=1:(i-1)
if new_candidates(j,l) == new_candidates(k,m)
match = match+1;
if match == (i-2)
possible_candidates = union(new_candidates(j,:),new_candidates(k,:));
  if size(possible_candidates,2) == i
temp_cand(next_elem,:) = union(new_candidates(j,:),new_candidates(k,:));  
 temp_cand(next_elem,:)=sort(temp_cand(next_elem,:));
next_elem = next_elem + 1;
end
m=(i-l); 
l=(i-1); 
end 
end
end
end
end
end
if ~isempty(temp_cand) 
temp_cand = unique(temp_cand,'rows'); 
new_candidates = temp_cand;
clear count;
new_instance = 0;
for z = 1:size(new_candidates,1)
count(z) = countInstance(new_candidates(z,:),file_data);
if count(z) >= min_support
new_instance = 1;
end
end
if new_instance == 0
return
else
rules{(i-2)} = removeRules(new_candidates,min_support,count,i);
clear new_candidates;
new_candidates = rules{i-2}(:,1:i);
end
else
return
end 
end
end
function e1_Callback(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e1 as text
%        str2double(get(hObject,'String')) returns contents of e1 as a double


% --- Executes during object creation, after setting all properties.
function e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
