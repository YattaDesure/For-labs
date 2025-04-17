CREATE USER 'userTask1'@'localhost';
GRANT show databases
ON *.*
TO 'userTask1'@'localhost';

CREATE USER 'userTask2'@'localhost' IDENTIFIED BY '123';
grant all privileges
ON *.*
TO 'userTask2'@'localhost';

CREATE USER 'userTask3'@'localhost' IDENTIFIED BY 'qwerty';
grant select, insert, update, delete
ON market.*
to 'userTask3'@'localhost';

CREATE USER 'userTask4'@'localhost';
grant select
ON market.books
to 'userTask4'@'localhost';

CREATE USER 'userTask5'@'localhost';
grant select(BookId, Title, Price), update(Price)
ON market.books
to 'userTask5'@'localhost';

