# billy
A really nice "bang for your buck" Docker image to quickly bootstrap your Django projects

### Bootstrap your project as fast as Billy `the Kid` draws it's gun =)
```shell
$ mkdir quickdrawproject
$ cd quickdrawproject
$ python3.6 -m venv .env
$ source .env/bin/activate
```
Blazing fast dependency setup - magic start's here
```shell
$ curl https://raw.githubusercontent.com/andreportela/billy/master/requirements.txt | grep '^[a-z]' | xargs pip install
$ django-admin startproject project .
```
### Quickly draw a simple database setup on your `settings.py`
```python
# bunch of other imports here
import dj_database_url as db
# bunch of other setup statements here
DATABASES = dict()
DATABASES['default'] = db.config()
```
Take a break from billy and just code your project ;)
### Create your custom `Dockerfile` with billy's huge boilerplate
```Docker
FROM andreportela/billy
ADD . ${BASE_FOLDER}
```
### Make a dirty quick `docker-compose.yml` just to try your shiny new project - polish it later =D
```yaml
version: "3"

services:
  db:
    image: postgres:10.4-alpine
    ports:
      - 5432:5432
    environment:
      - POSTGRES_PASSWORD=mysecretpassword

  quickdrawproject:
    build: .
    command: ["sh", "-c", "/postgres_ready.py --prevent_ssl --host=db && python manage.py migrate && exec gunicorn --access-logfile - -w 4 project.wsgi:application -b 0.0.0.0:80"]
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgres://postgres:mysecretpassword@db:5432/postgres
    ports:
      - 80:80
```
### Just run it!
```shell
$ docker-compose up
```
Now open your browser on http://localhost and see it working as fast as `Billy The Kid`!

--------

### TIPS

### When you want to use a specific version
Say you want to use billy v0.1.0:
1. Install local requirements from the `v0.1.0` version
```shell
$ curl https://raw.githubusercontent.com/andreportela/billy/v0.1.0/requirements.txt | grep '^[a-z]' | xargs pip install
```
2. Reference the given version on your `Dockerfile`
```Docker
FROM andreportela/billy:v0.1.0
ADD . ${BASE_FOLDER}
```
