----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:25:29 03/24/2016 
-- Design Name: 
-- Module Name:    Input - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Input is
	generic(width: integer:=64);
   Port ( clock : in  STD_LOGIC;
          reset : in  STD_LOGIC;
			 clause : in  STD_LOGIC_VECTOR((width-1) downto 0);
			 load : in STD_LOGIC;
          SAT : inout  STD_LOGIC;
			 output : inout STD_LOGIC_VECTOR((width-1) downto 0));
end Input;

architecture Behavioral of Input is
--type arrayOfClauses is array(999 downto 0) of STD_LOGIC_VECTOR((width+width-1) downto 0);
type arrayOfClauses is array(0 to 1024) of STD_LOGIC_VECTOR((width+width-1) downto 0);
type literalsEachClause is array(0 to 1024) of INTEGER;
type arrayOfLiterals is array(0 to 64) of literalsEachClause;
type threeDarrayOfClauses is array(0 to 64) of arrayOfClauses;
type arrayOfClauseCount is array(0 to 64) of INTEGER;
-- assumed 1000 clauses.
signal mem : arrayOfClauses;
signal xmem : arrayOfClauses;
signal literalsCopy : literalsEachClause;
--signal mem : threeDarrayOfClauses;
signal counter : STD_LOGIC_VECTOR((11) downto 0) := "000000000000";
signal count : INTEGER := 0;
signal terminate : STD_LOGIC := '0';
signal result : STD_LOGIC := '0';
--variable clauseValue : STD_LOGIC := '0';
signal x : STD_LOGIC := '0';
signal xint : INTEGER := 0;
signal xintChecker : INTEGER := 0;
begin
	process(clock, reset)
	--variable mem : threeDarrayOfClauses;
	--variable mem : arrayOfClauses;
	variable literalsInput : literalsEachClause;
	begin
		if(reset='1') then
			--output <= "0000";
			count <= 0;
			terminate <= '0';
			counter <= "000000000000";
			for I in 0 to (1024) loop
				--mem(I) <= "00000000";
				--mem(I) <= "0000000000000000";
				mem(I) <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
				--xmem(I) <= "00000000";
				--mem(I) := "00000000";
				literalsInput(I) := 0;
				literalsCopy(I) <= 0;
			end loop;
		elsif (rising_edge(clock)) then
			--temp <= to_integer(unsigned(counter));
			if(counter(0) = '0') then
				if(load = '1') then
					for I in 0 to (width-1) loop
						--mem(i)(2*width-1) <= clause(width-1); -- which element in array to update
						--mem(to_integer(unsigned(counter)))(I+width) <= clause(I);
						--mem(0)(I+width) <= clause(I);
						mem(count)(I+width) <= clause(I);
						--mem(count)(I+width) := clause(I);
						if(clause(I)='1') then
							literalsInput(count) := literalsInput(count) + 1;
						end if;
					end loop;
					literalsCopy(count) <= literalsInput(count);
					counter <= counter + "00000000001";
				elsif(count /= 0) then
					---------------
					terminate <= '1';
				end if;
			else
				if(load = '1') then
					for I in 0 to (width-1) loop
						--mem(i)(2*width-1) <= clause(width-1); -- which element in array to update
						--mem(to_integer(unsigned(counter)))(I) <= clause(I);
						--mem(0)(I) <= clause(I);
						mem(count)(I) <= clause(I);
						--mem(count)(I) := clause(I);
						if(clause(I)='1') then
							literalsInput(count) := literalsInput(count) + 1;
						end if;
					end loop;
					literalsCopy(count) <= literalsInput(count);
					count <= count + 1;
					counter <= counter + "00000000001";
				else
					---------------
				end if;
			end if;
			--counter <= counter + "000000001";
		end if;
	end process;
	
	process
	variable clauseValue : STD_LOGIC := '0';
	variable temp : STD_LOGIC := '0';
	variable arrayVariables : threeDarrayOfClauses;
	--variable arrayVariables : threeDarrayOfClauses := mem;
	--arrayVariables(0) := mem;
	variable literals : arrayOfLiterals;-- := literalsCopy;
	variable numberOfClauses : arrayOfClauseCount;
	variable randomDecision : arrayOfClauseCount;
	variable allAssignments : arrayOfClauseCount;
	variable numberOfAssignments : arrayOfClauseCount := (others => 0);
	variable indexRandomDecision : INTEGER := -1;
	variable indexAllAssignments : INTEGER := -1;
	variable flag : STD_LOGIC := '0';
	variable flagTerminate : STD_LOGIC := '0';
	variable number1 : INTEGER := 0;
	variable number2 : INTEGER := 0;
	variable momValue : INTEGER;
	variable newMomValue : INTEGER;
	variable xValue : INTEGER;
	variable f : arrayOfClauseCount := (others => 0);
	variable fdash : arrayOfClauseCount := (others => 0);
	variable minClauseCount : INTEGER;
	variable k : INTEGER := 5;
	variable answers : STD_LOGIC_VECTOR(0 to width) := (others => '1');
	begin
		flagTerminate := '0';
		flag := '0';
		arrayVariables(0) := mem;
		--xmem <= arrayVariables(0);
		numberOfClauses(0) := count;
		literals(0) := literalsCopy;
		f := (others => 0);
		fdash := (others => 0);
		wait until rising_edge(clock);
		if(terminate='1' and result='0') then
			--output <= "0000";
			--x <= '1';
			--x <= flagTerminate;
			--wait until rising_edge(clock);
			
			
			loop
			
				--flagTerminate := '0';
				
				--flagTerminate := '1';
				--x <= '1';
				if(numberOfClauses(indexAllAssignments + 1)=0) then
					result <= '1';
					SAT <= '1';
					output <= answers;
					exit;
				end if;
				
				
				
				
				for I in 0 to (count-1) loop
					if(literals(indexAllAssignments + 1)(I)=0) then
						if(indexRandomDecision=-1) then
							result <= '1';
							SAT <= '0';
							--xint <= 25;
							flagTerminate := '1';
							exit;
						else
							while (numberOfAssignments(randomDecision(indexRandomDecision)) = 2) loop
								numberOfAssignments(randomDecision(indexRandomDecision)) := 0;
								if(randomDecision(indexRandomDecision) = allAssignments(indexAllAssignments)) then
									indexRandomDecision := indexRandomDecision - 1;
									indexAllAssignments := indexAllAssignments - 1;
								else
									indexAllAssignments := indexAllAssignments - 1;
									while ( allAssignments(indexAllAssignments) /=  randomDecision(indexRandomDecision)) loop
										indexAllAssignments := indexAllAssignments - 1;
									end loop;
									indexRandomDecision := indexRandomDecision - 1;
									indexAllAssignments := indexAllAssignments - 1;
								end if;
								if(indexRandomDecision = -1) then
									result <= '1';
									SAT <= '0';
									--xint <= 50;
									flagTerminate := '1';
									exit;
								end if;
							end loop;
						end if;
						if(flagTerminate = '1') then
							--xint <= 50;
							--SAT <= '0';
							exit;
						end if;
						
						while ( allAssignments(indexAllAssignments) /=  randomDecision(indexRandomDecision)) loop
							indexAllAssignments := indexAllAssignments - 1;
						end loop;
						numberOfAssignments(randomDecision(indexRandomDecision)) := numberOfAssignments(randomDecision(indexRandomDecision)) + 1;
						answers(allAssignments(indexAllAssignments)) := '0';
						-- Check for a problem of any -1 mistake above this point.
						arrayVariables(indexAllAssignments + 1) := arrayVariables(indexAllAssignments);
						numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments);
						literals(indexAllAssignments + 1) := literals(indexAllAssignments);

						--number2 := (numberOfClauses(indexAllAssignments + 1)-1);
						number2 := count - 1;

						for P in 0 to number2 loop
							if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - randomDecision(indexRandomDecision))='1' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - randomDecision(indexRandomDecision))='0') then
								arrayVariables(indexAllAssignments + 1)(P)((width + width - 1 - randomDecision(indexRandomDecision))) := '0';
								literals(indexAllAssignments + 1)(P) := literals(indexAllAssignments + 1)(P) - 1;
							end if;
							if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - randomDecision(indexRandomDecision))='0' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - randomDecision(indexRandomDecision))='1') then
								for K in 0 to (width+width-1) loop
									arrayVariables(indexAllAssignments + 1)(P)(K) := '1';
								end loop;
								numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments + 1) - 1;
								literals(indexAllAssignments + 1)(P) := 64;
							end if;
						end loop;

						flagTerminate := '1';

						exit; -- takes care of changing indexAllAssignments numberOfClauses.
					end if;
				end loop;
				
				if(flagTerminate = '1') then
					--xint <= width;
					--xint <= numberOfClauses(indexAllAssignments + 1);
					--xint <= indexAllAssignments;
					--xint <= 50;
					xmem <= arrayVariables(indexAllAssignments + 1);
					--xint <= numberOfClauses(0);
					
					--if(indexRandomDecision = -1) then
						--result <= '1';
						--SAT <= '0';
						--exit;
					--end if;
					
					exit;
				end if;
				
				
				--number1 := (numberOfClauses(indexAllAssignments + 1)-1);
				--xint <= literals(indexAllAssignments + 1)(0);
				--x <= arrayVariables(indexAllAssignments + 1)(0)(2);
				--flagTerminate := '1';
				
				--if(flagTerminate = '1') then
					--xint <= width;
					--xint <= numberOfClauses(indexAllAssignments + 1);
					--xmem <= arrayVariables(1);
					--xint <= numberOfClauses(0);
					--exit;
				--end if;
				
				if(indexRandomDecision = -1) then
					xintChecker <= 100;
				else
					xintChecker <= indexRandomDecision;
				end if;
				
				for I in 0 to (count-1) loop
					number1 := I;
					--x <= arrayVariables(indexAllAssignments + 1)(0)(2);
					--flagTerminate := '1';
					--exit;
					if(literals(indexAllAssignments + 1)(I)=1) then
						--flagTerminate := '1';
						--exit;
						for J in 0 to (width+width-1) loop
							if(arrayVariables(indexAllAssignments + 1)(I)(J) = '1') then
								--flagTerminate := '1';
								--exit;
								if(J < width) then
									indexAllAssignments := indexAllAssignments + 1;
									--if(indexAllAssignments >= 8) then
										--xintChecker <= 13;
										--flagTerminate := '1';
										--exit;
									--end if;

									allAssignments(indexAllAssignments) := (width - 1 - J);
									answers(allAssignments(indexAllAssignments)) := '0';


									--numberOfAssignments(randomDecision(indexRandomDecision)) := numberOfAssignments(randomDecision(indexRandomDecision)) + 1;
									arrayVariables(indexAllAssignments + 1) := arrayVariables(indexAllAssignments);
									numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments);
									literals(indexAllAssignments + 1) := literals(indexAllAssignments);
									
									
									--number2 := (numberOfClauses(indexAllAssignments + 1)-1);
									number2 := 999;
									--xint <= number2;
									--xint <= literals(indexAllAssignments + 1)(0);
									--flagTerminate := '1';
									--exit;

									for P in 0 to (count-1) loop
										--xint <= number2;
										--flagTerminate := '1';
										--exit;
										if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - allAssignments(indexAllAssignments))='1' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - allAssignments(indexAllAssignments))='0') then
											arrayVariables(indexAllAssignments + 1)(P)((width + width - 1 - allAssignments(indexAllAssignments))) := '0';
											literals(indexAllAssignments + 1)(P) := literals(indexAllAssignments + 1)(P) - 1;
										end if;
										if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - allAssignments(indexAllAssignments))='0' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - allAssignments(indexAllAssignments))='1') then
											for K in 0 to (width+width-1) loop
												arrayVariables(indexAllAssignments + 1)(P)(K) := '1';
											end loop;
											numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments + 1) - 1;
											literals(indexAllAssignments + 1)(P) := 64;
										end if;
									end loop;

								else
									--flagTerminate := '1';
									--exit;
									indexAllAssignments := indexAllAssignments + 1;
									--if(indexAllAssignments >= 8) then
										--xintChecker <= 14;
										--flagTerminate := '1';
										--exit;
									--end if;
									allAssignments(indexAllAssignments) := (width + width - 1 - J);
									answers(allAssignments(indexAllAssignments)) := '1';

									--numberOfAssignments(randomDecision(indexRandomDecision)) := numberOfAssignments(randomDecision(indexRandomDecision)) + 1;
									arrayVariables(indexAllAssignments + 1) := arrayVariables(indexAllAssignments);
									numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments);
									literals(indexAllAssignments + 1) := literals(indexAllAssignments);
									--xint <= numberOfClauses(indexAllAssignments + 1);
									
									--number2 := (numberOfClauses(indexAllAssignments + 1)-1);
									number2 := 999;
									--xint <= number2;
									--flagTerminate := '1';
									--exit;

									for P in 0 to (count-1) loop
										if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - allAssignments(indexAllAssignments))='0' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - allAssignments(indexAllAssignments))='1') then
											arrayVariables(indexAllAssignments + 1)(P)(width - 1 - allAssignments(indexAllAssignments)) := '0';
											literals(indexAllAssignments + 1)(P) := literals(indexAllAssignments + 1)(P) - 1;
										end if;
										if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - allAssignments(indexAllAssignments))='1' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - allAssignments(indexAllAssignments))='0') then
											--flagTerminate := '1';
											--exit;
											for K in 0 to (width+width-1) loop
												arrayVariables(indexAllAssignments + 1)(P)(K) := '1';
											end loop;
											numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments + 1) - 1;
											literals(indexAllAssignments + 1)(P) := 64;
										end if;
									end loop;

								end if;
								exit;
							end if;
						end loop;

						--flagTerminate := '1';

						exit;
					else -- Dont care
						
					end if;
				end loop;
				
				
				--if(number1 = (count-1)) then
					--x <= '1';
					--flagTerminate := '1';
					--exit;
				--end if;
				
				--x <= flagTerminate;

				--if(flagTerminate = '1') then
					--xint <= width;
					--xint <= numberOfClauses(indexAllAssignments + 1);
					--xint <= indexAllAssignments;
					--xmem <= arrayVariables(indexAllAssignments + 1);
					--xint <= numberOfClauses(0);
					--if(indexRandomDecision = -1) then
						--result <= '1';
						--SAT <= '0';
						--exit;
					--end if;
					--exit;
				--end if;
				
				--xintChecker <= literals(indexAllAssignments + 1)(0);
				--xintChecker <= literalsCopy(0);
				minClauseCount := literals(indexAllAssignments + 1)(0); -- Don't consider 11111111
				for I in 1 to (count - 1) loop
					if(literals(indexAllAssignments + 1)(I) < minClauseCount) then
						minClauseCount := literals(indexAllAssignments + 1)(i);
					end if;
				end loop;
				--xint <= minClauseCount;
				--xintChecker <= minClauseCount;
				--exit;
				f := (others => 0);
				fdash := (others => 0);
				for I in 0 to (count - 1) loop
					if(literals(indexAllAssignments + 1)(I) = minClauseCount) then
						for P in 0 to (width -1) loop
							if(arrayVariables(indexAllAssignments + 1)(I)(P)='0' and arrayVariables(indexAllAssignments + 1)(I)(P + width)='1') then
								f(width - 1 - P) := f(width - 1 - P) + 1;
							end if;
							if(arrayVariables(indexAllAssignments + 1)(I)(P)='1' and arrayVariables(indexAllAssignments + 1)(I)(P + width)='0') then
								fdash(width - 1 - P) := fdash(width - 1 - P) + 1;
							end if;
							--exit;
						end loop;
					end if;
				end loop;
				--xint <= f(1);
				--exit;
				--xintChecker <= f(63);
				xValue := -1;
				for I in 0 to (width-1) loop
					momValue := (((f(I) + fdash(I))*(2048))+(f(I)*fdash(I))); -- Not synthesisable
					if(momValue /= 0) then
						--xintChecker <= I;
						xValue := I;
						exit;
					end if;
				end loop;
				--momValue := (((f(0) + fdash(0))*(2*2*2*2*2))+(f(0)*fdash(0))); -- Not synthesisable
				--newMomValue;
				--xint <= momValue;
				--exit;
				--xValue := -1;
				for I in 0 to (width-1) loop
					newMomValue := (((f(I) + fdash(I))*(2048))+(f(I)*fdash(I)));
					if(newMomValue = 0) then
					
					else
						--xint <= newMomValue;
						--exit;
						if(newMomValue > momValue) then
							momValue := newMomValue;
							xValue := I;
						end if;
					end if;
				end loop;
				xint <= xValue;
				--exit;
				
				if(xValue = -1) then
					xint <= 65;
					--xmem <= arrayVariables(indexAllAssignments);
					if(indexAllAssignments = -1) then
						--xint <= 2;
					else
						--xint <= 3;
					end if;
					exit;
				else
					--xint <= 4;
					--xint <= xValue;
					indexAllAssignments := indexAllAssignments + 1;
					indexRandomDecision := indexRandomDecision + 1;
					--if(indexAllAssignments >= 8) then
						--xint <= xValue;
						--xintChecker <= 15;
						--flagTerminate := '1';
						--exit;
					--end if;
					randomDecision(indexRandomDecision) := xValue;
					allAssignments(indexAllAssignments) := xValue;
					
					answers(xValue) := '1';
					
					numberOfAssignments(randomDecision(indexRandomDecision)) := numberOfAssignments(randomDecision(indexRandomDecision)) + 1;
					arrayVariables(indexAllAssignments + 1) := arrayVariables(indexAllAssignments);
					numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments);
					literals(indexAllAssignments + 1) := literals(indexAllAssignments);

					number2 := (numberOfClauses(indexAllAssignments + 1)-1);

					for P in 0 to (count-1) loop
						--xint <= numberOfClauses(indexAllAssignments);
						--flagTerminate := '1';
						--exit;
						if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - randomDecision(indexRandomDecision))='0' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - randomDecision(indexRandomDecision))='1') then
							arrayVariables(indexAllAssignments + 1)(P)(width - 1 - randomDecision(indexRandomDecision)) := '0';
							literals(indexAllAssignments + 1)(P) := literals(indexAllAssignments + 1)(P) - 1;
						end if;
						if(arrayVariables(indexAllAssignments + 1)(P)(width + width - 1 - randomDecision(indexRandomDecision))='1' and arrayVariables(indexAllAssignments + 1)(P)(width - 1 - randomDecision(indexRandomDecision))='0') then
							--x <= '1';
							for K in 0 to (width+width-1) loop
								arrayVariables(indexAllAssignments + 1)(P)(K) := '1';
							end loop;
							numberOfClauses(indexAllAssignments + 1) := numberOfClauses(indexAllAssignments + 1) - 1;
							literals(indexAllAssignments + 1)(P) := 64;
						end if;
						--exit;
					end loop;
					x <= '1';

					if(indexRandomDecision = -1) then
						result <= '1';
						SAT <= '0';
						flagTerminate := '1';
						xint <= 100;
						exit;
					end if;
				end if;
				
			end loop;
			
			
		else
			if(result='1') then
				--output <= "11111111";
				--output <= "1111";
			end if;
			if(terminate='0') then
				--output <= "0000";
				--output <= "00000000";
				output <= "0000000000000000000000000000000000000000000000000000000000000000";
				--output <= "00000";
			end if;
			wait until rising_edge(clock);
		end if;
	end process;

end Behavioral;

