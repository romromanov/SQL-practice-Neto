/*Задание №1
Выведите для каждого покупателя его адрес проживания, город и страну проживания.
В результирующей таблице должны быть следующие столбцы: Имя пользователя, фамилия пользователя, адрес, город, страна.*/
select first_name as "Имя пользователя", last_name as "фамилия пользователя", address as адрес, city as город, country as страна
from customer cu join address a on cu.address_id = a.address_id 
join city ci on a.city_id = ci.city_id 
join country co on ci.country_id = co.country_id

/*Задание №2.1
С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
В результирующей таблице должны быть следующие столбцы: Идентификатор магазина, количество прикрепленных пользователей.*/
select store_id, count(customer_id)
from customer
group by store_id

/*Задание №2.2
Доработайте запрос и выведите только те магазины, у которых количество покупателей больше 300-от.
Для решения используйте фильтрацию по сгруппированным строкам с использованием функции агрегации.
В результирующей таблице должны быть следующие столбцы: Идентификатор магазина, количество прикрепленных пользователей.*/
select store_id, count(customer_id)
from customer
group by store_id
having count(customer_id) > 300

/*Задание №2.3
Доработайте запрос, добавив в него информацию о городе магазина, а также фамилию и имя продавца, который работает в этом магазине.
В результирующей таблице должны быть следующие столбцы: Фамилия и имя сотрудника в виде одного значения, идентификатор магазина, 
город нахождения магазина, количество прикрепленных пользователей.*/
select s2.store_id, count(customer_id), concat(s.first_name,' ' ,s.last_name) 
from city c2 
join address a on c2.city_id = a.city_id
join store s2 on a.address_id = s2.address_id
join customer c on s2.store_id = c.store_id
join staff s on c.store_id = s.store_id 
group by s2.store_id, s.first_name, s.last_name 
having count(customer_id) > 300

/*Задание №3
Для каждого фильма посчитайте сколько раз его брали в прокат, при этом работать нужно только с теми фильмами, в которых снимались актрисы с именем Julia.
В результирующей таблице должны быть следующие столбцы: Название фильма, количество аренд.*/
select title, count(*) 
from actor a 
join film_actor fa on a.actor_id = fa.actor_id
join film f on f.film_id = fa.film_id
join inventory i on f.film_id = i.film_id 
join rental r on r.inventory_id = i.inventory_id 
where first_name ilike 'Julia'
group by title

-- Вариант 2 (с подзапросом)
/*select title, count(*) 
from 
	(select * from actor a 
	where first_name ilike 'Julia') as aj
join film_actor fa on aj.actor_id = fa.actor_id
join film f on f.film_id = fa.film_id
join inventory i on f.film_id = i.film_id 
join rental r on r.inventory_id = i.inventory_id 
group by title*/

/*Задание №4
Посчитайте для каждого покупателя 4 аналитических показателя:
1. количество фильмов, которые он взял в аренду
2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
3. минимальное значение платежа за аренду фильма
4. максимальное значение платежа за аренду фильма
В результирующей таблице должны быть следующие столбцы: Фамилия и имя пользователя в виде одного значения,
количество арендованных фильмов, округленная сумма платежей, минимальный и максимальный платеж.*/
select concat(c.first_name,' ' ,c.last_name) as "Фамилия и имя", count(*) as "количество арендованных фильмов", round(sum(amount)) as "сумма платежей", min(amount) as "минимальный платеж", max(amount) as "максимальный платеж" 
from customer c 
join rental r on r.customer_id = c.customer_id 
join payment p on p.customer_id = c.customer_id 
group by concat(c.first_name,' ' ,c.last_name)

/*Задание №5
Используя данные из таблицы городов, составьте все возможные пары городов так, чтобы в результате не было пар с одинаковыми названиями городов. 
Решение должно быть через Декартово произведение.
В результирующей таблице должны быть следующие столбцы: два столбца с названиями городов.*/
SELECT c.city, c2.city
FROM city c
CROSS JOIN city c2
WHERE c.city <> c2.city

/*Задание №6
Выведите наиболее и наименее востребованные категории фильмов (те, которые арендовали наибольшее/наименьшее количество раз), количество аренд и сумму продаж.
В результирующей таблице должны быть следующие столбцы: Название категории, количество аренд, сумма продаж.*/
select * 
 from 
	(select c.name as "Название категории", count(r.rental_id) as "Количество аренд", sum(p.amount ) as "Cумма продаж" 
	from category c 
	join film_category fc on c.category_id = fc.category_id 
	join film f on f.film_id = fc.film_id 
	join inventory i on i.film_id = f.film_id
	join rental r on r.inventory_id = i.inventory_id 
	join payment p on p.rental_id = r.rental_id 
	group by c.name)
where "Количество аренд" in (
				(select max(count) 
				from 
					(select c.name, count(r.rental_id), sum(p.amount) 
					from category c 
					join film_category fc on c.category_id = fc.category_id 
					join film f on f.film_id = fc.film_id 
					join inventory i on i.film_id = f.film_id
					join rental r on r.inventory_id = i.inventory_id 
					join payment p on p.rental_id = r.rental_id 
					group by c.name)
				)
			, 
				(select min(count) 
				from 
					(select c.name, count(r.rental_id), sum(p.amount) 
					from category c 
					join film_category fc on c.category_id = fc.category_id 
					join film f on f.film_id = fc.film_id 
					join inventory i on i.film_id = f.film_id
					join rental r on r.inventory_id = i.inventory_id 
					join payment p on p.rental_id = r.rental_id 
					group by c.name)
				)
				)

--Дополнительная часть:
/*Задание №1
Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
В результирующей таблице должны быть следующие столбцы: Название фильма, рейтинг фильма, язык фильма, категория фильма, 
количество аренд фильма, общий размер платежей по фильму.*/
select title as "Название фильма", rating as "рейтинг фильма", l.name as "язык фильма", c.name as "категория фильма", count(*) as "количество аренд фильма", sum(amount) as "общий размер платежей по фильму"
from category c 
join film_category fc on c.category_id =fc.category_id 
join film f on f.film_id = fc.film_id 
join language l on l.language_id = f.language_id 
join inventory i on f.film_id = i.film_id 
join rental r on r.inventory_id = i.inventory_id 
join payment p on r.rental_id = p.rental_id 
group by title, rating, l.name, c.name
order by title

/*Задание №2
Доработайте запрос из предыдущего задания и выведите с помощью него фильмы, которые отсутствуют на dvd дисках.
В результирующей таблице должны быть следующие столбцы: Название фильма, рейтинг фильма, язык фильма, категория фильма, 
количество аренд фильма, общий размер платежей по фильму.*/
select title as "Название фильма", rating as "рейтинг фильма", l.name as "язык фильма", c.name as "категория фильма", count(*) as "количество аренд фильма", sum(amount) as "общий размер платежей по фильму"
from payment p 
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id 
right join film f on f.film_id = i.film_id 
join language l on l.language_id = f.language_id
join film_category fc on f.film_id = fc.film_id 
join category c on c.category_id = fc.category_id 
where i.inventory_id is null
group by title, rating, l.name, c.name
