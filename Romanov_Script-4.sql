-- Запросы создания таблиц
create table language (
language_id serial primary key, 
language_name varchar(25) not null unique
);

create table nationality (
    nationality_id serial primary key,
    nationality_name varchar(25) not null unique
);

create table country (
    country_id serial primary key,
    country_name varchar(50) not null unique
);

create table language_nationality (
    language_id integer not null,
    nationality_id integer not null,
    primary key (language_id, nationality_id),
    foreign key (language_id) references language(language_id) on delete cascade,
    foreign key (nationality_id) references nationality(nationality_id) on delete cascade
);

create table nationality_country (
    nationality_id integer not null,
    country_id integer not null,
    primary key (nationality_id, country_id),
    foreign key (nationality_id) references nationality(nationality_id) on delete cascade,
    foreign key (country_id) references country(country_id) on delete cascade
);

-- запросы по добавлению в каждую таблицу по 5 строк с данными
insert into language (language_name) values
    ('Английский'),
    ('Французский'),
    ('Русский'),
    ('Немецкий'),
    ('Итальянский');

insert into nationality (nationality_name) values
    ('Славяне'),
    ('Англосаксы'),
    ('Американцы'),
    ('Немцы'),
	('Французы');

insert into country (country_name) values
    ('Россия'),
    ('Германия'),
    ('США'),
    ('Франция'),
	('Италия');

insert into language_nationality (language_id, nationality_id) values
	(1, 2),
	(1, 3), 
	(2, 5), 
	(3, 1), 
	(4, 4); 

insert into nationality_country (nationality_id, country_id) values
    (1, 1),
    (2, 3),
    (3, 3),
    (4, 2),
	(5, 4);
