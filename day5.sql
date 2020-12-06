/*
The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127).
 Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; 
 the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). 
 The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

For example, consider just the first seven characters of FBFBBFFRLR:

Start by considering the whole range, rows 0 through 127.
F means to take the lower half, keeping rows 0 through 63.
B means to take the upper half, keeping rows 32 through 63.
F means to take the lower half, keeping rows 32 through 47.
B means to take the upper half, keeping rows 40 through 47.
B keeps rows 44 through 47.
F keeps rows 44 through 45.
The final F keeps the lower of the two, row 44.

The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). 
The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

For example, consider just the last 3 characters of FBFBBFFRLR:

Start by considering the whole range, columns 0 through 7.
R means to take the upper half, keeping columns 4 through 7.
L means to take the lower half, keeping columns 4 through 5.
The final R keeps the upper of the two, column 5.
So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

INPUT file load command
cat boardingpass.input | awk ' { print "("$0")," } ' | sed "s/(/('/g" | sed "s/)/')/g" > boardingpass_sql.input

*/

create table jp_test_boarding_pass(id int identity, boardingpass varchar(10), row_loc varchar(7), seat_loc varchar(3))

update jp_test_boarding_pass set row_loc= substring(boardingpass,1,7) 
select top 5 boardingpass, substring(boardingpass,8,3) from jp_test_boarding_pass
update jp_test_boarding_pass set seat_loc= substring(boardingpass,8,3) 
update jp_test_boarding_pass set row_loc=replace(row_loc,'F',0)
update jp_test_boarding_pass set row_loc=replace(row_loc,'B',1)
update jp_test_boarding_pass set seat_loc=replace(seat_loc,'L',0)
update jp_test_boarding_pass set seat_loc=replace(seat_loc,'R',1)
alter table jp_test_boarding_pass add row_num int
alter table jp_test_boarding_pass add seat_num int

create function binary_to_decimal( @input varchar(7))
returns int
as
begin
declare @decimal int = 0
declare @len int = len(@input)
declare @current_loc int =1
while @current_loc <= @len
begin
if (substring(@input,@current_loc,1) = '1')
begin
select @decimal = @decimal + power(2,(@len-@current_loc))
end
select @current_loc = @current_loc + 1
end
return @decimal
end

update jp_test_boarding_pass set row_num=cmm2_testing_t3.dbo.binary_to_decimal(row_loc)
update jp_test_boarding_pass set seat_num=cmm2_testing_t3.dbo.binary_to_decimal(seat_loc)

select max((row_num*8)+seat_num) from jp_test_boarding_pass
alter table JP_test_boarding_pass add seat_id int
update jp_test_boarding_pass set seat_id = ((row_num * 8) + seat_num)

select * from jp_test_boarding_pass where seat_id + 1 not in (select seat_id from jp_test_boarding_pass)




