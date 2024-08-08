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
('coreum', 0.1, 0, '2024-08-07T12:00:00.000');

INSERT INTO token_price_history (unit_name, price, market_cap, timestamp) VALUES
INSERT INTO token_price_history (unit_name, price, market_cap, timestamp) VALUES
('coreum', 0.065781, 0, '2024-08-05T22:17:50.949'),
('coreum', 0.065741, 0, '2024-08-05T22:07:14.246'),
('coreum', 0.065572, 0, '2024-08-05T21:56:55.105'),
('coreum', 0.065575, 0, '2024-08-05T21:46:26.219'),
('coreum', 0.065399, 0, '2024-08-05T21:36:14.062'),
('coreum', 0.065143, 0, '2024-08-05T21:26:13.842'),
('coreum', 0.064971, 0, '2024-08-05T21:16:11.641'),
('coreum', 0.064916, 0, '2024-08-05T21:05:59.989'),
('coreum', 0.064752, 0, '2024-08-05T20:55:26.299'),
('coreum', 0.065222, 0, '2024-08-05T20:45:05.018'),
('coreum', 0.064889, 0, '2024-08-05T20:35:22.965'),
('coreum', 0.064969, 0, '2024-08-05T20:25:42.112'),
('coreum', 0.064709, 0, '2024-08-05T20:15:05.704'),
('coreum', 0.065089, 0, '2024-08-05T20:04:14.768'),
('coreum', 0.065354, 0, '2024-08-05T19:53:48.106'),
('coreum', 0.065254, 0, '2024-08-05T19:44:25.412'),
('coreum', 0.065391, 0, '2024-08-05T19:34:02.339'),
('coreum', 0.065306, 0, '2024-08-05T19:23:31.176'),
('coreum', 0.065468, 0, '2024-08-05T19:13:18.062'),
('coreum', 0.065797, 0, '2024-08-05T18:52:36.489'),
('coreum', 0.065823, 0, '2024-08-05T18:42:20.206'),
('coreum', 0.066079, 0, '2024-08-05T18:32:42.950'),
('coreum', 0.066546, 0, '2024-08-05T18:22:17.523'),
('coreum', 0.066675, 0, '2024-08-05T18:11:27.400'),
('coreum', 0.066708, 0, '2024-08-05T18:02:00.338'),
('coreum', 0.067019, 0, '2024-08-05T17:51:50.542'),
('coreum', 0.066641, 0, '2024-08-05T17:41:24.754'),
('coreum', 0.066590, 0, '2024-08-05T17:31:22.163'),
('coreum', 0.066673, 0, '2024-08-05T17:20:23.050'),
('coreum', 0.066227, 0, '2024-08-05T17:10:15.833'),
('coreum', 0.066217, 0, '2024-08-05T16:59:14.589'),
('coreum', 0.065968, 0, '2024-08-05T16:49:50.482'),
('coreum', 0.066027, 0, '2024-08-05T16:39:05.494'),
('coreum', 0.066262, 0, '2024-08-05T16:29:28.570'),
('coreum', 0.065875, 0, '2024-08-05T16:18:16.039'),
('coreum', 0.065756, 0, '2024-08-05T16:08:56.773'),
('coreum', 0.065690, 0, '2024-08-05T15:58:20.862'),
('coreum', 0.065558, 0, '2024-08-05T15:47:57.417'),
('coreum', 0.064619, 0, '2024-08-05T15:38:10.270'),
('coreum', 0.064748, 0, '2024-08-05T15:27:08.915'),
('coreum', 0.064327, 0, '2024-08-05T15:17:25.592'),
('coreum', 0.063868, 0, '2024-08-05T15:07:11.357'),
('coreum', 0.063438, 0, '2024-08-05T14:56:52.708'),
('coreum', 0.063274, 0, '2024-08-05T14:46:22.206'),
('coreum', 0.063012, 0, '2024-08-05T14:36:28.037'),
('coreum', 0.062577, 0, '2024-08-05T14:25:36.178'),
('coreum', 0.062074, 0, '2024-08-05T14:15:29.585'),
('coreum', 0.062391, 0, '2024-08-05T14:06:00.105'),
('coreum', 0.061204, 0, '2024-08-05T13:55:15.414'),
('coreum', 0.060369, 0, '2024-08-05T13:43:18.426'),
('coreum', 0.061330, 0, '2024-08-05T13:34:12.280'),
('coreum', 0.060425, 0, '2024-08-05T13:24:54.921'),
('coreum', 0.060508, 0, '2024-08-05T13:14:15.644'),
('coreum', 0.060532, 0, '2024-08-05T13:03:57.009'),
('coreum', 0.060514, 0, '2024-08-05T12:53:05.722'),
('coreum', 0.061078, 0, '2024-08-05T12:43:10.269'),
('coreum', 0.060972, 0, '2024-08-05T12:32:39.091'),
('coreum', 0.060623, 0, '2024-08-05T12:22:53.237'),
('coreum', 0.060767, 0, '2024-08-05T12:12:02.850'),
('coreum', 0.060743, 0, '2024-08-05T12:01:26.441'),
('coreum', 0.060768, 0, '2024-08-05T11:51:56.448'),
('coreum', 0.060159, 0, '2024-08-05T11:40:55.542'),
('coreum', 0.059769, 0, '2024-08-05T11:30:04.434'),
('coreum', 0.060714, 0, '2024-08-05T11:19:51.144'),
('coreum', 0.060598, 0, '2024-08-05T11:09:19.989'),
('coreum', 0.060770, 0, '2024-08-05T10:58:54.666'),
('coreum', 0.060985, 0, '2024-08-05T10:48:16.238'),
('coreum', 0.060455, 0, '2024-08-05T10:38:07.829');
