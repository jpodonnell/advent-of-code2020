---input
sed 's/+/,+/g' assembly_code.input | sed 's/-/,-/g' | awk '{ print "("$0")" }' | sed "s/(/('/g" | sed "s/,/','/g" | sed "s/)/'),/g"  > assembly_code.sql


--create table jp_test_assembly (id int identity, operation varchar(5), input smallint, processed bit)
update jp_test_assembly set processed = 0
--functions can't alter tables, so it has to be a procedure
create procedure process_instructions 
as
begin
declare @accumulator int =0
declare @location int = 1
declare @operation varchar(5)
declare @twice int = 0

select @twice = processed from jp_test_assembly where id = @location
while @twice = 0
begin
	update jp_test_assembly set processed = 1 where id = @location
	select @operation = operation from jp_test_assembly where id=@location
	if @operation = 'acc'
	begin
		select @accumulator = @accumulator + input from jp_test_assembly where id=@location
		select @location = @location + 1
	end
	else if @operation = 'jmp'
	begin
		select @location = @location + input from jp_test_assembly where id=@location
	end
	else if @operation = 'nop'
	begin 
		select @location =  @location + 1 
	end
	
	select @twice = processed from jp_test_assembly where id = @location
end
select @accumulator

end

execute process_instructions
