cat joltage_ratings.input | awk ' { print "("$0")," } ' > joltage_ratings.sql

create table jp_test_joltages(id int identity, joltage int)
insert into jp_test_joltages(joltage)
