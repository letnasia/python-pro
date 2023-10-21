
set search_path to 'l1';


-- Create table
create table student (id serial primary key, first_name varchar(40) not null , last_name varchar(40) not null , year_of_birth integer);

-- CRUD operations
-- CRUD - create, read, update, delete

-- Insert record into table
insert into student (first_name, last_name, year_of_birth) values ('Vitalii', 'Pavliuk', 1996);

-- Select all records from table
select * from student;

-- Update record in table
update student set first_name = 'Mykola' where id = 1;

-- Select again all records from table
select * from student;

-- Delete record from table
delete from student where id = 1;

-- Select again all records from table
select * from student;

-- Alter table, add more columns, use different types
-- text - unlimited length
alter table student add column description text;

-- date - date
alter table student add column date_of_birth date;

-- boolean - true/false
alter table student add column is_active boolean;

-- timestamp - date and time
-- programming pattern: active record (created_at, updated_at)
-- by default set current time
alter table student add column created_at timestamp default current_timestamp;
alter table student add column updated_at timestamp default current_timestamp;

-- more types
-- integer - 4 bytes (max values is 2^32 = 4294967296)
-- bigint - 8 bytes (max values is 2^64 = 18446744073709551616)
-- smallint - 2 bytes (max values is 2^16 = 65536)

-- numeric - decimal number
-- numeric(5, 2) - 5 digits, 2 digits after dot
alter table student add column average_mark numeric(5, 2);

-- real - 4 bytes (max values is 2^32 = 4294967296)
-- double precision - 8 bytes (max values is 2^64 = 18446744073709551616)

-- json - json object - any data structure (violates SQL rules)
-- jsonb - json object - any data structure (violates SQL rules)
alter table student add column payment_data jsonb;

-- enum - enumeration
-- gender field
create type gender_type as ENUM ('Male', 'Female', 'I d rather not say');
alter table student add column gender gender_type;

-- check which column the table has
-- from console: \d student
-- from pycharm database plugin:
select * from information_schema.columns where table_name = 'student';

-- create records with the new fields
insert into student (first_name, last_name, date_of_birth) values
                                                               ('Vitalii', 'Pavliuk', '1996-01-01'),
                                                               ('Mykola', 'Petrenko', '1997-02-02'),
                                                               ('Ivan', 'Ivanov', '1998-03-03'),
                                                               ('Petro', 'Petrov', '1999-04-04'),
                                                               ('Oleksandr', 'Oleksandrov', '2000-05-05'),
                                                               ('Oleksandra', 'Oleksandrivna', '2001-06-06'),
                                                                ('Olena', 'Olenivna', '2002-07-07'),
                                                                ('Olena', 'Petrenko', '2002-07-07');

-- insert random data to average_mark
update student set average_mark = random() * 100;

-- select all records from table
select * from student;

-- delete obsolete column
alter table student drop column year_of_birth, drop column description;

-- select only some columns
select first_name, last_name from student;

-- select only some columns with alias (псевдонім)
select first_name as name, last_name as surname from student;

-- select only calculated column
select concat(first_name, ' ', last_name, average_mark) as full_name from student;

-- select some aggregation
-- counst of students
select count(*) from student;

-- average mark
select avg(average_mark) from student;

-- select student with their age
select first_name, last_name, date_of_birth, extract( year from age(current_date, date_of_birth)) as age from student;

-- average age
select avg(extract(year from age(current_date, date_of_birth))) from student;

-- select students with name Olena
select * from student where first_name = 'Olena';

-- select students with age > 25
-- select first_name, last_name, date_of_birth, extract(year from age(current_date, date_of_birth)) as age from student where age > 25;

-- group by
-- select count of students per name
select first_name, count(*) as count, avg(student.average_mark) as average_mark from student group by first_name;

-- now create table mark with 2 columns student_id (foreign key to student) and value (integer)
create table mark (id serial primary key, student_id integer references student(id), value integer);

-- insert some data (mark should be from 60 to 100)m, student_id should be from 1 to 8, 3 marks per student
insert into mark (student_id, value) values (9, 100), (2, 95), (3, 90), (4, 80), (5, 70), (6, 60), (7, 65), (8, 90),
                           (9, 96), (2, 90), (3, 100), (4, 90), (5, 76), (6, 75), (7, 90), (8, 100),
                            (9, 100), (2, 95), (3, 90), (4, 80), (5, 70), (6, 60), (7, 65), (8, 90);

-- clear the table without deleting it
truncate mark;

-- no need of this column anymore
alter table student drop column average_mark;

-- calculate average mark per student
select student_id, avg(value) as average_mark from mark group by student_id;

-- join tables (first_name, last_name, average_mark)
select
    student.first_name,
    student.last_name,
    avg(mark.value) as average_mark
from student join mark on student.id = mark.student_id group by student.id;

-- add additional mark for one student
insert into mark (student_id, value) values (2, 100);
insert into mark (student_id, value) values (3, 100);

-- select students with average mark, having at least 4 marks
select
    student.first_name,
    student.last_name,
    avg(mark.value) as average_mark
from student join mark on student.id = mark.student_id group by student.id having count(mark.id) >= 4;

-- sorting
select * from student order by last_name;
-- by age date_of_birth desc
select * from student order by date_of_birth desc;

-- sort by multiple columns
select * from student order by first_name, last_name;

-- sort by calculated column
select first_name, last_name, extract( year from age(current_date, date_of_birth)) as age from student order by age;


