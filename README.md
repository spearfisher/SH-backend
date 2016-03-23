# SH-backend

### Installation
```
git clone https://github.com/spearfisher/SH-backend.git
cd SH-backend
```
### Setup or Update database
  `ruby db/migrate/migration.rb`

### Run application
```
for development:
  ruby app.rb

on raspberry as background process:
  thin -R app.rb  -a 127.0.0.1 -p 8080 start &
```
