---input
sed 's/+/,+/g' assembly_code.input | sed 's/-/,-/g' | awk '{ print "("$0")" }' | sed "s/(/('/g" | sed "s/,/','/g" | sed "s/)/'),/g"  > assembly_code.sql


--create table jp_test_assembly (id int identity, operation varchar(5), input smallint, processed bit)
