Passports
/*
byr (Birth Year) - four digits; at least 1920 and at most 2002. isnumeric
iyr (Issue Year) - four digits; at least 2010 and at most 2020. isnumeric
eyr (Expiration Year) - four digits; at least 2020 and at most 2030. isnumeric
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.


update jp_test_passports set valid_contents=1

update jp_test_passports set valid_contents = isnumeric(substring(passport,charindex('byr',passport,0)+4,4))
update jp_test_passports set valid_contents = valid_contents * isnumeric(substring(passport,charindex('iyr',passport,0)+4,4))
update jp_test_passports set valid_contents = valid_contents * isnumeric(substring(passport,charindex('eyr',passport,0)+4,4))

select count(*) from jp_test_passports where valid_contents > 0 and valid > 0 */

select top 50 * from jp_test_passports

/*
alter table jp_test_passports drop column byr
alter table jp_test_passports drop column eyr
alter table jp_test_passports drop column iyr
alter table jp_test_passports drop column hgt
alter table jp_test_passports drop column hcl
alter table jp_test_passports drop column ecl
alter table jp_test_passports drop column pid
*/


alter table jp_test_passports add byr int;
alter table jp_test_passports add eyr int;
alter table jp_test_passports add iyr int;
alter table jp_test_passports add hgt varchar(5);
alter table jp_test_passports add hcl varchar(10);
alter table jp_test_passports add ecl varchar(10);
alter table jp_test_passports add pid varchar(10);


select passport, 
substring(passport,charindex('ecl',passport,0)+4,
case charindex(':',passport,charindex('ecl',passport,0)+4)
when 0 then len(passport) - (charindex('ecl',passport,0)+3)
else charindex(':',passport,charindex('ecl',passport,0)+4) - (charindex('ecl',passport,0)+7)
end) from jp_test_passports  where charindex('ecl',passport,0) != 0 -- only where teh ecl tag exists





update jp_test_passports 
set byr=substring(passport,charindex('byr',passport,0)+4,  --start the substring 4 characters after the start of the identifier becasue of the :
case charindex(':',passport,charindex('byr',passport,0)+4) --check if there is a : after the current identifier, 
when 0 then len(passport) - charindex('byr',passport,0)+3  --if not go to the end of the line
else charindex(':',passport,charindex('byr',passport,0)+4) - (charindex('byr',passport,0)+7) --otherwise go to the start of the next identifier
end) from jp_test_passports where (isnumeric(substring(passport,charindex('byr',passport,0)+4,4)) = 1) --only for rows with a valid potential value 

update jp_test_passports 
set iyr=substring(passport,charindex('iyr',passport,0)+4,
case charindex(':',passport,charindex('iyr',passport,0)+4)
when 0 then len(passport) - charindex('iyr',passport,0)+3
else charindex(':',passport,charindex('iyr',passport,0)+4) - (charindex('iyr',passport,0)+7)
end) from jp_test_passports where (isnumeric(substring(passport,charindex('iyr',passport,0)+4,4)) = 1)

update jp_test_passports 
set eyr=substring(passport,charindex('eyr',passport,0)+4,
case charindex(':',passport,charindex('eyr',passport,0)+4)
when 0 then len(passport) - charindex('eyr',passport,0)+3
else charindex(':',passport,charindex('eyr',passport,0)+4) - (charindex('eyr',passport,0)+7)
end) from jp_test_passports
where (isnumeric(substring(passport,charindex('eyr',passport,0)+4,4)) = 1)


update jp_test_passports set hgt = substring(passport,charindex('hgt',passport,0)+4,
case charindex(':',passport,charindex('hgt',passport,0)+4)
when 0 then len(passport) - (charindex('hgt',passport,0)+3)
else charindex(':',passport,charindex('hgt',passport,0)+4) - (charindex('hgt',passport,0)+7)
end) from jp_test_passports  where charindex('hgt',passport,0) != 0 --only for rows where you can find the hgt tag

update jp_test_passports set ecl = substring(passport,charindex('ecl',passport,0)+4,
case charindex(':',passport,charindex('ecl',passport,0)+4)
when 0 then len(passport) - (charindex('ecl',passport,0)+3)
else charindex(':',passport,charindex('ecl',passport,0)+4) - (charindex('ecl',passport,0)+7)
end) from jp_test_passports  where charindex('ecl',passport,0) != 0 -- only where teh ecl tag exists
--and (charindex(':',passport,charindex('ecl',passport,0)+4) - (charindex('ecl',passport,0)+7)) = 4 --and where the contens 

update jp_test_passports set hcl = substring(passport,charindex('hcl',passport,0)+4,
case charindex(':',passport,charindex('hcl',passport,0)+4)
when 0 then len(passport) - (charindex('hcl',passport,0)+3)
else charindex(':',passport,charindex('hcl',passport,0)+4) - (charindex('hcl',passport,0)+7)
end) from jp_test_passports  where charindex('hcl',passport,0) != 0 --only where the tag exists

update jp_test_passports set pid = substring(passport,charindex('pid',passport,0)+4,
case charindex(':',passport,charindex('pid',passport,0)+4)
when 0 then len(passport) - (charindex('pid',passport,0)+3)
else charindex(':',passport,charindex('pid',passport,0)+4) - (charindex('pid',passport,0)+7)
end) from jp_test_passports  where charindex('pid',passport,0) != 0 and  --where the pid tag exists
isnumeric(
substring(
	passport,charindex('pid',passport,0)+4,
		case charindex(':',passport,charindex('pid',passport,0)+4)
		when 0 then len(passport) - (charindex('pid',passport,0)+3)
		else charindex(':',passport,charindex('pid',passport,0)+4) - (charindex('pid',passport,0)+7)
		end
		)
		) = 1 --and it is a numeric value

update jp_test_passports set valid_contents=1 --start invalidating passports

update jp_test_passports set valid_contents = coalesce(byr,0) 
update jp_test_passports set valid_contents = coalesce(eyr,0) 
update jp_test_passports set valid_contents = coalesce(iyr,0) 
update jp_test_passports set valid_contents = 0 where len(pid) != 9 or pid is null

select count(*) from jp_test_passports where valid_contents != 0

update jp_test_passports set valid_contents = 0 
where byr < 1920 or byr > 2002

update jp_test_passports set valid_contents = 0 
where iyr < 2010 or iyr > 2020

update jp_test_passports set valid_contents = 0 
where eyr < 2020 or eyr > 2030

update jp_test_passports set valid_contents = 0 
where ecl not in ('amb','blu','brn','grn','gry','hzl','oth') or ecl is null

alter table jp_test_passports add hgt_unit varchar(2)

update jp_test_passports set hgt_unit = 'in' where charindex('in',hgt) != 0 
update jp_test_passports set hgt_unit = 'cm' where charindex('cm',hgt) != 0 

alter table jp_test_passports add hgt_value int
update jp_test_passports set hgt_value=replace(hgt,hgt_unit,'') where hgt_unit is not null

update jp_test_passports set valid_contents=0 where (hgt_value < 150 or hgt_value > 193) and hgt_unit='cm' and hgt_unit is not null
update jp_test_passports set valid_contents=0 where (hgt_value < 59 or hgt_value > 76) and hgt_unit='in' and hgt_unit is not null
update jp_test_passports set valid_contents=0 where hgt is null or hgt_unit is null

update jp_test_passports set valid_contents=0 where hcl not like '#[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]'


select count(*) from jp_test_passports where valid_contents != 0

