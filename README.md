# SH-backend
## Sinatra based, backend server for [SmartHome project](https://github.com/spearfisher/SmartHome).

### Installation on Raspberry Pi.
```
git clone https://github.com/spearfisher/SH-backend.git
cd SH-backend
```
### Set Environment Variable
  `SECRET_KEY = your_secret_key`

### Setup or Update database
  `ruby db/migrate/migration.rb`

### Run application
  `rackup`
