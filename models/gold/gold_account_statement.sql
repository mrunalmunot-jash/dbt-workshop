{{ config(materialized='table') }}

select 
    t.transaction_id,
    t.transaction_datetime,
    t.from_account as account_id,
    'DEBIT' as movement_type,
    t.amount,
    t.channel,
    t.status
from {{ ref('slv_transactions') }} t

union all

select 
    t.transaction_id,
    t.transaction_datetime,
    t.to_account as account_id,
    'CREDIT' as movement_type,
    t.amount,
    t.channel,
    t.status
from {{ ref('slv_transactions') }} t