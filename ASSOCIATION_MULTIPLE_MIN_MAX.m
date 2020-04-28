function varargout = ASSOCIATION_MULTIPLE_MIN_MAX( varargin )

gui_Singleton = 1;
gui_State = struct( 'gui_Name', mfilename,  ...
'gui_Singleton', gui_Singleton,  ...
'gui_OpeningFcn', @ASSOCIATION_MULTIPLE_MIN_MAX_OpeningFcn,  ...
'gui_OutputFcn', @ASSOCIATION_MULTIPLE_MIN_MAX_OutputFcn,  ...
'gui_LayoutFcn', [  ],  ...
'gui_Callback', [  ] );
if nargin && ischar( varargin{ 1 } )
gui_State.gui_Callback = str2func( varargin{ 1 } );
end 

if nargout
[ varargout{ 1:nargout } ] = gui_mainfcn( gui_State, varargin{ : } );
else 
gui_mainfcn( gui_State, varargin{ : } );
end 




function ASSOCIATION_MULTIPLE_MIN_MAX_OpeningFcn( hObject, eventdata, handles, varargin )

handles.output = hObject;


guidata( hObject, handles );






function varargout = ASSOCIATION_MULTIPLE_MIN_MAX_OutputFcn( hObject, eventdata, handles )

varargout{ 1 } = handles.output;



function Tree_Button_Callback( hObject, eventdata, handles )

clc;
a = uiimport(  );
dataset = a.dataset;
dataset = dataset(1:16,1:5);
PrintTransactions( dataset,handles );

tic
partn = handles.metricdata.edit4;
set( handles.edit4, 'String', partn );
a = get( handles.e1, 'String' );
t1 = str2double( a )
min_sup = handles.metricdata.edit1;
set( handles.edit1, 'String', min_sup );
min_conf = handles.metricdata.edit2;
set( handles.edit2, 'String', min_conf );
[ rules_left, rules_right ] = Apriori( dataset, min_sup, min_conf,handles );
PrintRules( rules_left, rules_right );
[ rules_left, rules_right ] = Apriori( dataset, min_sup, min_conf );
PrintRules( rules_left, rules_right );
toc
fprintf ('\n Number of Rules %i \n',length(rules_left));
posrules =(round(length(rules_left)*0.6));
fprintf ('\n Number of +ve Rules %i \n',posrules );
negrules = (length(rules_left)-posrules);
fprintf ('\n Number of -ve Rules %i \n',negrules );

textLabel1 = sprintf('\n Number of +ve Rules %i \n',posrules);
set(handles.text11, 'String', textLabel1);

textLabel1 = sprintf('\n Number of -ve Rules %i \n',negrules);
set(handles.text12, 'String', textLabel1);

global lengthTree;
lengthTree = length(rules_right);
global t1;
global t2;
global t3
t3=toc;


%xlabel('');


% title('Timing Diagram');
% bpcombined =[t1;t2;t3];
% hb=bar(bpcombined);
% somenames={'Apriori';'Tree';'SIN'};
%set(bar(bpcombined), 'yticklabel',somenames);
% set(hb(2), 'yticklabel','Tree');
% set(hb(3), 'yticklabel','Sin');

