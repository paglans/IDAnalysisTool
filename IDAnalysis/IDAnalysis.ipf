#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

#include "HelperFunctions"

Function CreateIDAnalysis()
	String idanalysisg="root:IDAnalysisGlobals"
	if(!DataFolderExists(idanalysisg))
		NewDataFolder $idanalysisg
	endif
	String Environment=IgorInfo(0)
	Variable/G $(idanalysisg+":IgorVersion")=NumberByKey("IGORVERS",Environment)
	Variable/G  $(idanalysisg+":xScreenPixels")=str2num(StringFromList(3,StringByKey("SCREEN1",IgorInfo(0)),","))
	Variable/G  $(idanalysisg+":yScreenPixels")=str2num(StringFromList(4,StringByKey("SCREEN1",IgorInfo(0)),","))
	String/G  $(idanalysisg+":Platform")=IgorInfo(2)
	NVAR xpix= $(idanalysisg+":xScreenPixels")
	if(!DataFolderExists("root:IDAnalysis"))
		NewDataFolder root:IDAnalysis
	endif

	Execute "ID_analysis()"
	Populate_IDAnalysis()
End

Window ID_analysis() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(731,57,1553,398) as "IDAnalysis"
//	ShowTools/A
	SetDrawLayer UserBack
	DrawText 25,31,"Length of period (cm):"
	DrawText 25,45,"Number of periods:"
	DrawText 25,60,"Storage ring energy (GeV):"
	DrawText 25,75,"Ring current (A):"
	SetDrawEnv fstyle= 4
	DrawText 335,17,"Electron Beam emittance"
	DrawText 335,33,"\\$WMTEX$ \\sigma_x \\$/WMTEX$ (\\$WMTEX$ \\mu \\$/WMTEX$m):"
	DrawText 335,51,"\\$WMTEX$ \\sigma_y \\$/WMTEX$ (\\$WMTEX$ \\mu \\$/WMTEX$m):"
	DrawText 335,66,"\\$WMTEX$ \\sigma_x \\$/WMTEX$' (\\$WMTEX$ \\mu \\$/WMTEX$rad):"
	DrawText 335,84,"\\$WMTEX$ \\sigma_y \\$/WMTEX$' (\\$WMTEX$ \\mu \\$/WMTEX$rad):"
	SetDrawEnv fstyle= 4
	DrawText 25,106,"Parameters"
	DrawText 25,124,"Photon energy (eV):"
	DrawText 25,139,"Wavelength (nm):"
	DrawText 25,169,"\\$WMTEX$ \\gamma \\$/WMTEX$ value:"
	DrawText 25,185,"K value:"
	DrawText 25,199,"B field (Tesla):"
	DrawText 25,154,"Beam spread (\\$WMTEX$ \\Delta\\gamma/\\gamma): \\$/WMTEX$"
	DrawText 25,215,"Max harmonic:"
	SetDrawEnv fstyle= 4
	DrawText 335,116,"Power calculation"
	DrawText 335,131,"G function,  G(K):"
	DrawText 335,146,"Power density, d2p/d2phi0"
	DrawText 575,146,"\\$WMTEX$ W/mrad^2 \\$/WMTEX$"
	DrawText 335,162,"Total power, P:"
	DrawText 575,162,"kW"
	DrawText 660,30,"Prefill values:"
	DrawText 400,250,"K value cut-off:"
	Button bt_newsystem_idana,pos={550,11},size={90,20},title="New System",proc=bt_newsystem_idana_proc
	PopupMenu pu_systemlist_idana,pos={550,42},size={65,20},title=" ",proc=pu_systemlist_idana_proc
	PopupMenu pu_systemlist_idana,mode=1,popvalue="None",value= #"\"None\""
	PopupMenu pu_prefillID,pos={660,42},size={65,20},title=" ",proc=pu_prefillID_proc
	PopupMenu pu_prefillID,mode=1,popvalue="None",value="None;BL 4.0.2;BL 4.0.3;BL 5.0;BL 6.0.1;BL 6.0.2;BL 7.0.1;BL 7.0.2;BL 8.0.1;BL 9.0.1;BL 10.0.1;BL 11.0.1;BL 11.0.2;BL 12.0.1"
	SetVariable sv_PeriodLength,pos={175.00,17.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_NumberOfPeriods,pos={175.00,31.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_SRenergy,pos={175.00,46.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_RingCurrent,pos={175.00,61.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_sigmax,pos={418.00,20.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_sigmay,pos={418.00,34.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_sigmaxprime,pos={418.00,49.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_sigmayprime,pos={418.00,64.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_PhotonEnergy,pos={159.00,110.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_Wavelength,pos={159.00,124.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_beamspread,pos={159.00,139.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_gammavalue,pos={159.00,154.00},size={80.00,14.00},title=" ",limits={-inf,inf,0}, proc=sv_idanalysis_proc
	SetVariable sv_Kvalue,pos={159.00,170.00},size={80.00,14.00},title=" ",limits={-inf,inf,0}, proc=sv_idanalysis_proc
	SetVariable sv_Bfield,pos={159.00,185.00},size={80.00,14.00},title=" ",limits={-inf,inf,0}, proc=sv_idanalysis_proc
	SetVariable sv_MaxHarmonic,pos={159.00,201.00},size={80.00,14.00},title=" ", proc=sv_idanalysis_proc
	SetVariable sv_Gfunction,pos={488.00,116.00},size={80.00,14.00},limits={-inf,inf,0},noedit=1,title=" ", proc=sv_idanalysis_proc
	SetVariable sv_PowerDensity,pos={488.00,131.00},size={80.00,14.00},limits={-inf,inf,0},noedit=1,title=" ", proc=sv_idanalysis_proc
	SetVariable sv_TotalPower,pos={488.00,147.00},size={80.00,14.00},limits={-inf,inf,0},noedit=1,title=" ", proc=sv_idanalysis_proc
	SetVariable sv_kvaluecutoff,pos={500,236},size={80,14},title=" ",proc=sv_idanalysis_proc
	Button bt_plot_brightness,pos={500,260},size={120,20},title="Plot brightness",proc=bt_plot_brightness_proc
	Button bt_plot_flux,pos={500,285},size={120,20},title="Plot flux",proc=bt_plot_flux_proc
//	PopupMenu pu_plot_harmonics,pos={650,260},value="1,3;1,3,5;1,3,5,7;1,3,5,7,9",mode=3
EndMacro

Function bt_newsystem_idana_proc(ctrlName)
	String ctrlName
	String idana="root:IDAnalysis:"
	String idanalysisg="root:IDAnalysisGlobals:"
	String/G $(idanalysisg+"id")
	String id2
	SVAR id=$(idanalysisg+"id")
	Prompt id2,"Name?"
	doPrompt "Name of the new insertion device",id2
	id=id2
	String cdf=idana+id
	if(V_flag==0)
		if(DataFolderExists(cdf))
			doAlert 0,"System name exists. Please pick a different name."
			Return 0
		else
			NewDataFolder $(cdf)
			PopupMenu pu_systemlist_idana, value=folderlistIDAna()
			PopupMenu pu_systemlist_idana, mode=whichlistitem(id,folderlist(idana))+1
			Variable/G $(cdf+":origin_x")
			Variable/G $(cdf+":origin_y")
			NVAR origin_x=$(cdf+":origin_x")
			NVAR origin_y=$(cdf+":origin_y")
			origin_x=600
			origin_y=675
			
			// Parameters
			Variable/G $(cdf+":periodlength")
			Variable/G $(cdf+":numberofperiods")
			Variable/G $(cdf+":srenergy")
			Variable/G $(cdf+":ringcurrent")
			Variable/G $(cdf+":sigmax")
			Variable/G $(cdf+":sigmay")
			Variable/G $(cdf+":sigmaxprime")
			Variable/G $(cdf+":sigmayprime")
			Variable/G $(cdf+":photonenergy")
			Variable/G $(cdf+":wavelength")
			Variable/G $(cdf+":beamspread")
			Variable/G $(cdf+":gammavalue")
			Variable/G $(cdf+":kvalue")
			Variable/G $(cdf+":Bfield")
			Variable/G $(cdf+":maxharmonic")
			Variable/G $(cdf+":noofharmonics")
			Variable/G $(cdf+":gfunction")
			Variable/G $(cdf+":powerdensity")
			Variable/G $(cdf+":totalpower")
			Variable/G $(cdf+":kcutoff")
			
			//Harmonics
			Make/D/N=0 $(cdf+":harmharmonics")
			Make/D/N=0 $(cdf+":harmenergies")
			Make/D/N=0 $(cdf+":harmwavelengths")
			Make/D/N=0 $(cdf+":harmsigmar")
			Make/D/N=0 $(cdf+":harmsigmarprime")
			Make/D/N=0 $(cdf+":harmsigmax")
			Make/D/N=0 $(cdf+":harmsigmay")
			Make/D/N=0 $(cdf+":harmsigmaxprime")
			Make/D/N=0 $(cdf+":harmsigmayprime")
			Make/D/N=0 $(cdf+":harmxvalue")
			Make/D/N=0 $(cdf+":harmFnK")
			Make/D/N=0 $(cdf+":harmd2Fnd2phi")
			Make/D/N=0 $(cdf+":harmd2Pnd2phi")
			Make/D/N=0 $(cdf+":harmFn")
			Make/D/N=0 $(cdf+":harmPn")
			Make/D/N=0 $(cdf+":harmd2Fndthetadpsi")
			Make/D/N=0 $(cdf+":harmd2Pndthetadpsi")
			Make/D/N=0 $(cdf+":harmBn")
			
			//Spectra
			Make/D/N=0 $(cdf+":harmonics")
			Make/D/N=0 $(cdf+":energies")
			Make/D/N=0 $(cdf+":wavelengths")
			Make/D/N=0 $(cdf+":sigmar")
			Make/D/N=0 $(cdf+":sigmarprime")
			Make/D/N=0 $(cdf+":sigmax_w")
			Make/D/N=0 $(cdf+":sigmay_w")
			Make/D/N=0 $(cdf+":sigmaxprime_w")
			Make/D/N=0 $(cdf+":sigmayprime_w")
			Make/D/N=0 $(cdf+":xvalue")
			Make/D/N=0 $(cdf+":FnK")
			Make/D/N=0 $(cdf+":d2Fnd2phi")
			Make/D/N=0 $(cdf+":d2Pnd2phi")
			Make/D/N=0 $(cdf+":Fn")
			Make/D/N=0 $(cdf+":Pn")
			Make/D/N=0 $(cdf+":d2Fndthetadpsi")
			Make/D/N=0 $(cdf+":d2Pndthetadpsi")
			Make/D/N=0 $(cdf+":Bn")
			Make/D/N=0 $(cdf+":Kvalues")
			
			
			Variable/G $(cdf+":selectedharmonic")
			Variable/G $(cdf+":totd2Fnd2phi")
			Variable/G $(cdf+":totd2Pnd2phi")
			Variable/G $(cdf+":totFn")
			Variable/G $(cdf+":totFn")
			Variable/G $(cdf+":totPn")
			Variable/G $(cdf+":toth2Fndthetadpsi")
			Variable/G $(cdf+":toth2Pndthetadpsi")
			Variable/G $(cdf+":totBn")
			
			Populate_IDAnalysis()
		endif
	endif
End

Function bt_plot_brightness_proc(ctrlName)
	String ctrlName
	String idana="root:IDAnalysis:"
	String idanalysisg="root:IDAnalysisGlobals:"
	doWindow/F ID_Analysis
	ControlInfo/W=ID_Analysis pu_systemlist_idana
	if(StringMatch(S_Value,"None"))
		Return 0
	endif
	String cdf=idana+S_Value+":"
	Wave xwave=$(cdf+"energies")
	Wave brightness=$(cdf+"Bn")
	Display/N=$(S_Value+"_bright") brightness[][0] vs xwave[][0] as S_Value+"_Brightness"
	AppendToGraph brightness[][1] vs xwave[][1]
	AppendToGraph brightness[][2] vs xwave[][2]
	AppendToGraph brightness[][3] vs xwave[][3]
	Label bottom "Photon energy (eV)"
	Label left "Brightness (photons/s/mm²/mrad²/0.1%BW)"
	ModifyGraph grid(left)=1,log=1,mirror=1,minor=0
End

Function bt_plot_flux_proc(ctrlName)
	String ctrlName
	String idana="root:IDAnalysis:"
	String idanalysisg="root:IDAnalysisGlobals:"
	doWindow/F ID_Analysis
	ControlInfo/W=ID_Analysis pu_systemlist_idana
	if(StringMatch(S_Value,"None"))
		Return 0
	endif
	String cdf=idana+S_Value+":"
	Wave xwave=$(cdf+"energies")
	Wave flux=$(cdf+"Fn")
	Display/N=$(S_Value+"_Flux") flux[][0] vs xwave[][0] as S_Value+"_Flux"
	AppendToGraph flux[][1] vs xwave[][1]
	AppendToGraph flux[][2] vs xwave[][2]
	AppendToGraph flux[][3] vs xwave[][3]
	Label bottom "Photon energy (eV)"
	Label left "Flux in central cone (Photons/s/0.1%BW)"
	ModifyGraph grid(left)=1,log=1,mirror=1,minor=0
End


Function pu_systemlist_idana_proc(PU_Struct) : PopupMenuControl
	Struct WMPopupAction &PU_Struct
	PU_Struct.blockReentry=1
	Switch(PU_Struct.eventcode)
		case 2:
			PopupMenu pu_systemlist_idana value=folderlist("root:IDAnalysis")
			PopupMenu pu_systemlist_idana mode=PU_Struct.popnum
//			doWindow/F $(PU_Struct.popStr)
//			doWindow/F $(PU_Struct.popStr+"_Resolution")
			doWindow/F ID_Analysis
			doWindow/F $(PU_Struct.popStr+"_bright")
			doWindow/F $(PU_Struct.popStr+"_Flux")
			Populate_IDAnalysis()
			String idana="root:IDAnalysis:"
			String cdf=idana+PU_Struct.PopStr
//			NVAR enestart=$(cdf+":enestart")
//			NVAR enestop=$(cdf+":enestop")
//			NVAR m203rotx=$(cdf+":m203rotx")
//			NVAR m203roty=$(cdf+":m203roty")
//			NVAR m203offset=$(cdf+":m203offset")
//			NVAR g201dist=$(cdf+":g201dist")
//			if(enestop>enestart)
//				Slider slider_energy_amb,limits={enestart,enestop,1},ticks=20
//				DrawGrating(cdf,"slider_energy_amb")
//				DrawMirrorToGrating(cdf,"slider_energy_amb","m203g201dist","m203dist",g201dist*100,m203offset,0)
//				DrawHeight(cdf,0,m203offset)
//				DrawMRot(cdf,m203rotx,m203roty)
//			endif
			break
	EndSwitch
End

Function pu_prefillID_proc(PU_Struct) : PopupMenuControl
	Struct WMPopupAction &PU_Struct
	PU_Struct.blockReentry=1
	Switch(PU_Struct.eventcode)
		case 2:
			ControlInfo/W=ID_Analysis pu_systemlist_idana
			if(cmpstr(S_Value,"None",0)==0)
				doAlert/T="Beep" 0,"Please define a system first"
				break
			endif
			String idana="root:IDAnalysis:"
			String cdf=idana+S_Value
			NVAR periodlength=$(cdf+":periodlength")
			NVAR numberofperiods=$(cdf+":numberofperiods")
			NVAR srenergy=$(cdf+":srenergy")
			NVAR ringcurrent=$(cdf+":ringcurrent")
			NVAR sigmax=$(cdf+":sigmax")
			NVAR sigmay=$(cdf+":sigmay")
			NVAR sigmaxprime=$(cdf+":sigmaxprime")
			NVAR sigmayprime=$(cdf+":sigmayprime")
			NVAR photonenergy=$(cdf+":photonenergy")
			NVAR wavelength=$(cdf+":wavelength")
			NVAR maxharmonic=$(cdf+":maxharmonic")
			NVAR kcutoff=$(cdf+":kcutoff")
			Wave harmharmonics=$(cdf+":harmharmonics")
			Wave harmenergies=$(cdf+":harmenergies")
			Wave harmwavelengths=$(cdf+":harmwavelengths")
			Wave harmsigmar=$(cdf+":harmsigmar")
			Wave harmsigmarprime=$(cdf+":harmsigmarprime")
			Wave harmsigmax=$(cdf+":harmsigmax")
			Wave harmsigmay=$(cdf+":harmsigmay")
			Wave harmsigmaxprime=$(cdf+":harmsigmaxprime")
			Wave harmsigmayprime=$(cdf+":harmsigmayprime")
			Wave harmxvalue=$(cdf+":harmxvalue")
			Wave harmFnK=$(cdf+":harmFnK")
			Wave harmd2Fnd2phi=$(cdf+":harmd2Fnd2phi")
			Wave harmd2Pnd2phi=$(cdf+":harmd2Pnd2phi")
			Wave harmFn=$(cdf+":harmFn")
			Wave harmPn=$(cdf+":harmPn")
			Wave harmd2Fndthetadpsi=$(cdf+":harmd2Fndthetadpsi")
			Wave harmd2Pndthetadpsi=$(cdf+":harmd2Pndthetadpsi")
			Wave harmBn=$(cdf+":harmBn")
			StrSwitch(PU_Struct.popStr)
			//;BL 7.0.1;BL 7.0.2;BL 8.0.1;BL 9.0.1;BL 10.0.1;BL 11.0.1;BL 11.0.2;BL 12.0.1
				case "BL 4.0.2":
					periodlength=5
					numberofperiods=37
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=73
					break
				case "BL 4.0.3":
					periodlength=9
					numberofperiods=20.5
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=8
					break
				case "BL 5.0":
					periodlength=11.4
					numberofperiods=29
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=6
					break
				case "BL 6.0.1":
					periodlength=3
					numberofperiods=50
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=250
					break
				case "BL 6.0.2":
					periodlength=3.5
					numberofperiods=54
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=200
					break
				case "BL 7.0.1":
					periodlength=3.5
					numberofperiods=54
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=200
					break
				case "BL 7.0.2":
					periodlength=7
					numberofperiods=26.5
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=16
					break
				case "BL 8.0.1":
					periodlength=5
					numberofperiods=89
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=80
					break
				case "BL 9.0.1":
					periodlength=10
					numberofperiods=43
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=8
					break
				case "BL 10.0.1":
					periodlength=10
					numberofperiods=43
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=12
					break
				case "BL 11.0.1":
					periodlength=5
					numberofperiods=36.5
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=75
					break
				case "BL 11.0.2":
					periodlength=5
					numberofperiods=37
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=71
					break
				case "BL 12.0.1":
					periodlength=8
					numberofperiods=55
					srenergy=1.9
					ringcurrent=.5
					sigmax=251
					sigmay=9
					sigmaxprime=8
					sigmayprime=3.3
					photonenergy=20
					break
			endSwitch
			wavelength=en2lambda(photonenergy)
			srenergy=1.9
			ringcurrent=.5
			maxharmonic=35
			Redimension/N=(floor((maxharmonic+1)/2)) harmharmonics,harmenergies,harmwavelengths,harmsigmar,harmsigmarprime
			Redimension/N=(floor((maxharmonic+1)/2)) harmsigmax,harmsigmay,harmsigmaxprime,harmsigmayprime,harmxvalue,harmFnK,harmd2Fnd2phi,harmd2Pnd2phi
			Redimension/N=(floor((maxharmonic+1)/2)) harmFn,harmPn,harmd2Fndthetadpsi,harmd2Pndthetadpsi,harmBn
			kcutoff=0.01
			Calc_IDAnalysis()
			Populate_IDAnalysis()
			
			break
	endSwitch
End

Function Populate_IDAnalysis()
	String idana="root:IDAnalysis:"
	doWindow/F ID_Analysis
	ControlInfo/W=ID_Analysis pu_systemlist_idana
	if(StringMatch(S_Value,"None"))
		String tmp="\""+folderlist(idana)+"\""
		PopupMenu pu_systemlist_idana, value=#tmp
		PopupMenu pu_systemlist_idana, mode=1
	endif
	ControlInfo/W=ID_Analysis pu_systemlist_idana
	String cdf=idana+S_Value
	String idlist=folderlist(idana)
	Variable noofitems=ItemsInList(idlist)
	if(noofitems!=0)
	
		// Parameters
		NVAR/Z periodlength=$(cdf+":periodlength")
		NVAR/Z numberofperiods=$(cdf+":numberofperiods")
		NVAR/Z srenergy=$(cdf+":srenergy")
		NVAR/Z ringcurrent=$(cdf+":ringcurrent")
		NVAR/Z sigmax=$(cdf+":sigmax")
		NVAR/Z sigmay=$(cdf+":sigmay")
		NVAR/Z sigmaxprime=$(cdf+":sigmaxprime")
		NVAR/Z sigmayprime=$(cdf+":sigmayprime")
		NVAR/Z photonenergy=$(cdf+":photonenergy")
		NVAR/Z wavelength=$(cdf+":wavelength")
		NVAR/Z beamspread=$(cdf+":beamspread")
		NVAR/Z gammavalue=$(cdf+":gammavalue")
		NVAR/Z kvalue=$(cdf+":kvalue")
		NVAR/Z Bfield=$(cdf+":Bfield")
		NVAR/Z maxharmonic=$(cdf+":maxharmonic")
		NVAR/Z noofharmonics=$(cdf+":noofharmonics")
		NVAR/Z gfunction=$(cdf+":gfunction")
		NVAR/Z powerdensity=$(cdf+":powerdensity")
		NVAR/Z totalpower=$(cdf+":totalpower")
		NVAR/Z kcutoff=$(cdf+":kcutoff")
	
		// Results
		NVAR/Z selectedharmonic=$(cdf+":selectedharmonic")
		NVAR/Z totd2Fnd2phi=$(cdf+":totd2Fnd2phi")
		NVAR/Z totd2Pnd2phi=$(cdf+":totd2Pnd2phi")
		NVAR/Z totFn=$(cdf+":totFn")
		NVAR/Z totFn=$(cdf+":totFn")
		NVAR/Z totPn=$(cdf+":totPn")
		NVAR/Z toth2Fndthetadpsi=$(cdf+":toth2Fndthetadpsi")
		NVAR/Z toth2Pndthetadpsi=$(cdf+":toth2Pndthetadpsi")
		NVAR/Z totBn=$(cdf+":totBn")
		
		
		SetVariable sv_PeriodLength,value=_NUM:periodlength
		SetVariable sv_NumberOfPeriods,value=_NUM:numberofperiods
		SetVariable sv_SRenergy,value=_NUM:srenergy
		SetVariable sv_RingCurrent,value=_NUM:ringcurrent
		SetVariable sv_sigmax,value=_NUM:sigmax
		SetVariable sv_sigmay,value=_NUM:sigmay
		SetVariable sv_sigmaxprime,value=_NUM:sigmaxprime
		SetVariable sv_sigmayprime,value=_NUM:sigmayprime
		SetVariable sv_PhotonEnergy,value=_NUM:photonenergy
		SetVariable sv_Wavelength,value=_NUM:wavelength
		SetVariable sv_beamspread,value=_NUM:beamspread
		SetVariable sv_gammavalue,value=_NUM:gammavalue
		SetVariable sv_Kvalue,value=_NUM:kvalue
		SetVariable sv_Bfield,value=_NUM:Bfield
		SetVariable sv_MaxHarmonic,value=_NUM:maxharmonic
		SetVariable sv_Gfunction,value=_NUM:gfunction
		SetVariable sv_PowerDensity,value=_NUM:powerdensity
		SetVariable sv_TotalPower,value=_NUM:totalpower
		SetVariable sv_kvaluecutoff,value=_NUM:kcutoff
	endif
End

Function/S folderlistIDAna()	// Returns a list of the subfolders in the named folder
	String basefolder="root:IDAnalysis:"				// Name only. 'basefolder' should contain an ending ':'
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

Function sv_idanalysis_proc(SV_Struct) : SetVariableControl
	Struct WMSetVariableAction &SV_Struct
	SV_Struct.blockReentry=1
	Switch(SV_Struct.eventCode)
		case 1:
		case 2:
			String idana="root:IDAnalysis:"
			ControlInfo/W=ID_Analysis pu_systemlist_idana
			String cdf=idana+S_Value
			// Parameters
			NVAR periodlength=$(cdf+":periodlength")
			NVAR numberofperiods=$(cdf+":numberofperiods")
			NVAR srenergy=$(cdf+":srenergy")
			NVAR ringcurrent=$(cdf+":ringcurrent")
			NVAR sigmax=$(cdf+":sigmax")
			NVAR sigmay=$(cdf+":sigmay")
			NVAR sigmaxprime=$(cdf+":sigmaxprime")
			NVAR sigmayprime=$(cdf+":sigmayprime")
			NVAR photonenergy=$(cdf+":photonenergy")
			NVAR wavelength=$(cdf+":wavelength")
			NVAR beamspread=$(cdf+":beamspread")
			NVAR gammavalue=$(cdf+":gammavalue")
			NVAR kvalue=$(cdf+":kvalue")
			NVAR Bfield=$(cdf+":Bfield")
			NVAR maxharmonic=$(cdf+":maxharmonic")
			NVAR noofharmonics=$(cdf+":noofharmonics")
			NVAR gfunction=$(cdf+":gfunction")
			NVAR powerdensity=$(cdf+":powerdensity")
			NVAR totalpower=$(cdf+":totalpower")
			NVAR kcutoff=$(cdf+":kcutoff")
	
			// Results
			NVAR selectedharmonic=$(cdf+":selectedharmonic")
			NVAR totd2Fnd2phi=$(cdf+":totd2Fnd2phi")
			NVAR totd2Pnd2phi=$(cdf+":totd2Pnd2phi")
			NVAR totFn=$(cdf+":totFn")
			NVAR totFn=$(cdf+":totFn")
			NVAR totPn=$(cdf+":totPn")
			NVAR toth2Fndthetadpsi=$(cdf+":toth2Fndthetadpsi")
			NVAR toth2Pndthetadpsi=$(cdf+":toth2Pndthetadpsi")
			NVAR totBn=$(cdf+":totBn")
			
			//Harmonics
			Wave harmharmonics=$(cdf+":harmharmonics")
			Wave harmenergies=$(cdf+":harmenergies")
			Wave harmwavelengths=$(cdf+":harmwavelengths")
			Wave harmsigmar=$(cdf+":harmsigmar")
			Wave harmsigmarprime=$(cdf+":harmsigmarprime")
			Wave harmsigmax=$(cdf+":harmsigmax")
			Wave harmsigmay=$(cdf+":harmsigmay")
			Wave harmsigmaxprime=$(cdf+":harmsigmaxprime")
			Wave harmsigmayprime=$(cdf+":harmsigmayprime")
			Wave harmxvalue=$(cdf+":harmxvalue")
			Wave harmFnK=$(cdf+":harmFnK")
			Wave harmd2Fnd2phi=$(cdf+":harmd2Fnd2phi")
			Wave harmd2Pnd2phi=$(cdf+":harmd2Pnd2phi")
			Wave harmFn=$(cdf+":harmFn")
			Wave harmPn=$(cdf+":harmPn")
			Wave harmd2Fndthetadpsi=$(cdf+":harmd2Fndthetadpsi")
			Wave harmd2Pndthetadpsi=$(cdf+":harmd2Pndthetadpsi")
			Wave harmBn=$(cdf+":harmBn")
	
			StrSwitch(SV_Struct.ctrlName)
			// Parameters
				case "sv_PeriodLength":
					periodlength=SV_Struct.dval
					break
				case "sv_NumberOfPeriods":
					numberofperiods=SV_Struct.dval
					break
				case "sv_SRenergy":
					srenergy=SV_Struct.dval
					break
				case "sv_RingCurrent":
					ringcurrent=SV_Struct.dval
					break
				case "sv_sigmax":
					sigmax=SV_Struct.dval
					break
				case "sv_sigmay":
					sigmay=SV_Struct.dval
					break
				case "sv_sigmaxprime":
					sigmaxprime=SV_Struct.dval
					break
				case "sv_sigmayprime":
					sigmayprime=SV_Struct.dval
					break
				case "sv_PhotonEnergy":
					photonenergy=SV_Struct.dval
					wavelength=en2lambda(photonenergy)
					break
				case "sv_Wavelength":
					wavelength=SV_Struct.dval
					photonenergy=lambda2en(wavelength)
					break
				case "sv_beamspread":
					beamspread=SV_Struct.dval
					break
				case "sv_gammavalue":
					gammavalue=SV_Struct.dval
					break
				case "sv_Kvalue":
					kvalue=SV_Struct.dval
					break
				case "sv_Bfield":
					Bfield=SV_Struct.dval
					break
				case "sv_MaxHarmonic":
					maxharmonic=SV_Struct.dval
					Redimension/N=(floor((maxharmonic+1)/2)) harmharmonics,harmenergies,harmwavelengths,harmsigmar,harmsigmarprime
					Redimension/N=(floor((maxharmonic+1)/2)) harmsigmax,harmsigmay,harmsigmaxprime,harmsigmayprime,harmxvalue,harmFnK,harmd2Fnd2phi,harmd2Pnd2phi
					Redimension/N=(floor((maxharmonic+1)/2)) harmFn,harmPn,harmd2Fndthetadpsi,harmd2Pndthetadpsi,harmBn
					break
				case "sv_Gfunction":
					gfunction=SV_Struct.dval
					break
				case "sv_PowerDensity":
					powerdensity=SV_Struct.dval
					break
				case "sv_TotalPower":
					totalpower=SV_Struct.dval
					break
				case "sv_kvaluecutoff":
					kcutoff=SV_Struct.dval
					break
			endSwitch
//			if(enestop>enestart)
//				Slider slider_energy_amb,limits={enestart,enestop,1},ticks=20
///				Wave energyrange_eV=$(cdf+":energyrange_eV")
//				Wave energyrange_nm=$(cdf+":energyrange_nm")
//				Wave betas=$(cdf+":betas")
//				Wave alphas=$(cdf+":alphas")
//				Wave twotheta=$(cdf+":twotheta")
//				Wave sigmaHreals=$(cdf+":sigmaHreals")
//				Wave sigmaVreals=$(cdf+":sigmaVreals")
//				Wave sigmaprHreals=$(cdf+":sigmaprHreals")
//				Wave sigmaprVreals=$(cdf+":sigmaprVreals")
//				Redimension/N=(enestop-enestart+1) energyrange_eV,energyrange_nm,alphas,betas,twotheta
//				Redimension/N=(enestop-enestart+1) sigmaHreals,sigmaVreals,sigmaprHreals,sigmaprVreals
//				energyrange_eV[]=p+enestart
//				energyrange_nm[]=en2lambda(energyrange_eV[p])
				
		//		betas[]=CalcBetaVIAVLS(cdf,energyrange_nm[p],g201dist*100,g201distslit*100,g201n0,order,cff)
//				betas[]=CalcBetaVIAVLS2(cdf,energyrange_nm[p],g201dist,g201distslit,g201n0,g201g1,order,cff)
//				alphas[]=acos(cos(betas[p]*pi/180)/cff)*180/pi
//				twotheta[]=alphas[p]-betas[p]
//				//M201
//				Wave m201tangents=$(cdf+":m201tangents")
//				Wave m201sagittals=$(cdf+":m201sagittals")
//				Redimension/N=(enestop-enestart+1) m201tangents,m201sagittals
//				//M202
//				Wave m202tangents=$(cdf+":m202tangents")
//				Wave m202sagittals=$(cdf+":m202sagittals")
//				Redimension/N=(enestop-enestart+1) m202tangents,m202sagittals
				//M203
//				Wave m203dists=$(cdf+":m203dists")
//				Wave m203tangents=$(cdf+":m203tangents")
//				Wave m203sagittals=$(cdf+":m203sagittals")
//				Redimension/N=(enestop-enestart+1) m203dists,m203tangents,m203sagittals
				//G201
//				DrawGrating(cdf,"slider_energy_amb")
				
//				Wave xp_far=$(cdf+":xp_far")
//				Wave yp_far=$(cdf+":yp_far")
//				Wave xp_near=$(cdf+":xp_near")
//				Wave yp_near=$(cdf+":yp_near")
//				Redimension/N=(enestop-enestart+1) xp_far,yp_far,xp_near,yp_near
//			endif
//			m203length=CalcMirrorLength(cdf,"slider_energy_amb",sigmaH,sigmaV,sigmaprH,sigmaprV,g201dist,m203offset,m203rotx,m203roty)
			Calc_IDAnalysis()
			Populate_IDAnalysis()
	endSwitch
End

Function Calc_IDAnalysis()
	String idana="root:IDAnalysis:"
	ControlInfo/W=ID_Analysis pu_systemlist_idana
	String cdf=idana+S_Value
	// Parameters
	NVAR periodlength=$(cdf+":periodlength")
	NVAR numberofperiods=$(cdf+":numberofperiods")
	NVAR srenergy=$(cdf+":srenergy")
	NVAR ringcurrent=$(cdf+":ringcurrent")
	NVAR sigmax=$(cdf+":sigmax")
	NVAR sigmay=$(cdf+":sigmay")
	NVAR sigmaxprime=$(cdf+":sigmaxprime")
	NVAR sigmayprime=$(cdf+":sigmayprime")
	NVAR photonenergy=$(cdf+":photonenergy")
	NVAR wavelength=$(cdf+":wavelength")
	NVAR beamspread=$(cdf+":beamspread")
	NVAR gammavalue=$(cdf+":gammavalue")
	NVAR kvalue=$(cdf+":kvalue")
	NVAR Bfield=$(cdf+":Bfield")
	NVAR maxharmonic=$(cdf+":maxharmonic")
	NVAR noofharmonics=$(cdf+":noofharmonics")
	NVAR gfunction=$(cdf+":gfunction")
	NVAR powerdensity=$(cdf+":powerdensity")
	NVAR totalpower=$(cdf+":totalpower")
	NVAR kcutoff=$(cdf+":kcutoff")
	
	// Results
	NVAR selectedharmonic=$(cdf+":selectedharmonic")
	NVAR totd2Fnd2phi=$(cdf+":totd2Fnd2phi")
	NVAR totd2Pnd2phi=$(cdf+":totd2Pnd2phi")
	NVAR totFn=$(cdf+":totFn")
	NVAR totFn=$(cdf+":totFn")
	NVAR totPn=$(cdf+":totPn")
	NVAR toth2Fndthetadpsi=$(cdf+":toth2Fndthetadpsi")
	NVAR toth2Pndthetadpsi=$(cdf+":toth2Pndthetadpsi")
	NVAR totBn=$(cdf+":totBn")
	
	//Harmonics
	Wave harmharmonics=$(cdf+":harmharmonics")
	Wave harmenergies=$(cdf+":harmenergies")
	Wave harmwavelengths=$(cdf+":harmwavelengths")
	Wave harmsigmar=$(cdf+":harmsigmar")
	Wave harmsigmarprime=$(cdf+":harmsigmarprime")
	Wave harmsigmax=$(cdf+":harmsigmax")
	Wave harmsigmay=$(cdf+":harmsigmay")
	Wave harmsigmaxprime=$(cdf+":harmsigmaxprime")
	Wave harmsigmayprime=$(cdf+":harmsigmayprime")
	Wave harmxvalue=$(cdf+":harmxvalue")
	Wave harmFnK=$(cdf+":harmFnK")
	Wave harmd2Fnd2phi=$(cdf+":harmd2Fnd2phi")
	Wave harmd2Pnd2phi=$(cdf+":harmd2Pnd2phi")
	Wave harmFn=$(cdf+":harmFn")
	Wave harmPn=$(cdf+":harmPn")
	Wave harmd2Fndthetadpsi=$(cdf+":harmd2Fndthetadpsi")
	Wave harmd2Pndthetadpsi=$(cdf+":harmd2Pndthetadpsi")
	Wave harmBn=$(cdf+":harmBn")
			
	//Spectra
	Wave harmonics=$(cdf+":harmonics")
	Wave energies=$(cdf+":energies")
	Wave wavelengths=$(cdf+":wavelengths")
	Wave sigmar=$(cdf+":sigmar")
	Wave sigmarprime=$(cdf+":sigmarprime")
	Wave sigmax_w=$(cdf+":sigmax_w")
	Wave sigmay_w=$(cdf+":sigmay_w")
	Wave sigmaxprime_w=$(cdf+":sigmaxprime_w")
	Wave sigmayprime_w=$(cdf+":sigmayprime_w")
	Wave xvalue=$(cdf+":xvalue")
	Wave FnK=$(cdf+":FnK")
	Wave d2Fnd2phi=$(cdf+":d2Fnd2phi")
	Wave d2Pnd2phi=$(cdf+":d2Pnd2phi")
	Wave Fn=$(cdf+":Fn")
	Wave Pn=$(cdf+":Pn")
	Wave d2Fndthetadpsi=$(cdf+":d2Fndthetadpsi")
	Wave d2Pndthetadpsi=$(cdf+":d2Pndthetadpsi")
	Wave Bn=$(cdf+":Bn")
	Wave Kvalues=$(cdf+":Kvalues")
	
	gammavalue=srenergy*1000/0.510998910			// gamma = electron energy / (electron mass * c^2)
	kvalue=sqrt((4*gammavalue^2*wavelength*10^-7/periodlength)-2)		// Calculating K from a given wavelength, Eq (11), Section 2, Orange Book
	Bfield=kvalue/(periodlength*0.934)											// Calculating B0 from K, Eq (9), Section 2, Orange Book
	gfunction=(kvalue^7+24*kvalue^5/7+4*kvalue^3+16*kvalue/7)/((1+kvalue^2)^3.5)
	powerdensity=10.84*Bfield*srenergy^4*ringcurrent*numberofperiods*gfunction			// Eq (19), practical units, Section 2, Orange Book
	totalpower=0.633*(Bfield*srenergy)^2*ringcurrent*periodlength*numberofperiods/100	// Eq (18), practical units, Section 2, Orange Book
	
	if(numpnts(harmharmonics)>0)
		harmharmonics[]=floor((2*p+1))				// Fill the harmonics wave with the odd numbered harmonics from 1 up to the max harmonic
		harmwavelengths[]=wavelength/harmharmonics[p]	
		harmenergies[]=lambda2en(harmwavelengths[p])
		harmsigmar[]=sqrt(harmwavelengths[p]*periodlength*numberofperiods*10)*0.001/(4*pi)
		harmsigmarprime[]=sqrt(harmwavelengths[p]*10/(periodlength*numberofperiods))*0.1		// Eq (15), Section 2, Orange Book
		harmsigmax=sqrt((sigmax/1000)^2+harmsigmar^2)							// Horizontal total beam size
		harmsigmay=sqrt((sigmay/1000)^2+harmsigmar^2)							// Vertical total beam size
		harmsigmaxprime=sqrt((sigmaxprime/1000)^2+harmsigmarprime^2)		// Horizontal total beam divergence(?)
		harmsigmayprime=sqrt((sigmayprime/1000)^2+harmsigmarprime^2)		// Vertical total beam divergence(?)
		harmxvalue=harmharmonics*kvalue^2/(4+2*kvalue^2)		// Argument to the BesselJ function in Eq (14), Section 2, Orange Book
		harmFnK[]=((harmharmonics[p]*kvalue/(1+kvalue^2/2)) * (Besselj((harmharmonics[p]-1)/2,harmxvalue[p])-Besselj((harmharmonics[p]+1)/2,harmxvalue[p])))^2
																			// Eq (14), Section 2, Orange Book
		harmd2Fnd2phi=1.744e14*(numberofperiods*srenergy)^2*ringcurrent*harmFnK	// one electron approx, peak angular density (ph/s-mrad2-0.1% BW)
		harmd2Pnd2phi=harmd2Fnd2phi*harmenergies*1.602e-19								// power from peak angular density  (W/mrad2-0.1% BW)
		harmFn=1.431e14*numberofperiods*ringcurrent*(1+kvalue^2/2)*harmFnK/harmharmonics	// Flux in the central cone (ph/s-0.1% BW), Eq (17), Section 2, Orange Book
		harmPn=harmFn*harmenergies*1.602e-19													// power from central cone (W/-0.1% BW)
		harmd2Fndthetadpsi=harmFn/(2*pi*harmsigmaxprime*harmsigmayprime)	// multi electron approx, peak angular density  (ph/s-mrad2-0.1% BW), Eq (21), Section 2, Orange Book
		harmd2Pndthetadpsi=harmPn/(2*pi*harmsigmaxprime*harmsigmayprime)	// power from peak angular density  (W/mrad2-0.1% BW)
		harmBn=harmFn/(4*pi^2*harmsigmax*harmsigmay*harmsigmaxprime*harmsigmayprime)	// multi-electron approx brightness (ph/s-mm2-mrad2-0.001BW)
	endif
	
	Variable kstart=ceil(100*kvalue)/100
	Variable kstep=0.01
	Variable numkpoints=(kstart-kcutoff)/kstep
	if(numtype(numkpoints)==0)
		Redimension/N=(numkpoints,4) energies,wavelengths,sigmar,sigmarprime,sigmax_w,sigmay_w,sigmaxprime_w,sigmayprime_w
		Redimension/N=(numkpoints,4) xvalue,FnK,d2Fnd2phi,d2Pnd2phi,Fn,Pn,d2Fndthetadpsi,d2Pndthetadpsi,Bn
		Redimension/N=(numkpoints) Kvalues
	endif
	
	//Column 0: harmonic 1
	//Column 1: harmonic 3
	//Column 2: harmonic 5
	//Column 3: harmonic 7 
	// ...
	if(numtype(kstart)==0)
		Kvalues[]=kstart-p*kstep
		wavelengths[][]=(1e8*(1+Kvalues[p]^2/2)*periodlength/(2*gammavalue^2))/(q*2+1)/10
	endif
	if(numpnts(wavelengths)>0)
		energies=lambda2en(wavelengths)
		sigmar=sqrt(wavelengths*periodlength*numberofperiods*10)*0.001/(4*pi)
		sigmarprime=sqrt(wavelengths*10/(periodlength*numberofperiods))*0.1
		sigmax_w=sqrt((sigmax/1000)^2+sigmar^2)
		sigmay_w=sqrt((sigmay/1000)^2+sigmar^2)
		sigmaxprime_w=sqrt((sigmaxprime/1000)^2+sigmarprime^2)
		sigmayprime_w=sqrt((sigmayprime/1000)^2+sigmarprime^2)
	endif
	if(numpnts(Kvalues)>0)
		xvalue[][]=(q*2+1)*Kvalues[p]^2/(4+2*Kvalues[p]^2)
		FnK[][]=(((q*2+1)*Kvalues[p]/(1+Kvalues[p]^2/2)) * (Besselj(((q*2+1)-1)/2,xvalue[p][q])-Besselj(((q*2+1)+1)/2,xvalue[p][q])))^2
		d2Fnd2phi=1.744e14*(numberofperiods*srenergy)^2*ringcurrent*FnK
		d2Pnd2phi=d2Fnd2phi*energies*1.602e-19
		Fn[][]=1.431e14*numberofperiods*ringcurrent*(1+Kvalues[p]^2/2)*FnK[p][q]/(q*2+1)
		Pn=Fn*energies*1.602e-19
		d2Fndthetadpsi=Fn/(2*pi*sigmaxprime_w*sigmayprime_w)
		d2Pndthetadpsi=Pn/(2*pi*sigmaxprime_w*sigmayprime_w)
		Bn=Fn/(4*pi^2*sigmax_w*sigmay_w*sigmaxprime_w*sigmayprime_w)
	endif
End