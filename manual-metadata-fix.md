# Manual Hasura Metadata Fix for validator_descriptions

## Problem
The validator table is missing the array relationship `validator_descriptions` which causes the GraphQL error: "field 'validator_descriptions' not found in type: 'validator'"

## Solution Options

### Option 1: Use the automated script
```bash
chmod +x apply-validator-metadata.sh
./apply-validator-metadata.sh http://YOUR_HASURA_URL:8080 myadminsecretkey
```

### Option 2: Manual Hasura Console Fix
1. Open Hasura Console at http://YOUR_HASURA_URL:8080
2. Go to Data → validator table → Relationships tab
3. Click "Add Array Relationship"
4. Configure:
   - Name: `validator_descriptions`
   - Reference Table: `public.validator_description`
   - From: `consensus_address`
   - To: `validator_address`
5. Save the relationship

### Option 3: Direct API Call
```bash
curl -X POST \
  http://YOUR_HASURA_URL:8080/v1/metadata \
  -H 'Content-Type: application/json' \
  -H 'X-Hasura-Admin-Secret: myadminsecretkey' \
  -d '{
    "type": "create_array_relationship",
    "args": {
      "table": {"name": "validator", "schema": "public"},
      "name": "validator_descriptions",
      "using": {
        "foreign_key_constraint_on": {
          "table": {"name": "validator_description", "schema": "public"},
          "column": "validator_address"
        }
      }
    }
  }'
```

## Verification
Test with the GraphQL query in `test-validator-query.graphql` to ensure the relationship works.
