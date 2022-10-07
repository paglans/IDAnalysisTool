#pragma rtGlobals=1		// Use modern global access method.
#pragma IgorVersion=6.10
#pragma Version=1.0

Function/S GetSpectraList(subfolder)
	DFREF subfolder
	String spectralist="", tmpwlist="",tmpflist="",fname,runname
	Variable fcounter,subfolders,spectra,scounter,level
	subfolders=CountObjectsDFR(subfolder,4)
	spectra=CountObjectsDFR(subfolder,1)
	fcounter=0
	scounter=0
	fname=GetDataFolder(1,subfolder)
	runname=fname
	spectralist=ListWaves(fname)
	if(subfolders==0)
		//break
	else
		do
			if(fcounter>=subfolders)
				break
			endif
			fname=runname+GetIndexedObjNameDFR(subfolder,4,fcounter)
			tmpwlist=ListWaves(fname)
		//	spectralist+=tmpwlist
			tmpflist=ListFolders(fname)
			Variable subfoldersLevel2=ItemsInList(tmpflist)
			Variable fcounter2=0
			do
				if(fcounter2>=subfoldersLevel2)
					break
				endif
				fname=StringFromList(fcounter2,tmpflist)
			//	fname=runname+GetIndexedObjNameDFR(subfolder,4,fcounter)+":"+
				String tmpwlist2=ListWaves(fname)
				String tmpflist2=ListFolders(fname)
				fcounter2+=1
				spectralist+=tmpwlist2
			while(1)
			fcounter+=1
			//print tmpflist
			spectralist+=tmpwlist
		while (1)
		// step into the next subfolder
		// increase level
		fname=runname+GetIndexedObjNameDFR(subfolder,4,fcounter)
		level+=1
	endif
	Return spectralist
End

Function/S DeleteItemContaining(item,list)
	String item,list
	Variable items=ItemsInList(list)
	Variable itemcounter=items-1
	do
		if(itemcounter<0)
			break
		endif
		if(stringmatch(StringFromList(itemcounter,list),"*"+item+"*")==1)
			list=RemoveListItem(itemcounter,list)
			itemcounter-=1
		endif
		itemcounter-=1
	while(1)
	Return list
End

Function/S KeepItemsContaining(item,list)
	String item,list
	String newlist=""
	Variable items=ItemsInList(list)
	Variable ItemCounter=items-1
	do
		if(itemcounter<0)
			break
		endif
		if(stringmatch(StringFromList(itemcounter,list),"*"+item+"*")==1)
			newlist=AddListItem(StringFromList(itemcounter,list),newlist)
		endif
		itemcounter-=1
	while(1)
	Return newlist
End

Function SetTraceColors(type,diff)
	String type
	Variable diff
	String tracelist=TraceNameList("",";",1)
	Variable traces=ItemsInList(tracelist),tracecounter
	Wave/Z colors=$("root:"+type+"Globals:M_colors")
	if(!WaveExists(colors))
		ColorTab2Wave Rainbow
		Wave M_colors
		MoveWave M_colors,$("root:"+type+"Globals:")
		Wave colors=$("root:"+type+"Globals:M_colors")
	endif
	do
		if(tracecounter>=traces)
			break
		endif
		ModifyGraph rgb($(StringFromList(tracecounter,tracelist)))=(colors[tracecounter*diff][0],colors[tracecounter*diff][1],colors[tracecounter*diff][2])
		tracecounter+=1
	while(1)
End

Function/S folderlist(basefolder)	// Returns a list of the subfolders in the named folder
	String basefolder				// Name only. 'basefolder' should contain an ending ':'
	if(StringMatch(basefolder[strlen(basefolder)-1],":")==1)
		basefolder=basefolder[0,strlen(basefolder)-2]
	endif
	String folders=""
	Variable nooffolders=CountObjects(basefolder,4),counter
	do
		if(counter>=nooffolders)
			break
		endif
		folders=AddListItem(GetIndexedObjName(basefolder,4,counter),folders,";",inf)
		counter+=1
	while(1)
	Return folders
End

