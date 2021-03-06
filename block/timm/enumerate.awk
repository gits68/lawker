#.H1 Functional Enumeration in Gawk 3.7
#.H2 Synopsus
#.P all(fun,array [,max]
#.P collect(fun,array1,array2  [,max])
#.P select(fun,array1,array2  [,max])
#.P reject(fun,array1,array2 [,max])
#.P detect(fun,array [,max])
#.P inject(fun,array,carry [,max])
#.H2 Description
#.P
#    A new feature in Gawk 3.7 is <em>indirect functions</em>.
#    This allows the function name to be a variable, passed
#    as an argument to an array, and called using the syntax
#.PRE
#@fun(arg1,arg2,...)
#./PRE
#.P
#    This enables a new kind of funcational programming style
#    in Gawk. For example, generic enumeration patterns
#    can be coded once, then called many different ways
#    with different function names passed as arguments.
#.P
#    For example, here are some standard
#    enumeration functions:

#.DL
#.DT all(fun,array [,max]
#.DD
#     Applies the function <em>fun</em> to all items in the <em>array</em>.
#     If called with the <em>max</em>
#     argument, then they are iterated in the order i=1&nbsp;..&nbsp;<em>max</em>,
#     otherwise we use <em>for(i&nbsp;in&nbsp;a)</em>.
#.DT collect(fun,array1,array2  [,max])
#.DD
#    Applies <em>fun</em> to each item in <em>array1</em> and collects the
#    results in <em>array2</em>.
#.DT select(fun,array1,array2  [,max])
#.DD
#    Find all the items in <em>array1</em> that satisfies <em>fun</em> and
#    add them to <em>array2</em>.
#.DT reject(fun,array1,array2 [,max])
#.DD
#    Find all the items in <em>array1</em> that do <em>not</em> satisfy <em>fun</em> and
#    add them to <em>array2</em>.
#.DT detect(fun,array [,max])
#.DD
#    Return the first item found in  <em>array</em> that satisfies <em>fun</em>.
#    If no such item is found, then return the magic global value <em>Fail</em>.
#.DT inject(fun,array,carry [,max])
#.DD
#    (This one is a little tricky.)
#    The result of applying <em>fun</em> to each item in <em>array</em>
#    is carried into the  processing of the next item. Initially, the 
#    carried value is <em>carry</em>. This function returns the final <em>carry</em>.
#./DL

function all (fun,a,max,   i) {
	if (max) 
		for(i=1;i<=max;i++) @fun(a[i]) 
	else  
		for(i in a) @fun(a[i])
}
function collect (fun,a,b,max,   i) {
	if (max)
		for(i=1;i<=max;i++) b[i]= @fun(a[i])
	else
		for(i in a) b[i]= @fun(a[i])
}
function select (fun,a,b,max,   i) {
	if (max)
		for(i=1;i<=max;i++) {
			if (@fun(a[i])) b[i]= a[i] }
	else
		for(i in a) {
			if (@fun(a[i])) b[i]= a[i] }
}
function reject (fun,a,b,max,   i) {
	if (max)
		for(i=1;i<=max;i++) {
			if (! @fun(a[i])) b[i]= a[i] }
	else
		for(i in a) {
			if (! @fun(a[i])) b[i]= a[i] }
}
BEGIN {Fail="someUnLIKELYSymbol"}
function detect (fun,a,max,   i) {
	if (max)
		for(i=1;i<=max;i++) {
			if (@fun(a[i])) return a[i] }
	else	
		for(i in a) {
			if (@fun(a[i])) return a[i] }
	return Fail
}
function inject (fun,a,carry,max,   i) {
	if (max)
		for(i=1;i<=max;i++)
			 carry = @fun(a[i],carry) 
	else
		for(i in a)
			 carry = @fun(a[i],carry) 
	return carry
}
