# Cin-UFPE - DSLs

DSLs para definição de contratos financeiros construída como parte da disciplina Domain Specific Languages do Centro de Informática da Universidade Federal de Pernambuco.

## Dependencies

* [Ruby](https://www.ruby-lang.org/en/).  

Written with version [3.1.0](https://www.ruby-lang.org/en/news/2021/12/25/ruby-3-1-0-released/) - *[docs](https://docs.ruby-lang.org/en/3.1.0/)*.

## Context

This DSLs, in this version, is going to be used to define Payments and BatchPayments in a financial system.

Payment example:

```ruby
payment_identifier = SecureRandom.uuid

Contract.define do
  payment payment_identifier do
    from      bank_code: 1, account_number: 123, account_branch: 123
    to        bank_code: 2, account_number: 321, account_branch: 321
    currency  "USD"
    amount    "100"
    pay_at    "2022-10-20"
  end
end

Contract.process(payment_identifier)
```

BatchPayments are is a payment where multiple people are going to be paid at once.

Example:

```ruby
payment_identifier = SecureRandom.uuid

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

Contract.process(payment_identifier)
```


## Usage

Install deps: `gem install bundler && bundle install`.

Run `bundle exec rake` to run the tests, or `bundle exec rake run` to run the program.