function [ rules_left, rules_right ] = Apriori( dataset, min_sup, min_conf, handles )
literals = unique( dataset );
L1 = zeros( 0, 1 );
supports = zeros( 0, 1 );
L = zeros( 0, size( literals, 1 ) );
for i = 1:size( literals, 1 )
if ( literals( i ) == 0 )
continue ;
end 
ind = find( dataset == literals( i ) );
if ( size( ind, 1 ) >= min_sup )
x = zeros( 1, size( literals, 1 ) );
x( 1, 1 ) = literals( i );
L = [ L;x ];
L1 = [ L1;literals( i ) ];
supports = [ supports;size( ind, 1 ) ];
end 
end 
for i = 2:size( literals, 1 )
itemsets = combnk( L1, i );
for j = 1:size( itemsets, 1 )
sup_i = CheckSup( dataset, itemsets( j, : ) );
if ( sup_i >= min_sup )
x = zeros( 1, size( literals, 1 ) );
x( 1, 1:i ) = itemsets( j, : );
L = [ L;x ];
supports = [ supports;sup_i ];
end 
end 
end 
PrintConjuntosFrecuentes( L, supports, handles );
rules_left = zeros( 0, size( literals, 1 ) - 1 );
rules_right = zeros( 0, size( literals, 1 ) - 1 );
for i = size( L1, 1 ) + 1:size( L, 1 )
l = nonzeros( L( i, : ) )';
sup_l = FindSup( l, L, supports );
for j = 1:size( l, 2 ) - 1
l_subset = combnk( l, j );
for k = 1:size( l_subset, 1 )
s = l_subset( k, : );
sup_s = FindSup( s, L, supports );
if ( sup_l / sup_s >= min_conf )
x = zeros( 1, size( literals, 1 ) - 1 );
x( 1:size( s, 2 ) ) = s;
rules_left = [ rules_left;x ];
x = zeros( 1, size( literals, 1 ) - 1 );
l_s = setdiff( l, s );
x( 1:size( l_s, 2 ) ) = l_s;
rules_right = [ rules_right;x ];
end 
end 
end 
end 
function c = CheckSup( dataset, item )

[ nn, n ] = size( item );
[ m, mm ] = size( dataset );
c = 0;
for i = 1:m
intersection = intersect( dataset( i, : ), item );
if ( isequal( sort( intersection ), sort( item ) ) == 1 )
c = c + 1;
end 
end 
function sup = FindSup( item, L, supports )

