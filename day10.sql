cat joltage_ratings.input | awk ' { print "("$0")," } ' > joltage_ratings.sql

create table jp_test_joltages(id int identity, joltage int)
insert into jp_test_joltages(joltage)

declare volt_diff cursor
for select joltage from jp_test_joltages order by joltage asc

declare @joltage int
declare @next_joltage int
declare @one_jolt_diff int = 0
declare @three_jolt_diff int = 0

open volt_diff

fetch next from volt_diff into @joltage
fetch next from volt_diff into @next_joltage
while @@FETCH_STATUS = 0
begin
if @next_joltage - @joltage = 1
begin
	select @one_jolt_diff = @one_jolt_diff + 1
end
else if @next_joltage - @joltage =3
begin
	select @three_jolt_diff = @three_jolt_diff + 1
end
select @joltage = @next_joltage
fetch next from volt_diff into @next_joltage
end
close volt_diff;
deallocate volt_diff;

select (@one_jolt_diff + 1) * (@three_jolt_diff + 1) --the plus one to include your device and the wall device
