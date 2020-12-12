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
