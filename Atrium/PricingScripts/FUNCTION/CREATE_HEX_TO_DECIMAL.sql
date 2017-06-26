
  CREATE OR REPLACE EDITIONABLE FUNCTION "MSSQL"."HEX_TO_DECIMAL" 

( p_hex_str in varchar2 ) return number

is

v_dec number;

v_hex varchar2(16) := '0123456789ABCDEF';

begin

v_dec := 0;

for indx in 1 .. length(p_hex_str)

loop

v_dec := v_dec * 16 + instr(v_hex,upper(substr(p_hex_str,indx,1)))-1;

end loop;

return v_dec;

end hex_to_decimal;