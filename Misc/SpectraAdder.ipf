#pragma rtGlobals=1		// Use modern global access method.

Function CreateSpectraAdderPanel()
	String cdf=GetDataFolder(1)
	if(!DataFolderExists("root:SpectraAdderGlobals"))
		NewDataFolder/O root:SpectraAdderGlobals
	endif
	SVAR/Z SAwl=root:SpectraAdderGlobals:SAWindowList
	if(!SVAR_exists(SAwl))
		String/G root:SpectraAdderGlobals:SAWindowList
		SVAR SAwl=root:SpectraAdderGlobals:SAWindowList
	endif
	SetDataFolder cdf
	String llist=WaveList("*",";","DIMS:1")
	if(!DataFolderExists("SpectraAdder"))
		NewDataFolder/O/S SpectraAdder
	else
		SetDataFolder SpectraAdder
	endif
	String/G grazing
	String/G normal
	Variable/G incidence_angle
	String/G grazinglist=llist
	String/G normalfolder
	String/G normallist
	SetDataFolder cdf
	String tmp="SpectraAdder_"+GetDataFolder(0)
	SetDataFolder SpectraAdder
	if(StringMatch(tmp+";",WinList(tmp,";","WIN:64"))==1)
		doWindow/F $tmp
	else
		Execute "SpectraAdder()"
		doWindow/C $tmp
		SAwl=AddListItem(cdf,SAwl)
	endif
	SetWindow $tmp hook(SAHook)=SpectraAdderWindowHook
	SetDataFolder cdf
	ConnectAdderVariables()
End

Function ConnectAdderVariables()
	String cdf=GetDataFolder(1)
	SVAR lgrazing=$(cdf+"SpectraAdder:grazing")
	SVAR lnormalf=$(cdf+"SpectraAdder:normalfolder")
	SVAR lnormal=$(cdf+"SpectraAdder:normal")
	NVAR angle=$(cdf+"SpectraAdder:incidence_angle")
//	SVAR nl=$(cdf+"SpectraAdder:normallist")
//	String tmp=nl
	PopupMenu popup_trace1 value=WaveList("*",";","DIMS:1")
	PopupMenu popup_trace1 mode=WhichListItem(lgrazing,WaveList("*",";","DIMS:1"))+1
	TitleBox title_current pos={85,11}, frame=0,fsize=12,title=GetDataFolder(0)+":"
	TitleBox title_selected pos={85,36}, frame=0,fsize=12,title=lnormalf+":"
	SetVariable setvar_incidence_angle value=angle
	Slider slider_incidence_angle value=angle
	String tmps="::"+lnormalf+":*"
	if(!StringMatch(lnormalf,"")==1)
		SetDataFolder $("::"+lnormalf)
		PopupMenu popup_trace2 value=WaveList("*",";","DIMS:1")
		PopupMenu popup_trace2 mode=WhichListItem(lnormal,WaveList("*",";","DIMS:1"))+1
	SetDataFolder cdf
	endif
	DrawSample()
	//doWindow/C $("SpectraAdder_"+GetDataFolder(0)+"_Plot")
End

Function button_select_folder_proc(ctrlname)
	String ctrlname
	String cdf=GetDataFolder(1)
	SVAR nl=$(cdf+"SpectraAdder:normallist")
	SVAR lnormalf=$(cdf+"SpectraAdder:normalfolder")
	SetDataFolder ::
	nl=ReplaceString("FOLDERS:",DataFolderDir(1),"")
	nl=ReplaceString("\r",nl,"")
	nl=ReplaceString(",",nl,";")
	String/G tmpselect
	SVAR selected=tmpselect
	Execute "SelectFolder()"
	lnormalf=selected
	TitleBox title_selected title=lnormalf+":"
	SetDataFolder lnormalf
	PopupMenu popup_trace2 value=WaveList("*",";","DIMS:1")
	PopupMenu popup_trace2 mode=WhichListItem(lnormalf,WaveList("*",";","DIMS:1"))+1
	SetDataFolder cdf
End

Macro SelectFolder(sfolder)
	String sfolder
	Prompt sfolder,"Select folder:",popup,ReplaceString(",",ReplaceString("FOLDERS:",DataFolderDir(1),""),";")
	String/G tmpselect=sfolder

End

Function popup_trace1_proc(PU_Struct) : PopupMenuControl
	Struct WMPopupAction &PU_Struct
	if(PU_Struct.eventCode==2)
		String cdf=GetDataFolder(1)
		SVAR lgrazing=$(cdf+"SpectraAdder:grazing")
		PopupMenu popup_trace1 mode=PU_Struct.popNum
		lgrazing=PU_Struct.popStr
		Duplicate/O $PU_Struct.popStr $(":SpectraAdder:multipliedgrazing")
		SetDataFolder SpectraAdder
		NVAR inc_ang=incidence_angle
		Wave/Z multipliedgrazing
		Wave/Z multipliednormal
		if(WaveExists(multipliedgrazing))
			multipliedgrazing*=(cos(inc_ang*pi/180))^2
			Wave/D/Z tmpsum
			if(!WaveExists(tmpsum))
				Make/D/N=(numpnts(multipliedgrazing)) tmpsum
			endif
			if(WaveExists(multipliednormal))
				tmpsum=multipliednormal+multipliedgrazing
			endif
		endif
		SetDataFolder cdf
		CalcSpectraSum()
	endif
	
