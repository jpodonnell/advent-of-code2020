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


----PART 2
alter procedure process_instructions 
as
begin
declare @accumulator int =0  --keep track of the value
declare @location int = 1 --what id do i need to be executing
declare @operation varchar(5) --what operation 
declare @twice int = 0 --have I executed something twice
declare @changed_id int = 1 -- what operation # did I change last time
declare @operation_count int = 0 --how many operations have I executed
declare @changed bit = 0 -- Have I changed anything this time
declare @main_exit int = 0 -- I reached the last line in the file

while @main_exit = 0
begin
	--reset all the things
	update jp_test_assembly set processed = 0
	select @location = 1
	select @changed = 0
	select @operation_count = 0
	select @twice = 0
	select @accumulator=0
	while @twice = 0
	begin
		update jp_test_assembly set processed = 1 where id = @location
		select @operation_count = @operation_count + 1
		select @operation = operation from jp_test_assembly where id=@location
		if @operation = 'acc'
		begin
			select @accumulator = @accumulator + input from jp_test_assembly where id=@location
			select @location = @location + 1
		end --end the acc
		else if @operation = 'jmp'
		begin
			if ((@operation_count <= @changed_id) or @changed = 1)
			begin
				select @location = @location + input from jp_test_assembly where id=@location
			end
			else --I haven't changed a jmp or nop yet this round and I am past where I changed it last round so change this one
			begin
				select @changed = 1 --mark I changed something this loop
				select @changed_id = @operation_count --mark where I changed it
				select @location = @location + 1
			end
		end -- end the jmp
		else if @operation = 'nop'
		begin 
			if ((@operation_count <= @changed_id) or @changed = 1)
			begin
				
				select @location =  @location + 1 	
			end
			else --I haven't changed a jmp or nop yet this round and I am past where I changed it last round so change this one
			begin
				select @changed = 1  --mark I changed something this loop
				select @changed_id = @operation_count --mark where I changed it
				select @location = @location + input from jp_test_assembly where id=@location
			end
		end --end the no-op 
		
		select @twice = processed from jp_test_assembly where id = @location
		if (select @location)  = 624  --If I get to the last line
		begin 
			select 'here'
			select @twice = 2
			select @main_exit = 1
		end
	end --loop of trying to change a single jmp or nop
end
select @accumulator
end

update jp_test_assembly set processed = 0
execute process_instructions
