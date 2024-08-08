/* ---- TOKENS ---- */

CREATE TABLE token
(
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE token_unit
(
    token_name TEXT NOT NULL REFERENCES token (name),
    denom      TEXT NOT NULL UNIQUE,
    exponent   INT  NOT NULL,
    aliases    TEXT[],
    price_id   TEXT
);


/* ---- TOKEN PRICES ---- */

CREATE TABLE token_price
(
    /* Needed for the below token_price function to work properly */
    id         SERIAL                      NOT NULL PRIMARY KEY,

    unit_name  TEXT                        NOT NULL REFERENCES token_unit (denom) UNIQUE,
    price      DECIMAL                     NOT NULL,
    market_cap BIGINT                      NOT NULL,
    timestamp  TIMESTAMP WITHOUT TIME ZONE NOT NULL
);
CREATE INDEX token_price_timestamp_index ON token_price (timestamp);


CREATE TABLE token_price_history
(
    id         SERIAL                      NOT NULL PRIMARY KEY,
    unit_name  TEXT                        NOT NULL REFERENCES token_unit (denom),
    price      DECIMAL                     NOT NULL,
    market_cap BIGINT                      NOT NULL,
    timestamp  TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT unique_price_for_timestamp UNIQUE (unit_name, timestamp)
);
CREATE INDEX token_price_history_timestamp_index ON token_price_history (timestamp);

-- Insert tokens
INSERT INTO token (name) VALUES
('coreum');

-- Insert token units
INSERT INTO token_unit (token_name, denom, exponent, aliases, price_id) VALUES
('coreum', 'coreum', 6, NULL, 'coreum');

-- Insert current token prices
INSERT INTO token_price (unit_name, price, market_cap, timestamp) VALUES
('coreum', 0, 0, '2024-08-07T12:00:00.000');

INSERT INTO token_price_history (unit_name, price, market_cap, timestamp) VALUES
('coreum', 0, 0, '2024-07-27T12:00:00.000'),
('coreum', 0, 0, '2024-07-28T13:00:00.000'),
('coreum', 0, 0, '2024-07-29T14:00:00.000'),
('coreum', 0, 0, '2024-07-30T15:00:00.000'),
('coreum', 0, 0, '2024-07-31T16:00:00.000'),
('coreum', 0, 0, '2024-08-01T17:00:00.000'),
('coreum', 0, 0, '2024-08-02T18:00:00.000'),
('coreum', 0, 0, '2024-08-03T19:00:00.000'),
('coreum', 0, 0, '2024-08-04T20:00:00.000'),
('coreum', 0, 0, '2024-08-05T21:00:00.000'),
('coreum', 0, 0, '2024-08-06T22:00:00.000'),
('coreum', 0, 0, '2024-08-07T13:00:00.000');
