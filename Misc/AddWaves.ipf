#pragma rtGlobals=1		// Use modern global access method.

Function AddWaves(xsrc1,ysrc1,xsrc2,ysrc2,withcorrelation)
	String xsrc1,ysrc1,xsrc2,ysrc2
	Variable withcorrelation
	if(!WaveExists($xsrc1) || !WaveExists($ysrc1) || !WaveExists($xsrc2) || !WaveExists($ysrc2))
		Return 1
	endif
	Wave xw1=$xsrc1
	Wave yw1=$ysrc1
	Wave xw2=$xsrc2
	Wave yw2=$ysrc2
	Variable minstep,i
	minstep=xw1[1]-xw1[0]
	for(i=1;i<numpnts(xw1)-2;i+=1)
		if(xw1[i+1]-xw1[i]<minstep)
			minstep=xw1[i+1]-xw1[i]
		endif
	endfor
	for(i=0;i<numpnts(xw2)-2;i+=1)
		if(xw2[i+1]-xw2[i]<minstep)
			minstep=xw2[i+1]-xw2[i]
		endif
	endfor
	if(minstep<0.01)
		minstep=.01
	endif
	Variable xmin=min(xw1[0],xw2[0])
	Variable xmax=max(xw1[numpnts(xw1)-1],xw2[numpnts(xw2)-1])
	String xdf=RemoveListItem(ItemsInList(xsrc1,":")-1,xsrc1,":")
	make/D/O/n=((xmax-xmin)/minstep) $(xdf+"tmpx")
	wave tmpx=$(xdf+"tmpx")
	for(i=0;i<numpnts(tmpx);i+=1)
		tmpx[i]=xmin+i*minstep
	endfor
	duplicate/O tmpx $(xdf+"tmpxas")
	wave tmpxas=$(xdf+"tmpxas")
	for(i=0;i<numpnts(tmpx);i+=1)
		tmpxas[i]=interp(tmpx[i],xw1,yw1)+interp(tmpx[i],xw2,yw2)
	endfor
	Return 0
End