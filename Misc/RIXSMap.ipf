#pragma rtGlobals=1		// Use modern global access method.

Function CreateRIXSMap()
	if(!DataFolderExists("root:RIXSMap"))
		NewDataFolder/O root:RIXSMap
	endif
	Variable vertdist=20,rows=25
	Execute ("RIXSMapPanel("+num2str(vertdist)+","+num2str(rows)+")")
	PopuplateMatrix(vertdist,rows)
End

Function PopuplateMatrix(vertdistance,rows)
	Variable vertdistance,rows
	Variable nooffiles,i,j,k=0
	Variable horizdistance=140
	String pth="root:RIXSMap:"
	SVAR/Z fl=$(pth+"FolderList")
	if(!SVAR_exists(fl))
		String/G root:RIXSMap:FolderList
		SVAR fl=$(pth+"FolderList")
	endif
	fl=""
	nooffiles=CountObjectsDFR(root:,4)
	For(i=0;i<nooffiles;i+=1)
		if(StringMatch(GetIndexedObjNameDFR(root:,4,i),"D1_*"))
			fl=AddListItem(GetIndexedObjNameDFR(root:,4,i),fl,";",inf)
		endif
	endfor
	//print ItemsInList(FolderList)
	nooffiles=ItemsInList(fl)
	Wave/Z selected=root:RIXSMap:selected
	if(WaveExists(selected))
		Redimension/N=(nooffiles) root:RIXSMap:selected
	else
		Make/N=(nooffiles) root:RIXSMap:selected
		Wave selected=root:RIXSMap:selected
		selected[]=1
	endif
	for(i=0;i<floor(nooffiles/rows)+1;i+=1)
		for(j=i*rows;j<(i==floor(nooffiles/rows) ? i*rows+min(rows,mod(nooffiles,rows)) : (i+1)*rows);j+=1)
			CheckBox $("check_selected"+num2str(j)), pos={22+i*horizdistance,11+k*vertdistance},size={57,14},title=" ",value= selected[j]
			CheckBox $("check_selected"+num2str(j)), proc=checkbox_selected_proc
			TitleBox $("titlebox_file"+num2str(j)),pos={40+i*horizdistance,10+k*vertdistance},size={24,19},title=StringFromList(j,fl)
			k+=1
		endfor
		k=0
	endfor
End

Function checkbox_selected_proc(CB_Struct) : CheckBoxControl
	Struct WMCheckBoxAction &CB_Struct
	Wave selected=root:RIXSMap:selected
	Switch (CB_Struct.eventCode)
		case 2:
			Variable controlNumber=Str2num(ReplaceString("check_selected",CB_Struct.ctrlName,""))
			selected[controlNumber]=CB_Struct.checked
	EndSwitch
End

Function button_map_proc(B_Struct) : ButtonControl
	Struct WMButtonAction &B_Struct
	String pth="root:RIXSMap:"
	Wave selected=$(pth+"Selected")
	SVAR fl=$(pth+"FolderList")
	Variable i,j=0,length
	Switch (B_Struct.eventCode)
		case 2:
			do
				length=numpnts($("root:"+StringFromList(i,fl)+":Sum"+StringFromList(i,fl)))
				i+=1
			while(!selected[i-1])
			Wave/D/Z RIXSMap=$(pth+"RIXSMap")
			if(!WaveExists(RIXSMap))
				Make/D/N=(2*length,Sum(Selected)) $(pth+"RIXSMap")
			else
				Redimension/D/N=(2*length,Sum(Selected)) $(pth+"RIXSMap")
			endif
			Wave/D RIXSMap=$(pth+"RIXSMap")
			for(i=0;i<numpnts(selected);i+=1)
				if(selected[i])
					linearize_emission_map("root:"+StringFromList(i,fl)+":","root:"+StringFromList(i,fl)+":Sum"+StringFromList(i,fl))
					Wave/D lin=$("root:"+StringFromList(i,fl)+":Sum"+StringFromList(i,fl)+"_CS")
					RIXSMap[][j]=lin[p]
					j+=1
				endif
			endfor
	endSwitch
End

Function linearize_emission_map(pth,srcwave)
	String pth,srcwave
	
	//wave/Z xenergy
	String xene=pth+"xenergy"
	if(!WaveExists($xene))
		DoAlert 0, "An energy scale must exist first."
	else
		String linwave
		linwave=srcwave+"_CS"
//		if(WaveExists($linwave))
//			String tmp=linwave+" exists. Overwrite?"
//			DoAlert 1, tmp
//			if(V_flag==1)
//				linearize(srcwave, linwave,xene)
//			endif
//		else
			linearize(srcwave, linwave,xene)
//		endif
	endif
End

Window RIXSMapPanel(vertdist,rows) : Panel
	Variable vertdist,rows
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(270,100,1237,120+vertdist*rows) as "RIXSMap"
//	CheckBox check_selected1,pos={22,11},size={57,14},title=" ",value= 1
	//TitleBox titlebox_file1,pos={89,11},size={24,19},title=" "
	Button button_map,pos={868,350},size={50,20},title="Map",proc=button_map_proc
EndMacro