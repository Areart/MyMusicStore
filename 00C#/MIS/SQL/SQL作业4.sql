--	查询出图书的索取号，书名，出版社，类别名称。
SELECT     TBL_BookInfo.BookID, TBL_BookInfo.BookName, TBL_BookInfo.Publisher, TBL_BookClass.ClassName
FROM         TBL_BookClass INNER JOIN
                      TBL_BookInfo ON TBL_BookClass.ClassID = TBL_BookInfo.ClassID

SELECT     TBL_BookInfo.BookID, TBL_BookInfo.BookName, TBL_BookInfo.Publisher, TBL_BookClass.ClassName
from TBL_BookClass,TBL_BookInfo
WHERE TBL_BookClass.ClassID = TBL_BookInfo.ClassID

--	在TBL_Borrowinfo用语句插入如下两条数据：
--          (‘G40-092.2/5’,’ 01022’,2007-1-6’,null,0)
--          (‘G633.7/202 ’,’ 01022’,2007-3-16’,null,0)
insert into TBL_Borrowinfo values('TP312C/173','20090410086','2007-7-6',null,0)
insert into TBL_Borrowinfo values('TP312C/173','20090410086','2007-7-26',null,0)

--	查询出借阅索取号为“G40-092.2/5”图书的读者姓名，班级。
SELECT     TBL_User.UserName, TBL_User.Class
FROM         TBL_BorrowInfo                      
                      INNER JOIN
                      TBL_User ON TBL_BorrowInfo.UserID = TBL_User.UserID
WHERE     (TBL_BorrowInfo.BookID = 'G40-092.2/5')

SELECT     TBL_User.UserName, TBL_User.Class
FROM         TBL_BorrowInfo,TBL_User                      
WHERE      TBL_BorrowInfo.UserID = TBL_User.UserID AND TBL_BorrowInfo.BookID = 'G40-092.2/5'


--	显示没有归还书的书名、读者、读者的班级。
SELECT     TBL_Bookinfo.BookName,TBL_User.UserName, TBL_User.Class
FROM         TBL_BorrowInfo INNER JOIN
                      TBL_User ON TBL_BorrowInfo.UserID = TBL_User.UserID
                      inner join TBL_Bookinfo ON TBL_BorrowInfo.BookId=TBL_Bookinfo.BookId
WHERE     (TBL_BorrowInfo.IsResturned = 0)

--	查询出所有借过书的女生的信息。
SELECT  distinct   TBL_User.UserID, TBL_User.UserName, TBL_User.Sex, TBL_User.Email, TBL_User.Class
FROM         TBL_BorrowInfo INNER JOIN
                      TBL_User ON TBL_BorrowInfo.UserID = TBL_User.UserID
WHERE TBL_User.sex=0

--	查询出所有2018年1月、3月被借出过的书的信息及借出时间。
SELECT  TBL_BookInfo.BookID, TBL_BookInfo.ISBN, TBL_BookInfo.BookName, TBL_BookInfo.Publisher, 
TBL_BookInfo.Author, TBL_BorrowInfo.BorrowDate
FROM         TBL_BorrowInfo INNER JOIN
                      TBL_BookInfo ON TBL_BorrowInfo.BookID = TBL_BookInfo.BookID
WHERE     (TBL_BorrowInfo.BorrowDate BETWEEN '2018-01-01' AND '2018-3-31')

--	查询出男、女生各借过多少本书。
SELECT  TBL_User.Sex,COUNT(*) AS 数量
FROM         TBL_BorrowInfo INNER JOIN
                      TBL_User ON TBL_BorrowInfo.UserID = TBL_User.UserID
GROUP BY TBL_User.Sex

--	查询出各出版社在1985年以后出版的图书被借出的数量，并按借出数量的降序显示查询结果。
SELECT   TBL_BookInfo.Publisher,COUNT(TBL_BookInfo.Publisher) AS 数量
FROM         TBL_BorrowInfo INNER JOIN
                      TBL_BookInfo ON TBL_BorrowInfo.BookID = TBL_BookInfo.BookID
