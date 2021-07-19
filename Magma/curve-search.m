p := 2^251-9;
F := GF(p);
Z := IntegerRing();

function getSecParams(A)

	E := EllipticCurve([F!0,F!A,F!0,F!1,F!0]);
        n := #E; nT := 2*(p+1)-n;
	ell := n; h := 1;
	while (Z!ell mod 2) eq 0 do ell := ell/2; h := h*2; end while;
	while (Z!ell mod 3) eq 0 do ell := ell/3; h := h*3; end while;
	ellT := nT; hT := 1;
	while (Z!ellT mod 2) eq 0 do ellT := ellT/2; hT := hT*2; end while;
	while (Z!ellT mod 3) eq 0 do ellT := ellT/3; hT := hT*3; end while;
        if ( (h le 32) and (hT le 32) and (IsPrime(Z!ell)) and (IsPrime(Z!ellT)) ) then
                print "Success";
                print "A = ", A;
                print "E = ", E;
                print "ordE = ", n;
                print "maxSubSz = ", ell;
		print "log(ell) = ", Log(2,ell);
                print "h = ", h;
                print "ordTwist = ", nT;
                print "maxSubSzT = " , ellT;
		print "log(ellT) = ", Log(2,ellT);
                print "hT = ", hT;
		return 1;
        end if;
	return 0; 
end function;

// start main search

for alpha := lo to hi do	
	A := F!(4*alpha-2);
	flg := getSecParams(A); 
	if (flg eq 1) then
		print "(A+2)/4 = ", alpha;
	end if;
end for;

print "Completed";
