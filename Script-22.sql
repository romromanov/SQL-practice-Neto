/* Задание №1
Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
1.1 Пронумеруйте все платежи от 1 до N по дате платежа
1.2 Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате платежа
1.3 Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна быть сперва по дате платежа, 
а затем по размеру платежа от наименьшей к большей
1.4 Пронумеруйте платежи для каждого покупателя по размеру платежа от наибольшего к меньшему так, 
чтобы платежи с одинаковым значением имели одинаковое значение номера.
В результирующей таблице должны быть следующие столбцы: Идентификатор платежа, дата платежа, 
идентификатор пользователя, размер платежа, 4 столбца с результатами оконных функций.*/

select payment_id, payment_date, customer_id, amount,
row_number () over (order by payment_date) as payment_number_1,
row_number () over (partition by customer_id order by payment_date) as payment_number_2,
SUM(amount) over (
	partition by customer_id
	order by payment_date, amount),
dense_rank () over (partition by customer_id order by amount desc)
from payment p

/*Задание №2
С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость платежа из предыдущей строки 
со значением по умолчанию 0.0 с сортировкой по дате платежа.
В результирующей таблице должны быть следующие столбцы: Идентификатор платежа, дата платежа, 
идентификатор пользователя, текущий размер платежа, размер платежа из предыдущей строки.*/
select payment_id, payment_date, customer_id, amount, coalesce (lag (amount) over (partition by customer_id order by payment_date), 0.0)
from payment p

/*Задание №3
С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.
В результирующей таблице должны быть следующие столбцы: Идентификатор платежа, дата платежа, идентификатор пользователя, 
текущий размер платежа, следующий размер платежа, разница между текущим и следующим платежами.*/

with new_payment as (
	select payment_id, payment_date, customer_id, amount,
	coalesce (lead(amount) over (partition by customer_id order by payment_date), 0.0) as next_amount
	from payment
	)
select payment_id, payment_date, customer_id, amount, next_amount, amount-next_amount as delta
from new_payment


/*Задание №4
С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.
В результирующей таблице должны быть следующие столбцы: Все столбцы из таблицы с платежами.*/

with last_payment as (select *, row_number() over (partition by customer_id order by payment_date desc) as rn from payment)
select payment_id, customer_id, staff_id, rental_id, amount, payment_date
from last_payment
where rn = 1

/*Задание №5
Одним запросом ответить на два вопроса: в какой из месяцев было получено платежей на наибольшую сумму?
На какую сумму по отношению к предыдущему месяцу было сдано в аренду больше/меньше фильмов.
Обязательное условие для выполнения задания: Таблица payment должна быть использована строго один раз. Если в топ 1 попадает несколько месяцев, 
в результате должны быть все месяцы, попавшие в топ 1. Топ 1 месяц получать через оконную функцию.
В результирующей таблице должны быть следующие столбцы: Значение месяца, сумма за месяц, сумма за предыдущий месяц, разница между суммами.*/

with month_max as (
	select date_trunc('month', payment_date) as month,
    sum(amount) as monthly_sum,
    lag(sum(amount)) over (order by date_trunc('month', payment_date)) as prev_month_sum,
    sum(sum(amount)) over (order by date_trunc('month', payment_date)) as total,
    rank() over (order by sum(amount) desc) as rank_amount
    from payment
    group by date_trunc('month', payment_date)
    )
select to_char(month, 'yyyy-mm') as "значение месяца", monthly_sum as "сумма за месяц", coalesce(prev_month_sum, 0.0) as "сумма за предыдущий месяц", monthly_sum - coalesce(prev_month_sum, 0.0) as "разница между суммами"
from month_max
where rank_amount = 1
order by month

