CREATE TABLE mailbox (
  username VARCHAR(255) PRIMARY KEY,
  password VARCHAR(255) NOT NULL,
  quota BIGINT NOT NULL,
  active TINYINT NOT NULL
);

INSERT INTO mailbox (username, password, quota, active)
VALUES ('test@example.test', '*', 104857600, 1);
