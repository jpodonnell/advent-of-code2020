--import the file
cat luggage_rules.input | awk ' { FS=" contain " } ;{ print "("$0")," } ' | sed "s/(/('/g" | sed "s/)/')/g"


--create table jp_test_bag_rules(id int identity, bag_rules varchar(1000))

insert into jp_test_bag_rules(bag_rules)
values

