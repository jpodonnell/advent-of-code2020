cat xmas_code.input | awk ' { print "("$0")," } ' > xmas_code.sql

create table jp_test_xmas_code (id int identity primary key, number bigint)

alter procedure validate_xmas_code
as
begin
declare @location int = 26
declare @location_1 int
declare @location_2 int
declare @sum bigint
declare @addend_1 bigint
declare @addend_2 bigint
declare @ok bit = 1
declare @sum_found int = 0
while @ok = 1
	begin
		select @location_1 = @location - 25
		select @location_2 = @location_1 + 1
		select @sum_found = 0
		while @sum_found = 0
		begin
			select @sum = number from jp_test_xmas_code where id =  @location
			select @addend_1 = number from jp_test_xmas_code where id = @location_1
			select @addend_2 = number from jp_test_xmas_code where id = @location_2
			if @addend_1 + @addend_2 = @sum
			begin				
				select @sum_found = 1
				select @location = @location + 1
			end
			else
			begin
				select @location_2=@location_2 + 1
				if @location_2 = @location
				begin
					select @location_1=@location_1  + 1
					select @location_2 = @location_1 + 1
				end
				if @location_1 >= @location - 1  --if the location of the sum I am trying to get to is the location of one of the addends then I need to stop
				begin
					select @sum_found =2
					select @ok = 0
				end
			end
		end
	end
select @sum
end

exec validate_xmas_code

alter function find_numbers(@input bigint) --need to figure out how to move the new sum
returns varchar(1000)
as
begin
declare @numbers varchar(1000) = ''
declare @start_loc int = 1
declare @end_loc int = 2
declare @sum bigint 
select @sum = number from jp_test_xmas_code where id = @start_loc
select @sum = @sum + number from jp_test_xmas_code where id = @end_loc
while @sum != @input
begin
	  select @end_loc = @end_loc + 1
	  select @sum = @sum + number from jp_test_xmas_code where id = @end_loc
	  if @sum = @input
	  begin --get the smallest and largest number from the set of numbers
		select @numbers = convert(varchar(50),min(number)) from jp_test_xmas_code where id between @start_loc and @end_loc
		select @numbers = @numbers + '  ' + convert(varchar(50),max(number)) from jp_test_xmas_code where id between @start_loc and @end_loc
	  end
	  while ( @sum > @input)
	  begin
		select @sum = @sum - number from jp_test_xmas_code where id = @start_loc
		select @start_loc = @start_loc + 1
		if @sum = @input
	  begin
		select @numbers = convert(varchar(50),min(number)) from jp_test_xmas_code where id between @start_loc and @end_loc
		select @numbers = @numbers + '  ' + convert(varchar(50),max(number)) from jp_test_xmas_code where id between @start_loc and @end_loc
	  end
	  end
end
return @numbers
end

select cmmdba.dbo.find_numbers(542529149)
