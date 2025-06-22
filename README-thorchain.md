# Thorchain Support for BDJuno

This document provides instructions for running BDJuno with Thorchain support.

## Overview

BDJuno has been extended to support Thorchain with the following features:
- Support for "thor" address prefix
- Custom message type handling for `/types.MsgSend`
- RUNE token price feed integration
- Thorchain-specific configuration template

## Configuration

### Thorchain-specific Config

Use the provided `config-thorchain.yaml` file which includes:

- **Address Prefix**: `thor` for Thorchain addresses
- **Native Token**: RUNE with 8 decimal places
- **Price Feed**: Configured for RUNE token with price_id "thorchain"
- **Modules**: Standard Cosmos SDK modules plus pricefeed

### Key Configuration Settings

```yaml
chain:
  bech32_prefix: thor  # Thorchain address prefix

pricefeed:
  tokens:
    - name: "Thorchain"
      units:
        - denom: "rune"
          exponent: 8
          price_id: "thorchain"
```

## Docker Setup

### Building the Docker Image

```bash
docker build -f Dockerfile.thorchain -t bdjuno-thorchain .
```

### Running with Docker

```bash
docker run -d \
  --name bdjuno-thorchain \
  -p 3000:3000 \
  -e DATABASE_URL="postgresql://user:password@host:port/dbname" \
  bdjuno-thorchain
```

## Local Development

### Prerequisites

- Go 1.20+
- PostgreSQL database
- Access to a Thorchain node (RPC and gRPC endpoints)

### Building from Source

```bash
make build
```

### Running BDJuno

```bash
./build/callisto parse config-thorchain.yaml
```

## Configuration Details

### Node Connection

Update the node configuration in `config-thorchain.yaml`:

```yaml
node:
  config:
    rpc:
      address: http://your-thorchain-node:27147
    grpc:
      address: your-thorchain-node:9090
```

### Database Configuration

Update the database settings:

```yaml
database:
  name: bdjuno_thorchain
  host: localhost
  port: 5432
  user: your_user
  password: your_password
```

## Message Type Support

BDJuno now supports Thorchain's custom message types:
- `/types.MsgSend` - Mapped to the bank module for proper handling

## Price Feed Integration

The RUNE token is configured for price feed integration:
- **Denom**: `rune`
- **Exponent**: 8 (8 decimal places)
- **Price ID**: `thorchain` (for external price feed services)

## Troubleshooting

### Common Issues

1. **Address Validation Errors**: Ensure `bech32_prefix: thor` is set in the configuration
2. **Message Parsing Errors**: Verify that custom message types are properly handled
3. **Database Connection**: Check database credentials and connectivity
4. **Node Connection**: Verify Thorchain node RPC/gRPC endpoints are accessible

### Validation Commands

Test configuration parsing:
```bash
./build/callisto parse config-thorchain.yaml --dry-run
```

Check database connection:
```bash
./build/callisto migrate up --config config-thorchain.yaml
```

## Support

For issues specific to Thorchain integration, refer to:
- [Thorchain Documentation](https://docs.thorchain.org/)
- [BDJuno Custom Chains Guide](https://docs.bigdipper.live/cosmos-based/parser/custom-chains)
