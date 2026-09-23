{{ config(materialized='table') }}


select
   cast(t.transaction_datetime as date) as transaction_date,
   sum(case when s.movement_type = 'DEBIT' then s.amount else 0 end) as total_outflow_debit,
   sum(case when s.movement_type = 'CREDIT' then s.amount else 0 end) as total_inflow_credit,
   (
       sum(case when s.movement_type = 'CREDIT' then s.amount else 0 end) -
       sum(case when s.movement_type = 'DEBIT' then s.amount else 0 end)
   ) as reconciliation_difference
from {{ ref('gold_account_statement') }} s
join {{ ref('slv_transactions') }} t on s.transaction_id = t.transaction_id
where s.status = 'SUCCESS'
group by 1
