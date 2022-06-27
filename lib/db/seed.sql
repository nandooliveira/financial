-- accounts
insert into accounts (bank_code, account_number, account_branch) values ('077', '123123', '0001');
insert into accounts (bank_code, account_number, account_branch) values ('077', '341231', '0002');
insert into accounts (bank_code, account_number, account_branch) values ('230', '984723', '0003');
insert into accounts (bank_code, account_number, account_branch) values ('453', '563413', '0004');
insert into accounts (bank_code, account_number, account_branch) values ('214', '624234', '0005');

-- batch_payments
insert into batch_payments (uuid) values ('755b0baf-db0e-4c72-9d74-95365ef120c9');
insert into batch_payments (uuid) values ('9fb7775b-1ed7-473b-b0ef-19b8c7f82202');

-- payments
insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
  values ('951863a4-499e-4767-b339-ef3b63a0a723', 1, 2, 'BRL', 234.23, '2022-01-02', null);
insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
  values ('fd42f065-27c3-4feb-b441-cf66b9eead2a', 3, 4, 'BRL', 23234.02, '2022-11-06', null);
insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
  values ('caf7fd1f-d580-4704-9d7c-a3a984527fa5', 1, 5, 'BRL', 23134.98, '2022-02-02', null);
insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
  values ('e1e4fde5-e233-4bf3-a018-9a4cb7747ee6', 3, 5, 'BRL', 23434.45, '2022-01-23', 1);
insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
  values ('06b9e0a5-f390-4d01-a9a4-519f7ca33437', 4, 2, 'BRL', 23434.87, '2022-09-22', 2);
insert into payments (uuid, from_account_id, to_account_id, currency, amount, pay_at, batch_payment_id)
  values ('3eecd7d1-02d5-489b-9b85-4b9da0df1fe7', 2, 3, 'BRL', 45234.65, '2022-01-12', 2);
