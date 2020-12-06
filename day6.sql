load the file
sed 's/^$/123thisisanewline123/g' question_answers.input > questions_thisisanewline.input
cat questions_thisisanewline.input | tr -d '\n' > questions_oneline.input
cat questions_oneline.input | awk -F'123thisisanewline123' '{$1=$1}1' OFS='\n' | awk ' { print "("$0")," } ' | sed "s/(/('/g" | sed "s/)/')/g" > questions_input.sql

--create table jp_test_questions(id int identity, answers varchar(500))
create function distinct_letter_count( @input varchar(500) )
returns int
as
begin
declare @num_distinct_letters int = 0
declare @letters varchar(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
declare @letter int = 1
while @letter <= 26
begin
select @num_distinct_letters = @num_distinct_letters + case  when (len(@input) - len(replace(@input,substring(@letters,@letter,1),''))) > 0 then 1 else 0 end
select @letter = @letter+1
end
return @num_distinct_letters
end

select cmm2_testing_t3.dbo.distinct_letter_count('AAABBBAAAFFFHHH')

alter table jp_test_questions add distinct_answers int

update jp_test_questions set distinct_answers = cmm2_testing_t3.dbo.distinct_letter_count(answers)

select sum(distinct_answers) from jp_test_questions

----Part 2
cat questions_thisisanewline.input | tr '\n' '1' > questions_oneline_2.input --This adds a 1 to the end of 123thisisanewline123 which needs to be dealth with
cat questions_oneline_2.input | awk -F'123thisisanewline1231' '{$1=$1}1' OFS='\n' | awk ' { print "("$0")," } ' | sed "s/(/('/g" | sed "s/)/')/g" > questions_input_2.sql

create table jp_test_questions_2(id int identity, answers varchar(500), distinct_group_answers int)

create function distinct_group_letter_count( @input varchar(500) )
returns int
as
begin
declare @num_distinct_letter int = 0
declare @group_distinct_answers int =0 
declare @group_size int =0
declare @letters varchar(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
declare @letter int = 1 
select @group_size = (len(@input) - len(replace(@input,1,''))) 
while @letter <= 26
begin
--Check to see if the number of times teh letter is supplied is the size of the group
select @num_distinct_letter =   (len(@input) - len(replace(@input,substring(@letters,@letter,1),'')))  
if @num_distinct_letter = @group_size
begin
select @group_distinct_answers = @group_distinct_answers + 1
end
select @letter = @letter+1
end
return @group_distinct_answers
end

update jp_test_questions_2 set distinct_group_answers = cmm2_testing_t3.dbo.distinct_group_letter_count(answers)
select sum(distinct_group_answers) from jp_test_questions_2