where TBL_Bookinfo.Publishdate >='1985-1-1'
GROUP BY TBL_BookInfo.Publisher
order by COUNT(TBL_BookInfo.Publisher) desc

--	查询出2018年的所有借阅信息（包括：书名、借书时间、读者名）。
SELECT     TBL_User.UserName, TBL_BorrowInfo.BorrowDate,TBL_BookInfo.BookName 
FROM         TBL_BorrowInfo INNER JOIN
                      TBL_BookInfo ON TBL_BorrowInfo.BookID = TBL_BookInfo.BookID 
                      INNER JOIN
                      TBL_User ON TBL_BorrowInfo.UserID = TBL_User.UserID
WHERE     (TBL_BorrowInfo.BorrowDate >= '2018-01-01') and (TBL_BorrowInfo.BorrowDate <= '2018-12-31')

SELECT     TBL_User.UserName, TBL_BorrowInfo.BorrowDate,TBL_BookInfo.BookName 
from TBL_BookInfo,TBL_BorrowInfo,TBL_User
where 
TBL_BookInfo.BookID = TBL_BorrowInfo.BookID and TBL_user.UserID = TBL_BorrowInfo.UserID
and  (TBL_BorrowInfo.BorrowDate >= '2018-01-01') and (TBL_BorrowInfo.BorrowDate <= '2018-12-31')

--	查询与《管理信息系统原理与实践》同一出版社的所有图书的信息。
select * from TBL_BookInfo
where TBL_BookInfo.Publisher in(select publisher from TBL_BookInfo where bookname='管理信息系统原理与实践')

--	显示大于平均页数的图书的书名、作者、出版日期。
select bookname,author,publishdate,PageCount from TBL_BookInfo
where PageCount > (select avg(pagecount) from TBL_BookInfo)

--	查询出最早被借的书的信息.
select * from TBL_BookInfo where bookid in(
select top 1 with ties BookID from TBL_BorrowInfo order by BorrowDate)

--	查询出版书籍最多的出版社所出版的所有图书的信息。
select * from TBL_BookInfo
where TBL_BookInfo.Publisher in(
select top 1 with ties  publisher from TBL_BookInfo group by Publisher order by count(*) desc)

--查询某个用户借阅时间超过3个月未归还的图书信息和读者信息
select TBL_BookInfo.*,TBL_User.* from TBL_BorrowInfo
inner join TBL_BookInfo on TBL_BookInfo.BookID = TBL_BorrowInfo.BookID
inner join TBL_User on TBL_User.UserID = TBL_BorrowInfo.UserID
where TBL_BorrowInfo.BorrowID in(
select BorrowID from TBL_BorrowInfo where DATEDIFF(MONTH,BorrowDate,getdate())>=3 and IsResturned=0)


--查询人气最旺的图书的出版社

select publisher from TBL_BookInfo where bookid in
(select top 1 with ties bookid from TBL_BorrowInfo group by BookID order by count(*) desc)

--查询未归还图书超过3本的用户信息

select * from TBL_User where userid in(
select userid from TBL_BorrowInfo where IsResturned=0 group by userid having count(*)>=3)


--查询姓刘的作者，图书分类为工业技术，未被借阅的图书信息
select * from TBL_BookInfo
inner join TBL_BookClass on TBL_BookClass.ClassID = TBL_BookInfo.ClassID
where bookid not in(
select distinct bookid from TBL_BorrowInfo)
and  TBL_BookInfo.Author like '刘%' and TBL_BookClass.ClassName ='工业技术'

--更改，原查询是“查询姓刘的作者，图书分类为工业技术，未归还的图书信息”
select * from TBL_BookInfo
inner join TBL_BookClass on TBL_BookClass.ClassID = TBL_BookInfo.ClassID
where bookid in(
select distinct bookid from TBL_BorrowInfo where IsResturned=0)
and  TBL_BookInfo.Author like '刘%' and TBL_BookClass.ClassName ='工业技术'