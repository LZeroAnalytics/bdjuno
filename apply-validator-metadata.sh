#!/bin/bash
set -e

HASURA_URL=${1:-"http://localhost:8080"}
ADMIN_SECRET=${2:-"myadminsecretkey"}

echo "Applying validator metadata fix..."

cd /callisto

echo "Clearing existing metadata cache..."
curl -X POST \
  ${HASURA_URL}/v1/metadata \
  -H 'Content-Type: application/json' \
  -H "X-Hasura-Admin-Secret: ${ADMIN_SECRET}" \
  -d '{"type": "clear_metadata", "args": {}}'

echo "Applying metadata..."
hasura-cli metadata apply --endpoint ${HASURA_URL} --admin-secret ${ADMIN_SECRET}

echo "Reloading metadata to refresh schema..."
hasura-cli metadata reload --endpoint ${HASURA_URL} --admin-secret ${ADMIN_SECRET}

echo "Metadata application complete!"
echo "Testing validator_descriptions relationship..."

curl -X POST \
  ${HASURA_URL}/v1/graphql \
  -H 'Content-Type: application/json' \
  -H "X-Hasura-Admin-Secret: ${ADMIN_SECRET}" \
  -d '{
    "query": "query TestValidatorDescriptions { validator(limit: 1) { consensus_address validator_descriptions(limit: 1, order_by: {height: desc}) { moniker identity } } }"
  }'