End

Function popup_trace2_proc(PU_Struct) : PopupMenuControl
	Struct WMPopupAction &PU_Struct
	if(PU_Struct.eventCode==2)
		String cdf=GetDataFolder(1)
		SVAR lnormal=$(cdf+"SpectraAdder:normal")
		PopupMenu popup_trace2 mode=PU_Struct.popNum
		lnormal=PU_Struct.popStr
		Duplicate/O $PU_Struct.popStr $(":SpectraAdder:multipliednormal")
		SetDataFolder SpectraAdder
		NVAR inc_ang=incidence_angle
		Wave/Z multipliednormal
		Wave/Z multipliedgrazing
		if(WaveExists(multipliednormal))
			multipliednormal*=(sin(inc_ang*pi/180))^2
			Wave/D/Z tmpsum
			if(!WaveExists(tmpsum))
				Make/D/N=(numpnts(multipliednormal)) tmpsum
			endif
			if(WaveExists(multipliedgrazing))
				tmpsum=multipliednormal+multipliedgrazing
			endif
		endif
		SetDataFolder cdf
		CalcSpectraSum()
	endif
	
End

Function button_SAplot_proc(ctrlname) : ButtonControl
	String ctrlname
	String cdf=GetDataFolder(1)
	SVAR lgrazing=$(cdf+"SpectraAdder:grazing")
	SVAR lnormal=$(cdf+"SpectraAdder:normal")
	SVAR lnormfolder=$(cdf+"SpectraAdder:normalfolder")
	String xwave="omega"
	if(StringMatch("SpectraAdder_"+GetDataFolder(0)+"_Plot;",WinList("SpectraAdder_"+GetDataFolder(0)+"_Plot",";","WIN:1"))==1)
		doWindow/F $("SpectraAdder_"+GetDataFolder(0)+"_Plot")
		doWindow/F $("SpectraAdder_"+GetDataFolder(0))
	else
		Display $lgrazing vs $xwave
		AppendToGraph $("::"+lnormfolder+":"+lnormal) vs $("::"+lnormfolder+":omega")
		ModifyGraph rgb($(lnormal))=(1,4,52428)
		AppendToGraph $(":SpectraAdder:tmpsum") vs $xwave
		ModifyGraph lsize($("tmpsum"))=3
		ModifyGraph rgb($("tmpsum"))=(26214,26214,26214)
		legend "\\s(mu) Grazing\r\\s(mu#1) Normal\r\\s(tmpsum) Sum"
		doWindow/C $("SpectraAdder_"+GetDataFolder(0)+"_Plot")
		doWindow/F $("SpectraAdder_"+GetDataFolder(0))
	endif
End

Function setvar_incidence_angle_proc(SV_Struct) : SetVariableControl
	Struct WMSetVariableAction &SV_Struct
	Switch (SV_Struct.eventcode)
		case -1:
			break
		case 1:
			Slider slider_incidence_angle value=SV_Struct.dval
			 CalcSpectraSum()
			break
		case 2:
			Slider slider_incidence_angle value=SV_Struct.dval
			 CalcSpectraSum()
			break
		case 3:
			
			break
		default:
	endswitch
End

Function slider_inc_ang_proc(S_Struct) : SliderControl
	Struct WMSliderAction &S_Struct
	Switch (S_Struct.eventcode)
		case -1:
			break
		case 0:
			break
		case 1:
			break
		case 2:
			break
		case 9:
			String cdf=GetDataFolder(1)
			NVAR inc_ang=$(cdf+"SpectraAdder:incidence_angle")
			inc_ang=S_Struct.curval
			CalcSpectraSum()
			break
		default:
	endswitch
End

Function CalcSpectraSum()
	String cdf=GetDataFolder(1)
	SVAR gra=$(cdf+"SpectraAdder:grazing")
	SVAR nor=$(cdf+"SpectraAdder:normal")
	SVAR lnormalf=$(cdf+"SpectraAdder:normalfolder")
	NVAR inc_ang=$(cdf+"SpectraAdder:incidence_angle")
	Wave/Z grazw=$(gra)
	Wave/Z normw=$("::"+lnormalf+":"+nor)
	Wave/Z tmpw=$(cdf+"SpectraAdder:tmpsum")
	if(WaveExists(grazw))
		if(WaveExists(normw))
			if(WaveExists(tmpw))
	//tmpw=(sin(inc_ang*pi/180))^2*normw+(cos(inc_ang*pi/180))^2*grazw
				tmpw=((sin(inc_ang*pi/180))*normw+(cos(inc_ang*pi/180))*grazw)/(sin(inc_ang*pi/180)+cos(inc_ang*pi/180))
			endif
		endif
	endif
	DrawSample()
