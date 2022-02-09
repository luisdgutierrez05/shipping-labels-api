# Multi-carrier Shipping Labels API

## Description
A small API Rails microservice that allow us to generate shipping labels.

## Requirements
* Rails 7.0.1
* Ruby 3.0.3
* PostgreSQL
* Redis

## Getting started
To get started with the app, clone the repo and then install the needed gems:
```
$ cd /path/to/repos
$ git clone [shipping-labels-api](https://github.com/luisdgutierrez05/shipping-labels-api.git)
$ cd shipping-labels-api
$ bundle install
```

Next, setup the database:
```
$ cp config/database.yml.sample config/database.yml and add your Postgres settings.
$ rails db:setup
$ rails db:test:prepare
```

Finally, run the test suite to verify that everything is working correctly:
```
$ rspec
```

After running specs, open coverage/index.html in the browser of your choice:
```
open coverage/index.html
```

If the test suite passes, you'll be ready to run the app in a local server:
```
$ rails server or puma
```

# Code Overview

## Design

- [Database ERD](https://github.com/luisdgutierrez05/shipping-labels-api/blob/main/doc/diagrams/database-erd.pdf)


- Class diagram

![Class diagram](https://github.com/luisdgutierrez05/shipping-labels-api/blob/main/doc/diagrams/class-diagram.png)


- State Machine

![State Machine](https://github.com/luisdgutierrez05/shipping-labels-api/blob/main/doc/diagrams/state-machine-shipment-batch.png)


## Folders
- `app/controllers` - Contains the controllers where requests are routed to their actions, where we find and manipulate our models and return them for the views to render.
- `app/jobs` - Contains the background job classes to request shipment label information and request information per each ShipmentLabel and generate zip file.
- `app/lib` - Contains the FakeCarrier classes to handle FakerCarrier API interaction.
- `app/models` - Contains the database models for the application where we can define methods, validations, queries, and relations to other models.
- `app/serializers` - Contains the serializer where resource could defined the information that will be displayed on the
endpoint response.
- `app/services` - Contains the base adapter, class to call FakeCarrier lib, BatchGenerator to create a shipment batch and labels instances, RequestData to get shipment labels information per each shipment label instance, TemporalFileGenerator to generate a temporal file and ZipFileGenerator to generate the zip file with all the shipment label pdfs files.
- `config` - Contains configuration files for our Rails application and for our database, along with an `initializers` folder for scripts that get run on boot.
- `db` - Contains the migrations needed to create our database schema.

## Endpoints(3)
- [Postman collection](postman/shipping_labels_api.postman_collection.json)
- [Postman environment variables](postman/shipping_labels_api.postman_environment.json)

### Create Request Labels
```
Action: POST
URL: {{protocol}}://localhost:{{port}}/api/{{api_version}}/shipment_labels/requests
Headers: 'Content-Type': 'application/json'
Body params:
  {
    "data": {
      "shipment_labels": [
        {
          "carrier": "fake_carrier",
          "shipment": {
            "address_from": {
              "name": "Fernando López",
              "street1": "Av. Principal #123",
              "city": "Azcapotzalco",
              "province": "Ciudad de México",
              "postal_code": "02900",
              "country_code": "MX"
            },
            "address_to": {
              "name": "Isabel Arredondo",
              "street1": "Av. Las Torres #123",
              "city": "Puebla",
              "province": "Puebla",
              "postal_code": "72450",
              "country_code": "MX"
            },
            "parcels": [
              {
                "length": 40,
                "width": 40,
                "height": 40,
                "dimensions_unit": "CM",
                "weight": 5,
                "weight_unit": "KG"
              }
            ]
          }
        },
        {
          "carrier": "fake_carrier",
          "shipment": {
            "address_from": {
              "name": "Verónica Bravo",
              "street1": "Av. Adolfo Prieto #157-6",
              "city": "Nuevo León",
              "province": "Monterrey",
              "postal_code": "64010",
              "country_code": "MX"
            },
            "address_to": {
              "name": "Jorge Mendoza",
              "street1": "Calle 62 #2568",
              "city": "Mérida",
              "province": "Yucatán",
              "postal_code": "97000",
              "country_code": "MX"
            },
            "parcels": [
              {
                "length": 102,
                "width": 52,
                "height": 80,
                "dimensions_unit": "CM",
                "weight": 7.5,
                "weight_unit": "KG"
              }
            ]
          }
        },
        {
          "carrier": "fake_carrier",
          "shipment": {
            "address_from": {
              "name": "Leonardo Rodríguez",
              "street1": "Calz. Juárez #58",
              "city": "Morelia",
              "province": "Michoacan",
              "postal_code": "58070",
              "country_code": "MX"
            },
            "address_to": {
              "name": "Ruben Arroyo",
              "street1": "Calle Esteban Loera #428",
              "city": "Guadalajara",
              "province": "Jalisco",
              "postal_code": "44380",
              "country_code": "MX"
            },
            "parcels": [
              {
                "length": 52,
                "width": 98,
                "height": 52,
                "dimensions_unit": "CM",
                "weight": 3.68,
                "weight_unit": "KG"
              }
            ]
          }
        }
      ]
    }
  }
```
[Response sample](postman/response_samples/api/v1/shipment_labels/requests/create.json)

### Get Request Labels Status
```
Action: GET
URL: {{protocol}}://localhost:{{port}}/api/{{api_version}}/shipment_labels/requests/{{shipment_batch_id}}
Headers: 'Content-Type': 'application/json'
```
[Response sample](postman/response_samples/api/v1/shipment_labels/requests/show.json)

### Get Zip File
```
Action: GET
URL: {{protocol}}://localhost:{{port}}/api/{{api_version}}/shipment_labels/files/{{file_id}}
Headers: 'Content-Type': 'application/json'
```
[Response sample](spec/fixtures/shipment_labels/batch-example.zip)

## Author

* **Luis D. Gutiérrez**
