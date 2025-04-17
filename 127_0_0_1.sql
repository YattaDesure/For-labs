-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 17 2025 г., 12:13
-- Версия сервера: 8.0.19
-- Версия PHP: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `market`
--
CREATE DATABASE IF NOT EXISTS `market` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `market`;

-- --------------------------------------------------------

--
-- Структура таблицы `authors`
--

CREATE TABLE `authors` (
  `AuthorId` int NOT NULL,
  `Second_Name` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Country` varchar(30) NOT NULL DEFAULT 'Россия'
) ;

--
-- Дамп данных таблицы `authors`
--

INSERT INTO `authors` (`AuthorId`, `Second_Name`, `Name`, `Country`) VALUES
(1, 'Толстой', 'Лев', 'Россия'),
(2, 'Толстой', 'Алексей', 'Россия'),
(3, 'Гоголь', 'Николай', 'Россия'),
(4, 'Пушкин', 'Александр', 'Россия'),
(5, 'Лермонтов', 'Михаил', 'Россия');

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `authorsbook`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `authorsbook` (
`Books` text
,`Name` varchar(50)
,`Second_Name` varchar(50)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `bookinfo`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `bookinfo` (
`BookId` int
,`Name` varchar(50)
,`Price` decimal(6,2)
,`Second_Name` varchar(50)
,`Title` varchar(50)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `bookinfotale`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `bookinfotale` (
`BookConsist` varchar(3)
,`BookId` varchar(6)
,`Name` varchar(4)
,`Price` varchar(5)
,`Second_Name` varchar(11)
,`Title` varchar(5)
);

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `bookinfowithprice`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `bookinfowithprice` (
`BookId` varchar(6)
,`Name` varchar(4)
,`Price` varchar(5)
,`PriceCategory` varchar(11)
,`Second_Name` varchar(11)
,`Title` varchar(5)
);

-- --------------------------------------------------------

--
-- Структура таблицы `books`
--

CREATE TABLE `books` (
  `BookId` int NOT NULL,
  `Title` varchar(50) NOT NULL,
  `Genre` enum('проза','поэзия','другое') NOT NULL DEFAULT 'проза',
  `Price` decimal(6,2) NOT NULL DEFAULT '0.00',
  `Weight` decimal(4,3) NOT NULL DEFAULT '0.000',
  `Pages` smallint NOT NULL DEFAULT '0',
  `Year` year DEFAULT NULL,
  `AuthorId` int NOT NULL,
  `Amount` int DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `books`
--

INSERT INTO `books` (`BookId`, `Title`, `Genre`, `Price`, `Weight`, `Pages`, `Year`, `AuthorId`, `Amount`) VALUES
(1, 'Мертвые Души', 'другое', '396.00', '8.000', 213, 2012, 3, 50),
(2, 'Детство', 'другое', '297.00', '0.600', 267, 2003, 1, 50),
(3, 'Война и мир', 'другое', '792.00', '1.399', 1247, 2007, 1, 50),
(4, 'Бородино', 'поэзия', '198.00', '0.100', 5, 1999, 5, 50),
(5, 'Памятник', 'поэзия', '19.80', '0.002', 3, 2022, 4, 50),
(6, 'Детсво Никиты', 'другое', '396.00', '0.456', 121, 2014, 2, 50),
(7, 'Медный Всадник', 'проза', '198.00', '0.221', 44, 2018, 4, 50);

--
-- Триггеры `books`
--
DELIMITER $$
CREATE TRIGGER `after_delete_books` AFTER DELETE ON `books` FOR EACH ROW begin
	insert into Logs (TableName,  Operation)
    values('books', 'DELETE');
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_books` AFTER INSERT ON `books` FOR EACH ROW begin
	insert into Logs (TableName,  Operation)
    values('books', 'INSERT');
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_books` AFTER UPDATE ON `books` FOR EACH ROW begin
	insert into Logs (TableName,  Operation)
    values('books', 'UPDATE');
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_books` BEFORE INSERT ON `books` FOR EACH ROW begin
	if new.price > 5000 then
    set new.price = 5000;
    end if;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `compound`
--

CREATE TABLE `compound` (
  `BookId` int NOT NULL,
  `OrderId` int NOT NULL,
  `Amount` tinyint NOT NULL DEFAULT '1'
) ;

--
-- Дамп данных таблицы `compound`
--

INSERT INTO `compound` (`BookId`, `OrderId`, `Amount`) VALUES
(1, 2, 3),
(2, 1, 12),
(2, 7, 6),
(3, 1, 32),
(3, 3, 1),
(4, 4, 3),
(5, 2, 21),
(6, 3, 2),
(6, 6, 12),
(7, 5, 3),
(7, 6, 4),
(7, 7, 15);

--
-- Триггеры `compound`
--
DELIMITER $$
CREATE TRIGGER `after_insert_compound` AFTER INSERT ON `compound` FOR EACH ROW begin
	select sum(books.price * compound.amount)
		into @orderCost
        from market.compound
        join market.books on compound.BookId = books.BookId
        join market.orders on compound.OrderId = orders.OrderId
        where compound.OrderId = new.OrderId;
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_compound` BEFORE INSERT ON `compound` FOR EACH ROW begin
	declare current_stock int;
    select Amount into current_stock
    from market.books
    where BookId = NEW.BookId;
    if current_stock < new.Amount then
		signal sqlstate '45000'
        set message_text = 'Недостаточно товара на складе';
	end if;
    update market.books
    set Amount = Amount - new.Amount
    where BookId = new.BookId;
    end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `customers`
--

CREATE TABLE `customers` (
  `CustomerId` int NOT NULL,
  `Login` varchar(20) NOT NULL,
  `SecondName` varchar(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Adsress` varchar(50) NOT NULL,
  `Telephone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `customers`
--

INSERT INTO `customers` (`CustomerId`, `Login`, `SecondName`, `Name`, `Adsress`, `Telephone`) VALUES
(1, 'ebanyi_kirpich', 'Pesnopenya', 'Cerkovnye', 'Solombala', '89210882014'),
(2, 'spyshy_kolesa', 'Язиков', 'Эдуард', 'Вологодская 30', '89009202127'),
(3, 'snimi_glasses_epta', 'Погребной', 'Иван', 'Никольский', ''),
(4, 'chelovek_pauk', 'Погребной', 'Иван', 'Полярная пупица', '89093231222');

--
-- Триггеры `customers`
--
DELIMITER $$
CREATE TRIGGER `after_delete_customers` AFTER DELETE ON `customers` FOR EACH ROW begin
	insert into market.deletedCustomers (CustomerId, Login, SecondName, Name, Address, Telephone)
    values (OLD.CustomerId, OLD.Login, OLD.SecondName, OLD.Name, OLD.Adsress, OLD.Telephone);
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_customers` BEFORE DELETE ON `customers` FOR EACH ROW begin
	delete from compound
    where OrderId in(
    select OrderId from orders
    where CustomerId = old.CustomerId);
	
    delete from orders
    where CustomerId = old.CustomerId;
    end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `deletedcustomers`
--

CREATE TABLE `deletedcustomers` (
  `CustomerId` int DEFAULT NULL,
  `Login` varchar(20) DEFAULT NULL,
  `SecondName` varchar(50) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Telephone` varchar(20) DEFAULT NULL,
  `DeleteDate` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `logs`
--

CREATE TABLE `logs` (
  `TableName` varchar(50) NOT NULL,
  `Operation` varchar(10) NOT NULL,
  `DateTime` datetime DEFAULT CURRENT_TIMESTAMP,
  `CurrentUser` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `logs`
--

INSERT INTO `logs` (`TableName`, `Operation`, `DateTime`, `CurrentUser`) VALUES
('books', 'UPDATE', '2025-04-17 11:17:00', NULL),
('books', 'UPDATE', '2025-04-17 11:17:00', NULL),
('books', 'UPDATE', '2025-04-17 11:17:00', NULL),
('books', 'UPDATE', '2025-04-17 11:17:00', NULL),
('books', 'UPDATE', '2025-04-17 11:17:00', NULL),
('books', 'UPDATE', '2025-04-17 11:17:00', NULL),
('books', 'UPDATE', '2025-04-17 11:17:00', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `OrderId` int NOT NULL,
  `DateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CustomerId` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`OrderId`, `DateTime`, `CustomerId`) VALUES
(1, '2024-12-23 00:00:00', 1),
(2, '2025-01-13 00:00:00', 2),
(3, '2025-01-17 00:00:00', 3),
(4, '2025-02-13 00:00:00', 2),
(5, '2025-03-11 00:00:00', 1),
(6, '2025-04-01 00:00:00', 3),
(7, '2025-04-09 00:00:00', 3);

--
-- Триггеры `orders`
--
DELIMITER $$
CREATE TRIGGER `after_delete_orders` AFTER DELETE ON `orders` FOR EACH ROW begin
	insert into Logs (TableName,  Operation)
    values('orders', 'DELETE');
    
    delete from customers
    where CustomerId not in(select distinct CustomerId
    from market.orders);
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_orders` AFTER INSERT ON `orders` FOR EACH ROW begin
	insert into Logs (TableName,  Operation)
    values('orders', 'INSERT');
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_orders` AFTER UPDATE ON `orders` FOR EACH ROW begin
	insert into Logs (TableName,  Operation)
    values('orders', 'UPDATE');
    end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_orders` BEFORE INSERT ON `orders` FOR EACH ROW begin
	set new.DateTime = current_date();
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Дублирующая структура для представления `thisyearorder`
-- (См. Ниже фактическое представление)
--
CREATE TABLE `thisyearorder` (
`CustomerId` int
,`FirstName` varchar(50)
,`login` varchar(20)
,`OrderDate` datetime
,`OrderId` int
,`SecondName` varchar(50)
);

-- --------------------------------------------------------

--
-- Структура для представления `authorsbook`
--
DROP TABLE IF EXISTS `authorsbook`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `authorsbook`  AS SELECT `authors`.`Second_Name` AS `Second_Name`, `authors`.`Name` AS `Name`, group_concat(distinct `books`.`Title` order by `books`.`Title` ASC separator ';') AS `Books` FROM (`authors` join `books` on((`authors`.`AuthorId` = `books`.`AuthorId`))) GROUP BY `authors`.`AuthorId`, `authors`.`Second_Name`, `authors`.`Name` ;

-- --------------------------------------------------------

--
-- Структура для представления `bookinfo`
--
DROP TABLE IF EXISTS `bookinfo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `bookinfo`  AS SELECT `books`.`BookId` AS `BookId`, `authors`.`Second_Name` AS `Second_Name`, `authors`.`Name` AS `Name`, `books`.`Title` AS `Title`, `books`.`Price` AS `Price` FROM (`books` join `authors` on((`books`.`AuthorId` = `authors`.`AuthorId`))) ;

-- --------------------------------------------------------

--
-- Структура для представления `bookinfotale`
--
DROP TABLE IF EXISTS `bookinfotale`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `bookinfotale`  AS SELECT 'BookId' AS `BookId`, 'Second_Name' AS `Second_Name`, 'Name' AS `Name`, 'Title' AS `Title`, (case when ('Title' like '%Сказки%') then 'Yes' else 'no' end) AS `BookConsist`, 'Price' AS `Price` FROM `bookinfo` ;

-- --------------------------------------------------------

--
-- Структура для представления `bookinfowithprice`
--
DROP TABLE IF EXISTS `bookinfowithprice`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `bookinfowithprice`  AS SELECT 'BookId' AS `BookId`, 'Second_Name' AS `Second_Name`, 'Name' AS `Name`, 'Title' AS `Title`, (case when ('Price' < 1000) then 'before 1000' when ('Price' between 1000 and 5000) then 'over 5000' else 'no data' end) AS `PriceCategory`, 'Price' AS `Price` FROM `books` ;

-- --------------------------------------------------------

--
-- Структура для представления `thisyearorder`
--
DROP TABLE IF EXISTS `thisyearorder`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`127.0.0.1` SQL SECURITY DEFINER VIEW `thisyearorder`  AS SELECT `orders`.`OrderId` AS `OrderId`, `orders`.`DateTime` AS `OrderDate`, `orders`.`CustomerId` AS `CustomerId`, `customers`.`Login` AS `login`, `customers`.`SecondName` AS `SecondName`, `customers`.`Name` AS `FirstName` FROM (`orders` join `customers` on((`orders`.`CustomerId` = `customers`.`CustomerId`))) WHERE (extract(year from `orders`.`DateTime`) = extract(year from curdate())) ;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`AuthorId`),
  ADD UNIQUE KEY `Second_Name_UNIQUE` (`Second_Name`,`Name`);

--
-- Индексы таблицы `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`BookId`),
  ADD KEY `fk_Books_Authors_idx` (`AuthorId`);

--
-- Индексы таблицы `compound`
--
ALTER TABLE `compound`
  ADD PRIMARY KEY (`BookId`,`OrderId`),
  ADD KEY `fk_Books_has_Orders_Orders1_idx` (`OrderId`),
  ADD KEY `fk_Books_has_Orders_Books1_idx` (`BookId`);

--
-- Индексы таблицы `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerId`),
  ADD UNIQUE KEY `Login_UNIQUE` (`Login`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderId`),
  ADD KEY `fk_Orders_Customers1_idx` (`CustomerId`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `authors`
--
ALTER TABLE `authors`
  MODIFY `AuthorId` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `books`
--
ALTER TABLE `books`
  MODIFY `BookId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderId` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `fk_Books_Authors` FOREIGN KEY (`AuthorId`) REFERENCES `authors` (`AuthorId`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `compound`
--
ALTER TABLE `compound`
  ADD CONSTRAINT `fk_Books_has_Orders_Books1` FOREIGN KEY (`BookId`) REFERENCES `books` (`BookId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Books_has_Orders_Orders1` FOREIGN KEY (`OrderId`) REFERENCES `orders` (`OrderId`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_Orders_Customers1` FOREIGN KEY (`CustomerId`) REFERENCES `customers` (`CustomerId`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
