require 'sqlite3'

db = SQLite3::Database.open 'test.db'

create_accounts_sql = <<-SQL
  CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bank_code VARCHAR,
    account_number VARCHAR,
    account_branch VARCHAR
  )
SQL
db.execute(create_accounts_sql)

create_batch_payment_sql = <<-SQL
  CREATE TABLE IF NOT EXISTS batch_payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid VARCHAR
  )
SQL
db.execute(create_batch_payment_sql)

create_payments_sql = <<-SQL
  CREATE TABLE IF NOT EXISTS payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid VARCHAR,
    from_account_id INTEGER,
    to_account_id INTEGER,
    currency VARCHAR,
    amount FLOAT,
    pay_at DATE,
    batch_payment_id INTEGER,
    FOREIGN KEY(from_account_id) REFERENCES "accounts" (id),
    FOREIGN KEY(to_account_id) REFERENCES "accounts" (id)
    FOREIGN KEY(batch_payment_id) REFERENCES "batch_payments" (id)
  )
SQL
db.execute(create_payments_sql)

db.close
