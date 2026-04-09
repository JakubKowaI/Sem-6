with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ring_Mod_N;

procedure Test is
    package R7 is new Ring_Mod_N(N => 7);
    package R4 is new Ring_Mod_N(N => 4);
    package R5 is new Ring_Mod_N(N => 5);
    use type R7.Ring;
    use type R4.Ring;
    use type R5.Ring;

    failures : Integer := 0;
    A7, B7, S7, Sub7, M7, D7, C7 : R7.Ring;
    X4, Y4, R4v : R4.Ring;
    P5, Z5, R5v : R5.Ring;
begin
    -- Test arithmetic in mod 7 (prime modulus -> every nonzero has inverse)
    begin
        A7 := R7.From_Integer(3);
        B7 := R7.From_Integer(2);

        S7 := A7 + B7; -- 3+5=8 mod7 =1
        if R7.To_Integer(S7) /= 1 then
            Put_Line("FAIL add: expected 1 got " & Integer'Image(R7.To_Integer(S7)));
            failures := failures + 1;
        end if;

        Sub7 := A7 - B7; -- 3-5 = -2 mod7 =5
        if R7.To_Integer(Sub7) /= 5 then
            Put_Line("FAIL sub: expected 5 got " & Integer'Image(R7.To_Integer(Sub7)));
            failures := failures + 1;
        end if;

        M7 := A7 * B7; -- 3*5=15 mod7 =1
        if R7.To_Integer(M7) /= 1 then
            Put_Line("FAIL mul: expected 1 got " & Integer'Image(R7.To_Integer(M7)));
            failures := failures + 1;
        end if;

        -- division: inv(5) mod7 = 3 because 5*3=15=1 mod7; 3/5=3*3=9 mod7=2
        D7 := A7 / B7;
        if R7.To_Integer(D7) /= 2 then
            Put_Line("FAIL div: expected 2 got " & Integer'Image(R7.To_Integer(D7)));
            failures := failures + 1;
        end if;

        -- compound-assignment equivalents
        C7 := R7.From_Integer(2);
        C7 := C7 + R7.From_Integer(6); -- 2+6=8 mod7=1
        if R7.To_Integer(C7) /= 1 then
            Put_Line("FAIL += got " & Integer'Image(R7.To_Integer(C7)));
            failures := failures + 1;
        end if;

        C7 := R7.From_Integer(3);
        C7 := C7 - R7.From_Integer(5); -- 3-5=-2 mod7=5
        if R7.To_Integer(C7) /= 5 then
            Put_Line("FAIL -= got " & Integer'Image(R7.To_Integer(C7)));
            failures := failures + 1;
        end if;

        C7 := R7.From_Integer(4);
        C7 := C7 * R7.From_Integer(2); -- 8 mod7 =1
        if R7.To_Integer(C7) /= 1 then
            Put_Line("FAIL *= got " & Integer'Image(R7.To_Integer(C7)));
            failures := failures + 1;
        end if;
    exception
        when others =>
            Put_Line("Unexpected exception in invertible tests");
            failures := failures + 1;
    end;

    -- Test non-invertible division (mod 4, element 2 has no inverse)
    begin
        X4 := R4.From_Integer(2);
        Y4 := R4.From_Integer(2);
        begin
            R4v := X4 / Y4;
            Put_Line("FAIL expected exception for non-invertible division");
            failures := failures + 1;
        exception
            when Constraint_Error => null; -- expected
            when others =>
                Put_Line("FAIL unexpected exception type for non-invertible case");
                failures := failures + 1;
        end;
    exception
        when others =>
            Put_Line("Unexpected failure in non-invertible test");
            failures := failures + 1;
    end;

    -- Test zero division (b == 0)
    begin
        P5 := R5.From_Integer(3);
        Z5 := R5.From_Integer(0);
        begin
            R5v := P5 / Z5;
            Put_Line("FAIL expected exception for division by zero");
            failures := failures + 1;
        exception
            when Constraint_Error => null; -- expected
            when others =>
                Put_Line("FAIL unexpected exception type for zero division");
                failures := failures + 1;
        end;
    exception
        when others =>
            Put_Line("Unexpected failure in zero-division test");
            failures := failures + 1;
    end;

    if failures = 0 then
        Put_Line("ALL TESTS PASSED");
    else
        Put_Line(Integer'Image(failures) & " TEST(S) FAILED");
    end if;
end Test;