End

Function DrawSample()
	String cdf=GetDataFolder(1)
	NVAR inc_ang=$(cdf+"SpectraAdder:incidence_angle")
	SetDrawLayer UserBack
	SetDrawEnv gstart, gname=sample
	DrawAction delete
	SetDrawEnv linethick= 3
	Variable samplelength=20
	DrawLine (122-samplelength*sin(inc_ang*pi/180)),(153-samplelength*cos(inc_ang*pi/180)),(122+samplelength*sin(inc_ang*pi/180)),(153+samplelength*cos(inc_ang*pi/180))
	SetDrawEnv gstop
	SetDrawEnv linethick= 2,linefgc= (2,39321,1),dash= 2,arrow= 2
	DrawLine 120,157,120,241
End

Function button_save_sum_proc(ctrlname) : ButtonControl
	String ctrlname
	String cdf=GetDataFolder(1)
	Wave tmpw1=$(":SpectraAdder:tmpsum")
	NVAR inc_ang=$(":SpectraAdder:incidence_angle")
	if(inc_ang<10)
		Duplicate/O tmpw1 $("XAS_0"+num2str(inc_ang))
	else
		Duplicate/O tmpw1 $("XAS_"+num2str(inc_ang))
	endif
End

Function SpectraAdderWindowHook(H_Struct) 
	STRUCT WMWinHookStruct &H_Struct 
	String CurrentWindow=ReplaceString("SpectraAdder_",WinName(0,64),"")
	String DesiredFolder=ReplaceString("SpectraAdder_",CurrentWindow,"")
	Variable i
	//print H_Struct.eventcode
	switch(H_Struct.eventcode)
		case 0:
			SVAR SAwl=root:SpectraAdderGlobals:SAWindowList
			for(i=0;i<ItemsInList(SAwl);i+=1)
				if(Stringmatch(StringFromList(i,SAwl),"*"+DesiredFolder+":")==1)
					SetDataFolder StringFromList(i,SAwl)
				endif
			endfor
			break
		case 2:
			SVAR SAwl=root:SpectraAdderGlobals:SAWindowList
			for(i=0;i<ItemsInList(SAwl);i+=1)
				if(Stringmatch(StringFromList(i,SAwl),"*"+DesiredFolder+":")==1)
					SAwl=RemoveFromList(StringFromlist(i,SAwl),SAwl)
				endif
			endfor
			break
		default:
	endswitch
//	return statusCode // 0 if nothing done, else 1 
End

Window SpectraAdder() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1109,287,1410,564)
	SetDrawLayer UserBack
	SetDrawEnv gstart, gname=sample
	SetDrawEnv linethick= 3
	Variable samplelength=20
	DrawLine (122-samplelength*sin(5*pi/180)),(153-samplelength*cos(5*pi/180)),(122+samplelength*sin(5*pi/180)),(153+samplelength*cos(5*pi/180))
	SetDrawEnv gstop
	SetDrawEnv linethick= 2,linefgc= (2,39321,1),dash= 2,arrow= 2
	DrawLine 120,157,120,241
	TitleBox title_grazing pos={5,11}, frame=0,title="Grazing"
	TitleBox title_normal pos={5,36}, frame=0, title="Normal"
	PopupMenu popup_trace1,pos={125,8},size={88,20},title=" ",proc=popup_trace1_proc
	PopupMenu popup_trace1,mode=1,popvalue="Yes",value= #"\"Yes;No\""
	PopupMenu popup_trace2,pos={125,33},size={86,20},title=" ",proc=popup_trace2_proc
	Button button_select_folder pos={50,33},size={30,20},title="Select",proc=button_select_folder_proc
	PopupMenu popup_trace2,mode=1,popvalue="_none_",value= #"\"_none_;Yes;No\""
	SetVariable setvar_incidence_angle,pos={227,40},size={50,15},title=" ", proc=setvar_incidence_angle_proc
//	SetVariable setvar_incidence_angle,value= root:FEFF:OK_18:V_Flag
	Slider slider_incidence_angle,pos={227,73},size={46,175},limits={0,90,1},proc=slider_inc_ang_proc
//	Slider slider_incidence_angle,limits={0,90,1},value= 0
	Button button_plot,pos={83,61},size={50,20},title="Plot",proc=button_SAplot_proc
	Button button_save_sum, pos={190,220}, size={30,20}, title="Save", proc=button_save_sum_proc
EndMacro
