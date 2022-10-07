#pragma rtGlobals=1		// Use modern global access method.

// Written as a model recursive function in a language that does not support recursion

Function myFactorial(n,result)
	Variable n,result
	if(n==0)
		return result
	else
		result=compute(n,result)
	endif
	return result
End

Function compute(m,result)
	Variable m,result
	return m*myFactorial(m-1,result)
End