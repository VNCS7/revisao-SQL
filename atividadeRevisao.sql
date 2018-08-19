USE master
IF EXISTS(select * from sys.databases where name='atividadeRevisao')
DROP DATABASE atividadeRevisao

CREATE DATABASE atividadeRevisao
USE atividadeRevisao

create table tarefa (
id int primary key identity (1,1),
titulo varchar(100) not null,
prazo_estimado date,
descricao varchar(250),
data_inicio date not null,
data_termino date,
idMetodologia int not null
)

create table pessoas (
id int primary key identity (1,1),
nome varchar(100),
email varchar(100),
sexo varchar(20)
)

create table rel_tarefa_pessoa (
id int primary key identity (1,1),
id_tarefa int,
id_pessoas int,

foreign key (id_pessoas) references pessoas (id),
foreign key (id_tarefa) references tarefa (id)
)

create table metodologia (
id int primary key identity (1,1),
titulo varchar(100),

foreign key (id) references tarefa (id)
)

insert into pessoas (nome, email, sexo)
values 
('André Nicolas','andreNicolas@gmail.com','masculino'),
('Isabelle Lorena','isabelleLorena@gmail.com','feminino'),
('Sérgio Filipe','sergioFilipe@gmail.com','feminino'),
('Vitor Hugo','vHugo@gmail.com','masculino'), 
('Vinicius','vncs@gmail.com','masculino'),
('Vinicius Zero Dois','zeroDois@gmail.com','masculino')


insert into tarefa (titulo,prazo_estimado,descricao,data_inicio,data_termino,idMetodologia)
values 
('Terminar Referencial','2018-07-28','Temrina Referencia Teorico do TCC','2018-07-13','2018-07-17',1),
('Levantamento de Custos','2018-07-19','Orçamento e custeamento do TCC','2018-07-21','2018-07-21',1),
('Levantamento de Requistios Funcionais e Não-Funcionais','2018-07-14','Levantamento de requisitos do TCC','2018-07-14','2018-07-12',3),
('Levantamento de Recursos necessários','2018-07-08','Descobrir recursos necessários para elaboração do TCC','2018-07-31','2018-07-11',2)

insert into rel_tarefa_pessoa
values (1,1),(1,2),(2,3),(3,4),(4,4)

insert into metodologia (titulo)
values ('Runrun.it'),('tags'),('GTD'),('Kanban')

---------------------------------------------------------------
--QUERY 1:
SELECT a.nome, b.id 
FROM pessoas as A
Left Join rel_tarefa_pessoa as B 
on a.id = B.id_pessoas where b.id_tarefa is null
---------------------------------------------------------------
--QUERY 2:
SELECT m.titulo as 'Metodologias mais utilizadas'
FROM metodologia as m
inner join tarefa as t
on m.id = t.idMetodologia
group by m.titulo order by COUNT(*) desc
---------------------------------------------------------------
--QUERY 3:
SELECT COUNT(*) as 'Homens que realizaram tarefas'
FROM pessoas as A
Left Join rel_tarefa_pessoa as B 
on a.id = B.id_pessoas where (b.id_tarefa is not null and a.sexo = 'masculino')

SELECT COUNT(*) as 'Mulheres que realizaram tarefas'
FROM pessoas as A
Left Join rel_tarefa_pessoa as B 
on a.id = B.id_pessoas where (b.id_tarefa is not null and a.sexo = 'feminino')
---------------------------------------------------------------
--QUERY 4:
SELECT a.nome as 'Atrasados'
FROM pessoas as A
Left Join rel_tarefa_pessoa as B 
on a.id = B.id_pessoas
join tarefa as c 
on c.id = b.id_pessoas
where c.data_termino > c.prazo_estimado
---------------------------------------------------------------
