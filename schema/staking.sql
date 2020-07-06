CREATE TABLE staking_pool
(
    height            BIGINT                      NOT NULL PRIMARY KEY,
    timestamp         TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    bonded_tokens     BIGINT                      NOT NULL,
    not_bonded_tokens BIGINT                      NOT NULL
);

CREATE TABLE validator_uptime
(
    validator_address     TEXT   NOT NULL REFERENCES validator (consensus_address),
    height                BIGINT NOT NULL,
    signed_blocks_window  BIGINT NOT NULL,
    missed_blocks_counter BIGINT NOT NULL,
    PRIMARY KEY (validator_address, height)
);

CREATE TABLE validator_info
(
    consensus_address TEXT NOT NULL REFERENCES validator (consensus_address) UNIQUE PRIMARY KEY,
    operator_address  TEXT NOT NULL,
    moniker         TEXT     ,
	identity        TEXT    ,
	website         TEXT    ,
	security_contact TEXT,
	details         TEXT
);

CREATE TABLE validator_delegation
(
    consensus_address TEXT                        NOT NULL REFERENCES validator (consensus_address),
    delegator_address TEXT                        NOT NULL REFERENCES account (address),
    amount            COIN                        NOT NULL,
    height            BIGINT                      NOT NULL,
    timestamp         TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE validator_unbonding_delegation
(
    consensus_address    TEXT                        NOT NULL REFERENCES validator (consensus_address),
    delegator_address    TEXT                        NOT NULL REFERENCES account (address),
    amount               COIN                        NOT NUll,
    completion_timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    height               BIGINT                      NOT NULL,
    timestamp            TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE validator_redelegation
(
    delegator_address     TEXT                        NOT NULL REFERENCES account (address),
    src_validator_address TEXT                        NOT NULL REFERENCES validator (consensus_address),
    dst_validator_address TEXT                        NOT NULL REFERENCES validator (consensus_address),
    amount                COIN                        NOT NULL,
    height                BIGINT                      NOT NULL,
    completion_time       TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE validator_commission
(
    validator_address     CHARACTER VARYING(52) NOT NULL,
    timestamp             TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    commission            decimal	              NOT NULL,
    min_self_delegation    decimal              NOT NULL,
    height                BIGINT                NOT NULL,
    PRIMARY KEY (validator_address,height)
);