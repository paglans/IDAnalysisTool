#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function calcbeta(energy,m,n0,theta)
	Variable energy,m,n0,theta
	// energy in eV
	// m is order (inside order is positive)
	// n0 is groove density
	// theta in degrees (alpha-beta = 2*theta)
	return (asin((m*en2lambda(energy)*(1e-9)*n0*1000)/(2*cos(theta*pi/180)))-theta*pi/180)*180/pi	// degrees
End

Function calcalpha(energy,m,n0,theta)
	Variable energy,m,n0,theta
	// energy in eV
	// m is order (inside order is positive)
	// n0 is groove density
	// theta in degrees (alpha-beta = 2*theta)
	return 2*theta+calcbeta(energy,m,n0,theta)							// degrees
End

Function horizonenergy(n0,theta)
	Variable n0,theta
	// n0 is groove density
	// theta in degrees (alpha-beta = 2*theta)
	Return lambda2en(2*(cos(theta*pi/180)^2)/(n0*1e-6))				// energy in eV
End

Function dlambdaSlit(slit,n0,angle,m,armlength)
	Variable slit,n0,angle,m,armlength
	// slit in micormeters
	// n0 in grooves / mm
	// angle in degrees
	// m: order
	// armlength in meters
	Return abs(slit*(1e-6)*cos(angle*pi/180)/(n0*1000*m*armlength))		// meters
End

Function dESlitf(energy,slit,n0,m,armlength,theta)
	Variable energy,slit,n0,m,armlength,theta
	Variable echarge=1.602176e-19
	Variable hPlanck=6.62606876e-34
	Variable cspeed=2.99792458e8
//	Variable theta=twotheta/2
	Return abs((hplanck*cspeed/echarge)*dlambdaSlit(slit,n0,calcbeta(energy,m,n0,theta),m,armlength)/((en2lambda(energy)*1e-9)^2))
End


Function acceptance(dist,length,angle)
	Variable dist,length,angle
	Variable acceptance
	acceptance=(atan(length/2*sin(angle*pi/180)/(dist+length/2*cos(angle*pi/180))))		//lower half
//	acceptance+=(atan(length/2*sin(angle*pi/180)/(dist-length/2*cos(angle*pi/180))))	//upper half
	acceptance+=(asin(length/2*cos(pi/2-angle*pi/180))/(dist))
	Return acceptance															//rad
End

//Function illumination(dist,acceptance,angle)
//	Variable dist,acceptance,angle
//	Variable illumination
//	illumination=2*dist*tan(acceptance/2)/sin(angle*pi/180)
//	Return illumination
//End

Function illumination(dist,acceptance,angle,sourcesize)
	Variable dist,acceptance,angle,sourcesize
	Variable dist2point=dist+sourcesize/2/tan(acceptance/2)		// beamsize translated to a point source
	Return dist2point*sin(acceptance/2)/sin(pi-acceptance/2-angle*pi/180)+dist2point*sin(acceptance/2)/sin(angle*pi/180-acceptance/2)
End

Function illumination2(dist,sigmapr,angle,sourcesize)
	Variable dist,sigmapr,angle,sourcesize
	Variable dist2point=dist+sourcesize/2/tan(sigmapr/2)		// beamsize translated to a point source
	Variable tmp=dist2point*tan(sigmapr/2)*sin(pi/2-sigmapr/2)/sin(angle*pi/180+sigmapr/2)
	Variable tmp2=dist2point*tan(sigmapr/2)*sin(pi/2-sigmapr/2)/sin(angle*pi/180-sigmapr/2)
	Return dist2point*tan(sigmapr/2)*sin(pi/2-sigmapr/2)/sin(angle*pi/180+sigmapr/2)+dist2point*tan(sigmapr/2)*sin(pi/2-sigmapr/2)/sin(angle*pi/180-sigmapr/2)
End

Function illumination3(dist,sigmapr,angle,sigma)
	Variable dist,sigmapr,angle,sigma
	Variable sigmafinal=sqrt(sigma^2+(2*dist*tan(sigmapr/2))^2)
	Variable L1=sin(pi/2-sigmapr/2)/sin(angle*pi/180+sigmapr/2)*sigmafinal/2
	Variable L2=sin(pi/2+sigmapr/2)/sin(angle*pi/180-sigmapr/2)*sigmafinal/2
	Variable ill=L1+L2
	Return ill
End

Function NumAperturef(grimagepoint,betav,gratingill)
	Variable grimagepoint,betav,gratingill
	// dist in m
	// mirrangle in degrees
	// mirrillumination in m
