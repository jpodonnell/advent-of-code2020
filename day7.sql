--import the file
cat luggage_rules.input | awk ' { FS=" contain " } ;{ print "("$0")," } ' | sed "s/(/('/g" | sed "s/)/')/g"


--create table jp_test_bag_rules(id int identity, bag_rules varchar(1000))
--create  table jp_test_bag_counted (id int identity, bag varchar(100), counted int)

insert into jp_test_bag_rules(bag_rules)
values


create procedure num_of_bags(@bag_name varchar(50))
as
begin
declare @num_of_bags int = 0
declare @bag varchar(50)
select @bag=@bag_name
insert into jp_test_bag_counted(bag) values(@bag_name)
while (select count(*) from jp_test_bag_counted where counted is null) > 0
begin
update jp_test_bag_counted set counted = 1 where bag=@bag
print @bag
insert into jp_test_bag_counted(bag)
select substring(bag_rules,1,(charindex('contain',bag_rules,1)-3))
from jp_test_bag_rules where charindex(@bag,bag_rules,charindex('contain',bag_rules,1)) > 0

delete from jp_test_bag_counted
where id not in (select min(id) from jp_test_bag_counted group by bag)

select top 1 @bag = bag from jp_test_bag_counted where counted is null

end

select count(distinct(bag)) from jp_test_bag_counted where bag != @bag
end

exec num_of_bags 'shiny gold bag'
                      
                      
