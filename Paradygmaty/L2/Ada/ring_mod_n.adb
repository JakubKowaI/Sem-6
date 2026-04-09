with Ada.Integer_Text_IO;

package body Ring_Mod_N is

    function Modulo(X : Integer) return Integer;

    function NWD(A, B: Integer) return Integer is
        AA : Integer := A;
        BB : Integer := B;
        T: Integer;
    begin
        while BB /= 0 loop
            T := BB;
            BB := AA mod BB;
            AA := T;
        end loop;
        return AA;
    end NWD;

    function Euklides(A, B : Integer; X, Y : in out Integer) return Integer is
        X1, Y1 : Integer := 0;
        D : Integer;
    begin
        if B = 0 then
            X := 1;
            Y := 0;
            return A;
        else
            D := Euklides(B, A mod B, X1, Y1);
            X := Y1;
            Y := X1 - (A / B) * Y1;
            return D;
        end if;
    end Euklides;

    function Inverse(B : Ring) return Ring is
        X, Y, GCD : Integer := 0;
        R : Ring;
    begin
        GCD := Euklides(B.Val, N, X, Y);
        if GCD /= 1 then
            raise Constraint_Error with "Brak odwrotności w pierścieniu"; 
        end if;

        R.Val := Modulo(X);
        return R;
    end Inverse;

    function Modulo(X : Integer) return Integer is
    begin
        return (X mod N + N) mod N;
    end Modulo;

    function "+" (A, B : Ring) return Ring is
        R : Ring;
    begin
        R.Val := Modulo(A.Val + B.Val);
        return R;
    end "+";

    function "-" (A, B : Ring) return Ring is
        R : Ring;
    begin
        R.Val := Modulo(A.Val - B.Val);
        return R;
    end "-";

    function "*" (A, B : Ring) return Ring is
        R : Ring;
    begin
        R.Val := Modulo(A.Val * B.Val);
        return R;
    end "*";

    function "/" (A, B : Ring) return Ring is
    begin
        return A * Inverse(B);
    end "/";

    function "=" (A, B : Ring) return Boolean is
    begin
        return A.Val = B.Val;
    end "=";

    function "<=" (A, B : Ring) return Boolean is
    begin
        return A.Val <= B.Val;
    end "<=";

    function ">=" (A, B : Ring) return Boolean is
    begin
        return A.Val >= B.Val;
    end ">=";

    function "<" (A, B : Ring) return Boolean is
    begin
        return A.Val < B.Val;
    end "<";

    function ">" (A, B : Ring) return Boolean is
    begin
        return A.Val > B.Val;
    end ">";

    function To_Integer(A : Ring) return Integer is
    begin
        return A.Val;
    end To_Integer;

    function From_Integer(X : Integer) return Ring is
        R : Ring;
    begin
        R.Val := Modulo(X);
        return R;
    end From_Integer;

    -- I/O: proste Put/Get korzystające z Integer.Text_IO
    procedure Put(Item : Ring) is
    begin
        Ada.Integer_Text_IO.Put(Item.Val);
    end Put;

    procedure Get(Item : out Ring) is
        V : Integer;
    begin
        Ada.Integer_Text_IO.Get(V);
        Item.Val := Modulo(V);
    end Get;

end Ring_Mod_N;