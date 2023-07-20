WITH orders AS (
    SELECT
        *
    FROM
        {{ ref("stg_orders") }}
),
daily AS (
    SELECT
        order_date,
        COUNT(*) AS num_orders,
        {% for order_status in ['returned', 'completed', 'return_pending', 'shipped', 'placed'] %}
            SUM(
                CASE
                    WHEN status = '{{order_status}}' THEN 1
                    ELSE 0
                END
            ) AS {{ order_status }}_total {{ ',' if not loop.last }}
        {% endfor %}
    FROM
        orders
    GROUP BY
        1
)
SELECT
    *
FROM
    daily