# Notes

## TODO:

- [ ] Adicionar tipo de pagamento;

## Drafts

require_relative './lib/models/payment.rb'
require_relative './lib/models/account.rb'
require_relative './lib/models/batch_payment.rb'

::Models::Payment.find_by(batch_payment_id: 1)


.header on
.mode column

## Tests
```ruby
payment_identifier = SecureRandom.uuid

Contract.define do
  payment payment_identifier do
    from      bank_code: 1, account_number: 123, account_branch: 123
    to        bank_code: 2, account_number: 321, account_branch: 321
    currency  'USD'
    amount    '100'
    pay_at    '2022-10-20'
  end
end

::Models::Payment.find_by(uuid: payment_identifier)

Contract.enqueued_to_process
```

```ruby
payment_identifier = SecureRandom.uuid

Contract.define do
  payment payment_identifier do
    from         bank_code: 1, account_number: 123, account_branch: 123
    to           bank_code: 2, account_number: 321, account_branch: 321
    currency     'USD'
    amount       '100'
    pay_at       '2022-10-20'
    repeat_times 6
    repeat_each  1.month
  end
end
Contract.process(payment_identifier)
Contract.enqueued_to_process
```


```ruby
identifier = SecureRandom.uuid

Contract.define do
  batch_payment identifier do
    from     bank_code: 1, account_number: 123, account_branch: 123
    pay_at   "2022-12-23"
    currency "BRL"

    payment do
      to        bank_code: 2, account_number: 321, account_branch: 321
      amount    "100"
    end

    payment do
      to        bank_code: 2, account_number: 4531, account_branch: 321
      amount    "100"
    end
  end
end

bp = Contract.process(identifier)
```