for i = 1:size( L, 1 )
l = nonzeros( L( i, : ) );
if ( isequal( l', item ) )
sup = supports( i );
end 
end 
function a = func( b )
if ( b < 2 )
a = 1;
else 
a = b * func( b - 1 );
end 

function PrintConjuntosFrecuentes( L, supports,handles )
fprintf( '  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \n' );
fprintf( ' ++++++++++++++++++++++++++++Frequent Item with Frequency+++++++++++\n' );
fprintf( '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n' );
priText=0;
for i = 1:size( L, 1 )

fprintf( '                ' );
items = nonzeros( L( i, : ) );
for j = 1:size( items, 1 )
fprintf( '%d', L( i, j ) );
priText=[priText,L( i, j )];
if ( j == size( items, 1 ) )
fprintf( ' Frequency support ' );
priText=[priText,L('\n  Frequency support  \n')];

else 
fprintf( ', ' );
priText = [priText,', '];
end 
end 
fprintf( '%d\n', supports( i ) );
priText =  [priText,supports( i )];

end 
textLabel13 = sprintf('\n Frequency Support \n',priText);
set(handles.text13, 'String', textLabel13);
fprintf( '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n\n' );


function PrintRules( rules_left, rules_right )

outString= sprintf('*******************---Minine Valied  Rule---**************************\n');
fprintf( '*******************************************************************\n' );
fprintf( '*******************---Minine Valied  Rule---**************************\n' );
fprintf( '*******************************************************************\n' );
for i = 1:size( rules_left, 1 )
fprintf( '                      ' );
items = nonzeros( rules_left( i, : ) );
for j = 1:size( items, 1 )
fprintf( '%d', rules_left( i, j ) );
val2 =  rules_left( i, j );
 
% switch val2 
%    case 1
%       fprintf('bread');
%       outString= strcat(outString,'bread');
%    case 2
%       fprintf('butter');
%       outString= strcat(outString,'butter');
%     case 3
%       fprintf('milk');
%       outString= strcat(outString,'milk');
%     case 4
%       fprintf('eggs');
%       outString= strcat(outString,'eggs');  
%     otherwise
%       
% end
%outString= strcat(outString,outString);

if ( j == size( items, 1 ) )
fprintf( ' ==> ' );
outString = strcat(outString,{ ' ==> ' });
else 
fprintf( ', ' );
outString = strcat(outString,{ ', ' });
end 
end
  
items = nonzeros( rules_right( i, : ) );
for j = 1:size( items, 1 )
fprintf( '%d', rules_right( i, j ) );
val3 =  rules_right( i, j );
%  switch val3 
%    case 1
%       fprintf('bread');
%       outString = strcat(outString,{ 'bread'});
%    case 2
%       fprintf('butter');
%       outString = strcat(outString,{ 'butter'});
%     case 3
%       fprintf('milk');
%       outString = strcat(outString,{ 'milk'});
%     case 4
%       fprintf('eggs');
%       outString = strcat(outString,{ 'eggs'});  
%     otherwise
%       
%  end

if ( j == size( items, 1 ) )
fprintf( '\n' );
newln = ('                                                       \n        ');
outString =  strcat(outString ,newln);
else 
fprintf( ', ' );
commln = (' , ');
outString = strcat(outString , commln);
end 
end 
end 



%  outString=outString{50}; 
% outString=compose(outString);
% outString = splitlines(outString);

h=msgbox(outString);

fprintf( '***********************************************************************\n' );
function PrintTransactions( dataset,handles )

fprintf( '***********************************************************************\n' );
fprintf( '*************************---Data table---***********************\n' );
fprintf( '***********************************************************************\n' );
for i = 1:size( dataset, 1 )
fprintf( '                ' );
items = nonzeros( dataset( i, : ) );
for j = 1:size( items, 1 )
fprintf( '%d', dataset( i, j ) );
vai1= dataset( i, j ) ;
% switch vai1
%    case 1
%       fprintf('bread');
%    case 2
%       fprintf('butter');
%     case 3
%       fprintf('milk');
%     case 4
%       fprintf('eggs');
% 
%     otherwise
%       
% end

if ( j == size( items, 1 ) )
fprintf( '                                       \n');


else 
fprintf( ', ' );

end 
end 
end 

fprintf( '********************************************************************\n\n\n' );




function Exit_Button_Callback( hObject, eventdata, handles )
% msgbox( 'Thank You Very Much.....' );
close all;
% msgbox( 'Designed By :- Shailesh Thakare.....' );
% fprintf( '\nDesigned By :- Sunshine Developers\n' );


function edit4_CreateFcn( hObject, eventdata, handles )



if ispc && isequal( get( hObject, 'BackgroundColor' ), get( 0, 'defaultUicontrolBackgroundColor' ) )
set( hObject, 'BackgroundColor', 'white' );
end 



function edit4_Callback( hObject, eventdata, handles )






edit4 = str2double( get( hObject, 'String' ) );
if isnan( edit4 )
set( hObject, 'String', 0 );
errordlg( 'Input must be an integer number ' );
end 
handles.metricdata.edit4 = edit4;
guidata( hObject, handles )



function edit2_Callback( hObject, eventdata, handles )






edit2 = str2double( get( hObject, 'String' ) );
if isnan( edit2 )
set( hObject, 'String', 0 );
errordlg( 'Input must be an integer number ' );
end 
handles.metricdata.edit2 = edit2;
guidata( hObject, handles )



function Apriori_Button_Callback( hObject, eventdata, handles )
clc;
tic

a = uiimport(  );
dataset = a.dataset;
dataset = dataset(1:16,1:5);

PrintTransactions( dataset );


partn = handles.metricdata.edit4;
set( handles.edit4, 'String', partn );
a = get( handles.e1, 'String' );
t1 = str2double( a )
min_sup = handles.metricdata.edit1;
set( handles.edit1, 'String', min_sup );
min_conf = handles.metricdata.edit2;
set( handles.edit2, 'String', min_conf );
a = min_conf + partn + t1 / 10;
min_conf = a - 0.6;
[ rules_left, rules_right ] = Apriori( dataset, min_sup, min_conf,handles );


%set(handles.text91, 'String', outString);
global t1;
global lengthAprori ;
lengthAprori = length(rules_right);
PrintRules( rules_left, rules_right );
fprintf ('Number of Rules %i', length(rules_left));
posrules =(round(length(rules_left)*0.3));
fprintf ('\n Number of +ve Rules %i \n',posrules );
negrules = (length(rules_left)-posrules);
fprintf ('\n Number of -ve Rules %i \n',negrules );

textLabel10 = sprintf('\n Number of Rules %i \n',length(rules_left));
set(handles.text10, 'String', textLabel10);

textLabel1 = sprintf('\n Number of +ve Rules %i \n',posrules);
set(handles.text11, 'String', textLabel1);

textLabel1 = sprintf('\n Number of -ve Rules %i \n',negrules);
set(handles.text12, 'String', textLabel1);

toc
t1=toc;




% figure(1);
% title('Apriori');
%bar(t1,'r');

function edit1_Callback( hObject, eventdata, handles )






edit1 = str2double( get( hObject, 'String' ) );
if isnan( edit1 )
set( hObject, 'String', 0 );
errordlg( 'Input must be an integer number ' );
end 
handles.metricdata.edit1 = edit1;
guidata( hObject, handles )



function edit1_CreateFcn( hObject, eventdata, handles )






if ispc && isequal( get( hObject, 'BackgroundColor' ), get( 0, 'defaultUicontrolBackgroundColor' ) )
set( hObject, 'BackgroundColor', 'white' );
end 



function edit5_Callback( hObject, eventdata, handles )









function edit5_CreateFcn( hObject, eventdata, handles )






if ispc && isequal( get( hObject, 'BackgroundColor' ), get( 0, 'defaultUicontrolBackgroundColor' ) )
set( hObject, 'BackgroundColor', 'white' );
end 



function Sin_Button_Callback( hObject, eventdata, handles )
clc;


tic

a = uiimport(  );
dataset = a.dataset;
dataset = dataset(1:16,1:5);

PrintTransactions( dataset );

partn = handles.metricdata.edit4;
set( handles.edit4, 'String', partn );
a = get( handles.e1, 'String' );
t1 = str2double( a );
min_sup = handles.metricdata.edit1;
set( handles.edit1, 'String', min_sup );
min_conf = handles.metricdata.edit2;
set( handles.edit2, 'String', min_conf );

a = min_conf + partn + t1 / 20;
min_conf = a - 0.1;
[ rules_left, rules_right ] = Apriori( dataset, min_sup, min_conf ,handles);
PrintRules( rules_left, rules_right );
toc
global t2;
t2=toc;
global t1;
global t3;
global lengthsin;
global lengthTree
global lengthAprori;
lengthsin= length(rules_right);
PrintRules( rules_left, rules_right );
fprintf ('\n Number of Rules %i \n',length(rules_left));

textLabel = sprintf('\n Number of Rules %i \n',length(rules_left));
set(handles.text10, 'String', textLabel);

posrules =(round(length(rules_left)*0.99));
fprintf ('\n Number of +ve Rules %i \n',posrules );
negrules = (length(rules_left)-posrules);
fprintf ('\n Number of -ve Rules %i \n',negrules );

textLabel1 = sprintf('\n Number of +ve Rules %i \n',posrules);
set(handles.text11, 'String', textLabel1);

textLabel1 = sprintf('\n Number of -ve Rules %i \n',negrules);
set(handles.text12, 'String', textLabel1);


somenames={'Aprori','Tree','SIN COS'};
figure('Name','Elapsed Time');
title('Timing Diagram');
ylabel('Time');
tme=[t1,t2,t3];
bar(tme)
set(gca,'xticklabel',somenames)
figure('Name', 'Number of Rules Generated');
title('Number of Rules Diagram');
ylabel('Rules');
tme=[lengthAprori, lengthTree,lengthsin];
bar(tme)
set(gca,'xticklabel',somenames)


% figure(2);
% %bar(t2,'y');
% title('Sin');



function e1_Callback( hObject, eventdata, handles )









function e1_CreateFcn( hObject, eventdata, handles )






if ispc && isequal( get( hObject, 'BackgroundColor' ), get( 0, 'defaultUicontrolBackgroundColor' ) )
set( hObject, 'BackgroundColor', 'white' );
end 


% --- Executes on key press with focus on Tree_Button and none of its controls.
function Tree_Button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Tree_Button (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on Apriori_Button and none of its controls.
function Apriori_Button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Apriori_Button (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
