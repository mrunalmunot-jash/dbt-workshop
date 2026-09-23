{{
    config(
        materialized='incremental',
        unique_key='transaction_id',
        on_schema_change='append_new_columns'
    )
}}

select 
    transaction_id,
    transaction_datetime,
    cast(transaction_datetime as date) as transaction_date,
    from_account,
    to_account,
    upper(trim(transaction_type)) as transaction_type,
    amount,
    upper(trim(status)) as status,
    upper(trim(channel)) as channel,
    trim(remarks) as remarks
from {{ ref('brz_transactions') }}

{% if is_incremental() %}
  where transaction_datetime >= (select max(transaction_datetime) from {{ this }})
{% endif %}