//	Return sin(atan(gratingill/2*cos(betav*pi/180)/grimagepoint))				// (NA)
	Variable acc
	acc=(atan(gratingill/2*sin(betav*pi/180)/(grimagepoint+gratingill/2*cos(betav*pi/180))))	//lower half
	acc+=(atan(gratingill/2*sin(betav*pi/180)/(grimagepoint-gratingill/2*cos(betav*pi/180))))	//upper half
	Return sin(acc/2)
End

Function calcFocus(R)
	Variable R
	Return R/2
End

Function calcGlancingFocus(R,angle)
	Variable R,angle
	Return R*sin(angle*pi/180)/2
End

Function CalcImagePoint(f,S)
	Variable f,S
	Return S*f/(S-f)
End

Function CalcFocus_ImageSource(ImagePoint,SourcePoint)
	Variable ImagePoint,SourcePoint
	Return ImagePoint*SourcePoint/(SourcePoint+ImagePoint)
End

Function SphMIrrorRadius(focus,angle)
	Variable focus,angle
	Return 2*focus/sin(angle)
End

Function CalcCompoundImagePoint(f1,S1,f2,d)
	Variable f1,S1,f2,d
	Return (d-S1)*f2/(d-S1-f2)
End

Function TfuncPlane(angle,dist)
	Variable angle,dist
	Return ((cos(angle))^2)/dist
End

Function SfuncPlane(dist)
	Variable dist
	Return 1/dist
End

Function C100(angle)
	Variable angle
	Return -sin(angle)
End

Function C200(angle,dist)
	Variable angle,dist
	Return TfuncPlane(angle,dist)/2
End

Function C300Plane(angle,dist)
	Variable angle,dist
	Return TfuncPlane(angle,dist)*sin(angle)/(2*dist)
End

Function C400Plane(angle,dist)
	Variable angle,dist
	Return TfuncPlane(angle,dist)*sin(angle)^2/(2*dist^2)-TfuncPlane(angle,dist)^2/(8*dist)
End

Function F100(anglea,angleb,n0,order,lambda)
	Variable anglea,angleb,n0,order,lambda
	Return C100(anglea)+C100(angleb)+n0*order*lambda
End

Function F200(anglea,dista,angleb,distb,n0,order,lambda,g1)
	Variable anglea,dista,angleb,distb,n0,order,lambda,g1
	Return C200(anglea,dista)+C200(angleb,distb)+n0*order*lambda*(-g1)/2
End

Function F300Plane(anglea,dista,angleb,distb,n0,order,lambda,g1,g2)
	Variable anglea,dista,angleb,distb,n0,order,lambda,g1,g2
	Return C300Plane(anglea,dista)+C300Plane(angleb,distb)+n0*order*lambda*(g1^2-g2)/3
End

Function F400Plane(anglea,dista,angleb,distb,n0,order,lambda,g1,g2,g3)
	Variable anglea,dista,angleb,distb,n0,order,lambda,g1,g2,g3
	Return C400Plane(anglea,dista)+C400Plane(angleb,distb)+n0*order*lambda*((-g1)^3+2*g1*g2-g3)/4
End

Function deltay100(anglea,angleb,distb,n0,order,lambda)
	Variable anglea,angleb,distb,n0,order,lambda
	Return distb/cos(angleb)*F100(anglea,angleb,n0,order,lambda)
End

Function deltay200(anglea,dista,angleb,distb,n0,order,lambda,w,g1)
	Variable anglea,dista,angleb,distb,n0,order,lambda,w,g1
	Return distb/cos(angleb)*F200(anglea,dista,angleb,distb,n0,order,lambda,g1)*2*w
End

Function deltay300Plane(anglea,dista,angleb,distb,n0,order,lambda,w,g1,g2)
	Variable anglea,dista,angleb,distb,n0,order,lambda,w,g1,g2
	Return distb/cos(angleb)*F300Plane(anglea,dista,angleb,distb,n0,order,lambda,g1,g2)*3*w^2
End

Function deltay400Plane(anglea,dista,angleb,distb,n0,order,lambda,w,g1,g2,g3)
	Variable anglea,dista,angleb,distb,n0,order,lambda,w,g1,g2,g3
	Return distb/cos(angleb)*F400Plane(anglea,dista,angleb,distb,n0,order,lambda,g1,g2,g3)*4*w^3
End

Function VLS_g1(rin,anglealpha,rout,anglebeta,n0,order,lambda)
	Variable rin,anglealpha,rout,anglebeta,n0,order,lambda
	Return (TfuncPlane(anglealpha,rin)+TfuncPlane(anglebeta,rout))/(n0*order*lambda)
End