Function/S ListFolders(subfolder)	// Returns a list of the subfolders in the named folder
	String subfolder				// Full path. 'subfolder' should not contain an ending ':'
	String folderlist=""
	Variable nooffolders=CountObjects(subfolder,4)
	Variable fcounter=0
	do
		if(fcounter>=nooffolders)
			break
		endif
		folderlist=AddListItem(subfolder+":"+GetINdexedObjName(subfolder,4,fcounter),folderlist,";",inf)
		fcounter+=1
	while(1)
	Return folderlist
End

Function/S ListWaves(subfolder)
	String subfolder
	String wave_list=""
	Variable noofwaves=CountObjects(subfolder,1)
	Variable wcounter=0
	do
		if(wcounter>=noofwaves)
			break
		endif
		wave_list=AddListItem(subfolder+":"+GetIndexedObjName(subfolder,1,wcounter),wave_list,";",inf)
		wave_list=ReplaceString("::",wave_list,":")
		wcounter+=1
	while(1)
	Return wave_list
End

Function InList(element,list)
	String element, list
	Variable inlist
	Variable noofelements=ItemsInList(list)
	Variable counter
	do
		if(counter>=noofelements)
			break
		endif
		if(cmpstr(element,StringFromlist(counter,list),1)==0)
			inlist=1
			break
		endif
		counter+=1
	While(1)
	Return inlist
End

Function WeHereBKP(folder)
	String folder
	Variable weare=0
	NVAR tmp=$(folder+"checked")
	weare=tmp
	Return weare
End

Function/S WhereAreWeBKP(folder)
	String folder
	String whereweare=folder+":"
	SVAR modtypes=root:XMCD:modtypes
	Variable noofsubfolders=CountObjects(whereweare,4),counter,counter2
	String subfolders="",tmpwhere
	do
		if(counter>=noofsubfolders)
			break
		endif
		do
			if(InList(GetIndexedObjName(whereweare,4,counter),modtypes))			
				if(WeHereBKP(whereweare+GetIndexedObjName(whereweare,4,counter)))
					whereweare+=GetIndexedObjName(whereweare,4,counter)
					break
				endif
			endif
			counter2+=1
		while(cmpstr(whereweare,tmpwhere)!=0)
		counter2=0
		counter+=1		// Only update counter when going into a new subfolder
						// No, must use a different stop condition. 
	while(1)
	Return whereweare
End

Function/S WhereAreWe2(localfs,here)
	Variable localfs
	String here
	SVAR modtypes=root:XMCDGlobals:modtypes
	Variable noofsubfolders=CountObjects(here,4),counter
	SVAR basefolder=$("root:XMCDGlobals:currentdf")
	String prepend
	NVAR disptey=$(basefolder+":disptey")
	NVAR disptm=$(basefolder+":disptm")
	NVAR disptmp=$(basefolder+":disptmp")
	NVAR dispxia=$(basefolder+":dispxia")
	if(disptey)
		prepend="TEY"
	elseif(disptm)
		prepend="TM"
	elseif(disptmp)
		prepend="TMP"
	elseif(dispxia)
		prepend="XIA"
	endif
	// make a list of valid subfolders and set localfs to the number of items
	// Also have to check the status of the checkbox
	String tmp=""
	do
		if(counter>=noofsubfolders)
			break
		endif
		NVAR checked=$(here+GetIndexedObjName(here,4,counter)+":"+prepend+"checked")
		if(InList(GetIndexedObjName(here,4,counter),modtypes) && checked)
			tmp=AddListItem(GetIndexedObjName(here,4,counter),tmp)
		endif
		counter+=1
	while(1)
	localfs=ItemsInList(tmp)
	if(localfs==0)
		return here
	else
		here=WeHere2(localfs,here)
	endif
	return here
End

