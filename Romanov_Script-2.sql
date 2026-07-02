/*Задание 1
 * Напишите 3 SQL-запроса, которые выведут информацию о фильмах со специальным атрибутом “Behind the Scenes”.
В запросах должны использоваться разные операторы или функции для работы с массивами.
В результирующей таблице должны быть следующие столбцы: Название фильма, столбец со специальными атрибутами.*/
--Вариант 1:
select title, special_features
from film f
where special_features @> array['Behind the Scenes']

--Вариант 2:
select title, special_features
from film f
where 'Behind the Scenes' = any(special_features)

/*Задание 2
Получите из таблицы платежей за прокат фильмов информацию по платежам,
которые выполнялись в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно и стоимость которых превышает 1.00. Платежи нужно отсортировать по дате платежа.
В результирующей таблице должны быть следующие столбцы: идентификатор платежа, размер платежа, дата платежа.*/

select payment_id, amount, payment_date
from payment p
where payment_date::date between '17-06-2005' and '19-06-2005' and amount > 1
order by payment_date 

/*Задание №3
Выведите ТОП-5 покупателей, которые совершили платежи на наибольшую сумму.
В результирующей таблице должны быть следующие столбцы: Идентификатор пользователя, сумма платежей.*/

select customer_id, sum(amount)
from payment p
group by customer_id
order by sum desc 
limit 5

/* Задание 4
Получите количество предпочитаемых жанров для каждого пользователя.
В результирующей таблице должны быть следующие столбцы: Идентификатор пользователя, количество предпочитаемых жанров.*/

select customer_id, jsonb_array_length(preferences->'profile'->'favorite_genres')
from customer c 
where (preferences->'profile'->'favorite_genres')[0] is not null

/*Задание №5
Получите количество пользователей, у которых отключено уведомление по email.
В результирующей таблице должны быть следующие столбцы: Одно значение количества.*/

select count(customer_id)
from customer c
where (preferences->'notifications'->'email') = 'false'

/* Задание №6
Получите сколько заплатил каждый пользователь за прокат фильмов за каждый месяц.
В результирующей таблице должны быть следующие столбцы: Идентификатор пользователя, значение месяца, сумма платежей.
 */

select customer_id, date_trunc('month', payment_date) as month, sum(amount)
from payment p
group by customer_id, date_trunc('month', payment_date)
order by customer_id

/*Задание №7
Получите на какую сумму продал каждый сотрудник магазина.
В результирующей таблице должны быть следующие столбцы: Идентификатор сотрудника, сумма платежей. */
*select staff_id, sum(amount)
from payment p
group by staff_id *

/* Задание №8
Используя данные из таблицы rental о дате выдачи фильма в аренду и дате возврата, вычислите для каждого покупателя среднее количество дней, 
за которые он возвращает фильмы, округленное до сотых.
В результирующей таблице должны быть следующие столбцы: Идентификатор пользователя, среднее количество дней с учетом округления
 */

select customer_id, round(avg(return_date::date - rental_date::date),2)
from rental
group by customer_id
order by customer_id




