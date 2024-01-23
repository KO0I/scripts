addpath( '/usr/share/openEMS/matlab');
addpath( '/home/patrick/build/csxcad-git/pkg/csxcad-git/share/CSXCAD/matlab');
addpath( '/usr/share/jjAppCSXCAD');
InitCSX
InitFDTD('NrTS', 0, 'EndCriteria',0)
RunOpenEMS( '.', 'nonexistant.xml', '' )
