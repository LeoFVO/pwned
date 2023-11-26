# Pwned indexer & search engine

Pwned is an indexer and search engine made to easily store and search leaked databases rows.
The project is based on [Quickwit](https://quickwit.io/), a distributed search engine.

## Disclaimer

This project is made for educational purpose only.
We do not encourage the use of this project for illegal activities.
We are not responsible for any misuse of this project.

## Get Started

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### How the project works

The project is composed of 2 services:

- [Minio](https://min.io/): A S3 compatible storage service
- [Quickwit](https://quickwit.io/): A distributed search engine

For the example, we have a file containing leaked databases rows.
**It's important to note that the file must be a csv file with headers indicating search fields to map.**
More info on the last section of this README.

## Setup

### Setup quickwit server

```bash
docker run --rm --network host --env "QW_S3_ENDPOINT=http://127.0.0.1:9000" --env "AWS_ACCESS_KEY_ID=minio" --env "AWS_SECRET_ACCESS_KEY=minio123" leofvo/pwned:1.0
```

### Setup our infrastructure

```bash
cp .env.example .env
make start
```

### Create our index

An index is a collection of documents. Each document is a json object.
We need to create an index to be able to ingest data by specifying the fields we want to index.

```bash
./quickwit index create --index-config ./leaks.yml
```

## Test example data

### Ingest data

As our file are csv, we need to setup a source to transform them into json.
For this, you need to make sure the csv contains [headers that are supported by our application](#Search-fields).

```bash
python -c "import csv, json, sys; [print(json.dumps(dict(row))) for row in csv.DictReader(sys.stdin)]" < ./example.txt > output.json
```

Then we can ingest our data.

```bash
./quickwit index ingest --index leaks --input-path ./output.ndjson --force
```

We can also do this in one command.

```bash
./quickwit index ingest --index leaks --input-path <(python -c "import csv, json, sys; [print(json.dumps(dict(row))) for row in csv.DictReader(sys.stdin)]" < example.txt) --force
```

### Search leaks

We can now search our leaks.

#### Using the CLI

```bash
./quickwit index search --index leaks --query "phone_number:3622411259"
```

#### Using the API

```bash
curl -XPOST "http://localhost:7280/api/v1/leaks/search" -H 'Content-Type: application/json' -d '{
    "query": "phone_number:3622411259"
}'
```

## Search fields available

This are the fields available for the search engine.
They must be defined (caps-sensitive) in the csv headers of all ingested files.
Checkout the example.txt file if you don't understand.

```yml
- name: source # Source of the leak
  type: text
- name: username # Username of the user
  type: text
- name: firstname # Firstname of the user
  type: text
- name: lastname # Lastname of the user
  type: text
- name: ip # IP of the user
  type: text
- name: email # Email of the user
  type: text
- name: phone # Phone number of the user
  type: text
- name: password # Password of the user
  type: text
- name: password_hash # Hash of the password of the user
  type: text
- name: gender # Gender of the user
  type: text
- name: adress # Adress of the user
  type: text
- name: birthday # Birthday of the user
  type: text
- name: country # Country of the user
  type: text
- name: city # City of the user
  type: text
- name: created # Timestamp of the account creation
  type: text
- name: updated # Timestamp of the account creation
  type: text
- name: marital_status # Marital status of the user
  type: text
- name: title # Job title of the user
  type: text
- name: linked_website # Website linked to the user account leak
  type: text
```
