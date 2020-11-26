package utils is 
    procedure clock(
        signal C: OUT BIT ;
        HT, LT  : TIME
    );
    function convert(N, L: NATURAL) return BIT_VECTOR;
    function convert(B: BIT_VECTOR) return NATURAL;
end utils;

package body utils is

    -- clock
    procedure clock(signal C: out Bit; HT,LT: Time) is
    begin
        loop
            C <='1' after LT, '0' after LT + HT;
            wait for LT + HT;
        end loop;	 		
    end;
  
    -- devuelve un bit_vector de longitud L con el valor N en binario
    function convert(N,L:Natural) return Bit_Vector is
        variable Temp: Bit_Vector(L - 1 downto 0);				
        variable Value:Natural:= N;						
    begin
        for i in Temp'Right to Temp'Left loop
            Temp(i):=Bit'Val(Value mod 2);
            Value:=Value / 2;
        end loop;
        return Temp;
    end;

    -- recibe un bit_vector B y devuelve un natural con el valor decimal de B.
    function Convert(B:Bit_Vector) return Natural is
        variable Temp: Bit_Vector(B'Length-1 downto 0):=B;				
        variable Value:Natural:= 0;						
    begin
        for i in Temp'Right to Temp'Left loop
            if Temp(i) = '1' then
                Value:=Value + (2**i);
            end if;			
        end loop;
    return Value;
    end;

end Utils;