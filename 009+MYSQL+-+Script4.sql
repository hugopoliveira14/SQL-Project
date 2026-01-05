
/*==================================================================================
Curso: MYSQL

VIEWS                                                        
Vantagens das views                                          

Segurança
Você pode restringir o acesso dos usuários diretamente a uma tabela e permitir que acessem um subconjunto de dados por meio de VIEWS
Por exemplo, você pode permitir que os usuários acessem o nome do cliente, telefone, e-mail por meio de uma visualização,
mas restringi-los para acessar a conta bancária e outras informações confidenciais.

Simplicidade
Um banco de dados relacional pode ter muitas tabelas com relacionamentos complexos, por exemplo, um para um e um para muitos que tornam difícil a navegação.
No entanto, você pode simplificar as consultas complexas com associações e condições usando um conjunto de VIEWS

Consistência
Às vezes, você precisa escrever uma fórmula ou lógica complexa em cada consulta.
Para torná-lo consistente, você pode ocultar a lógica de consultas complexas e cálculos nas VIEWS
==================================================================================*/

SELECT
    *
FROM
customer;

-- CRIANDO A VIEW

CREATE VIEW vw_custumerMadrid
AS
SELECT
    *
FROM
customer where city ='Madrid';

-- verificar a view criada

-- chamar a view
select * from vw_custumerMadrid;

-- chamar a view com where
select   *
FROM vw_custumerMadrid
where phone like '%555%';

-- inserindo dados na tabela atraves da view
insert into vw_custumerMadrid (firstname, lastname, city, country, phone)
values ('sandro', 'servino de madrid', 'Madrid', 'espanha', '9999999');

insert into vw_custumerMadrid (firstname, lastname, city, country, phone)
values ('sandro', 'servino do porto', 'porto', 'portugal', '9999999');

select * from vw_custumerMadrid; -- nao trouxe o sandro da cidade do porto porque esta chamando a view que filtra apenas os clientes de madrid

SELECT * FROM customer where lastname = 'servino do porto'; -- e aqui vai trazer porque estou fazendo pesquisa diretamente na tabela

-- Deletando dados em tabela atraves da VIEW

delete  from vw_custumerMadrid where lastname = 'servino de madrid';

SELECT * FROM vw_custumerMadrid where lastname = 'servino de madrid';
SELECT * FROM customer where lastname = 'servino de madrid';

select   *
FROM vw_custumerMadrid
where phone like '%555%';

BEGIN;
delete from vw_custumerMadrid
where phone like '%555%';

select   *
FROM vw_custumerMadrid
where phone like '%555%';

ROLLBACK;

select   *
FROM vw_custumerMadrid
where phone like '%555%';

-- View com Join

CREATE VIEW dailysales
AS
SELECT
    year(orderdate) AS y,
    month(orderdate) AS m,
    day(orderdate) AS d,
    p.id,
    productname,
    quantity * i.unitprice AS sales
FROM
    CLIENTE2.Order AS o
INNER JOIN orderitem AS i
    ON o.id = i.orderid
INNER JOIN product AS p
    ON p.id = i.productid;

-- Depois apenas rode

SELECT *  FROM dailysales ORDER BY y, m, d, sales desc;

select y as ano, m as mes, sum(sales) as VendasMes
	from dailysales
	group by y, m
	order by ano ASC, mes DESC;

select y as ano, avg(sales) as VendasmediaANO
	from dailysales
	group by ANO
	order by Y asc;

-- PARA ALTERAR A VIEW ACRESCENTANDO DADOS DO CLIENTE

-- CREATE OR ALTER VIEW FUNCIONA APENAS NO SQL SERVER. 
CREATE OR ALTER VIEW dailysales
AS
SELECT
    year(orderdate) AS y,
    month(orderdate) AS m,
    day(orderdate) AS d,
    p.id,
    productname,
    quantity * i.unitprice AS sales,
    c.FIRSTNAME, 
    c.LASTNAME
FROM
    CLIENTE2.Order AS o
INNER JOIN customer as c
    ON c.id = o.customerid 
INNER JOIN orderitem AS i
    ON o.id = i.orderid
INNER JOIN product AS p
    ON p.id = i.productid;

SELECT *  FROM dailysales ORDER BY y, m, d, sales desc;

SELECT  CONCAT(FirstName , ' ' , LastName) AS NomeCompleto , sum(d.sales) AS vendas FROM dailysales d
group by d.FirstName, d.LastName
limit 5;

-- Deletar dados atraves de view que acessam varias tabelas
delete from dailysales;
-- verifique o erro> Can not delete from join view 'cliente2.dailysales'

truncate table cliente2.dailysales;
-- verifique o erro: Table 'cliente2.dailysales' doesn't exist
-- NAO É UMA TABELA PARA TER DADOS DELETADOS MAS SIM UMA VIEW


-- PARA DELETAR VIEW

DROP VIEW dailysales;

-- VERIFICAR SE A VIEW AINDA EXISTE

-- CRIAR NOVAMENTE A VIEW

CREATE VIEW dailysales
AS
SELECT
    year(orderdate) AS y,
    month(orderdate) AS m,
    day(orderdate) AS d,
    p.id,
    productname,
    quantity * i.unitprice AS sales,
    c.FIRSTNAME, 
    c.LASTNAME
FROM
    CLIENTE2.Order AS o
INNER JOIN customer as c
    ON c.id = o.customerid 
INNER JOIN orderitem AS i
    ON o.id = i.orderid
INNER JOIN product AS p
    ON p.id = i.productid;
    
-- DELETAR UMA VIEW DENTRO DE UMA TRANSACAO E DEPOIS REALIZAR ROLLBACK
    
BEGIN;
  DROP VIEW dailysales;
  
ROLLBACK; 
-- NAO FUNCIONA PARA CRIACAO DE OBJETOS E DELECAO DE OBJETOS, MAS SIM PARA TRANSACOES DENTRO DOS OBJETOS
-- NO MYSQL COMANDOS DO TIPO DDL COMO CREATE TABLE, ALTER TABLE, CREATE VIEW, DROP VIEW,... O MYSQL FAZ COMMIT IMPLICITO