Function/S WeHere2(localfs,here)
	Variable localfs
	String here
	SVAR modtypes=root:XMCDGlobals:modtypes
	SVAR basefolder=$("root:XMCDGlobals:currentdf")
	String prepend
	NVAR disptey=$(basefolder+":disptey")
	NVAR disptm=$(basefolder+":disptm")
	NVAR disptmp=$(basefolder+":disptmp")
	NVAR dispxia=$(basefolder+":dispxia")
	if(disptey)
		prepend="TEY"
	elseif(disptm)
		prepend="TM"
	elseif(disptmp)
		prepend="TMP"
	elseif(dispxia)
		prepend="XIA"
	endif
	Variable noofsubfolders=CountObjects(here,4),counter
	if(numtype(noofsubfolders)!=0)
		noofsubfolders=0
	endif
	do
		if(counter>=noofsubfolders)
			break
		endif
		if(InList(GetIndexedObjName(here,4,counter),modtypes))
			NVAR tmp=$(here+GetIndexedObjName(here,4,counter)+":"+prepend+"checked") //+GetIndexedObjName(here,4,counter))
			if(tmp)
				return WhereAreWe2(localfs,here+GetIndexedObjName(here,4,counter)+":")
			endif
		endif
		counter+=1
	while(1)
	Return here
End

Function monotone(inwave)
	Wave inwave
	Variable monotone=0
	monotone=inwave[p]<inwave[p+1]?1:0
	Return monotone
End

Function en2lambda(ene)
	Variable ene
	// ene in eV
	Variable echarge=1.602176e-19
	Variable cspeed=2.99792458e8
	Variable hplanck=6.62606876e-34
	Variable convfactor=hplanck*cspeed/echarge/1e-9
	Return convfactor/ene			// Wavelength in nm
End

Function lambda2en(lambda)
	Variable lambda
	// lambda in nm
	Variable echarge=1.602176e-19
	Variable cspeed=2.99792458e8
	Variable hplanck=6.62606876e-34
	Variable convfactor=hplanck*cspeed/echarge/1e-9
	Return convfactor/lambda		// Energy in eV
End

Function snr(snrw)
	Wave snrw
	
	// use smooth/S=2 15 as an estimate of the 'original signal'
	// calc diff between measured and smoothed
	// SNR = 10* log(variance(smooth)/variance(diff))
	
	Variable snr
	Variable rows,columns,gvariance,nvariance
	rows=DimSize(snrw,0)
	columns=DimSize(snrw,1)
	Make/D/FREE/N=(rows,columns) guess,noise
	if(columns>0)
		Make/FREE/U/B/N=(rows,columns) roi
		roi[][0]=1
		roi[][1]=1
		roi[][columns-1]=1
		roi[][columns-2]=1
	endif
	guess=snrw
	if(columns==0)
		Smooth/S=2 15,guess
	else
		Smooth/S=2/Dim=0 15,guess
	endif
	noise=snrw-guess
	if(columns==0)
		WaveStats/Q guess
	else
		ImageStats/R=roi guess
	endif
	gvariance=V_sdev^2
	if(columns==0)
		WaveStats/Q noise
	else
		ImageStats/R=roi noise
	endif
	nvariance=V_sdev^2
	snr=10*log(gvariance/nvariance)
	return snr
End

Function CursorGlobalsForGraph(noofcursors)
	Variable noofcursors
	String graphName= WinName(0,1)
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName 
		Switch(noofcursors)
			case 4:
				String/G  S_CursorDInfo
			case 3:
				String/G  S_CursorCInfo
			case 2:
				String/G  S_CursorBInfo
			case 1:
				String/G S_CursorAInfo
		EndSwitch
		String/G  S_CursorBInfo
		SetDataFolder df
	endif
End

Function CursorGlobalsForGraphOnPanel()
	String graphName= WinName(0,64)
	String winpuppies=ChildWindowList("XMCDPanel")
	graphName+=("#"+StringFromList(0,winpuppies))
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName 
		String/G S_CursorAInfo, S_CursorBInfo
		SetDataFolder df
	endif
End

Function RemoveCursorGlobals()
	String graphName= WinName(0,1)
 	if( strlen(graphName) )
		KillDataFolder/Z root:WinGlobals:$graphName 
	endif
End

Function RemoveCursorGlobalsOnPanel()
	String graphName= WinName(0,1)
 	if( strlen(graphName) )
		KillDataFolder/Z root:WinGlobals:$graphName 
	endif
End