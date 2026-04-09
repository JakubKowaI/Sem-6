with Interfaces;

generic
    N : Positive;
package Ring_Mod_N is

    type Ring is private;

    function "=" (A, B : Ring) return Boolean;
    function "<=" (A, B : Ring) return Boolean;
    function ">=" (A, B : Ring) return Boolean;
    function "<" (A, B : Ring) return Boolean;
    function ">" (A, B : Ring) return Boolean;

    function "+" (A, B : Ring) return Ring;
    function "-" (A, B : Ring) return Ring;
    function "*" (A, B : Ring) return Ring;
    function "/" (A, B : Ring) return Ring;

    function To_Integer(A : Ring) return Integer;

    -- konwersja/fabryka
    function From_Integer(X : Integer) return Ring;

    -- proste procedury I/O
    procedure Put(Item : Ring);
    procedure Get(Item : out Ring);

private
    type Ring is
        record
            Val : Integer;
        end record;
end Ring_Mod_N;