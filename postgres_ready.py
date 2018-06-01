#!/usr/bin/env python
import psycopg2
import click
import time
import sys


@click.command()
@click.option('--retries', default=10, help='Default 10 - Max number of connection retries.')
@click.option('--seconds', default=1, help='Default 1 - Seconds to wait between retries.')
@click.option('--db', default='postgres', help='Default \'postgres\' - Postgres db name.')
@click.option('--user', default='postgres', help='Default \'postgres\' - Postgres user name.')
@click.option('--password', default='mysecretpassword', help='Default \'mysecretpassword\' - Postgres password.')
@click.option('--host', default='localhost', help='Default \'localhost\' - Postgres ip or hostname.')
@click.option('--port', default=5432, help='Default 5432 - Postgres port.')
@click.option('--prevent_ssl', is_flag=True, help='Disabled by default - BE CAREFUL! This flag disables ssl for Postgres connection.')
def postgres_ready(retries, seconds, db, user, password, host, port, prevent_ssl):
    """
    This script accepts options as documented here but it also
    accepts environment variables! All the options can be passed
    as environment vars using uppercase and prefixing with 'POSTGRES_'

    For example:
    --db option can be alternatively passed as POSTGRES_DB environment
    variable.

    You can even mix environment variables and options. Enjoy!
    """
    credentials = {
        'dbname': db,
        'user': user,
        'password': password,
        'host': host,
        'port': port
    }

    if not prevent_ssl:
        credentials['sslmode'] = 'require'

    with click.progressbar(length=retries, label='Reaching Postgres') as bar:
        is_postgres_up = False
        for retry in range(retries):
            try:
                conn = psycopg2.connect(**credentials)
            except psycopg2.OperationalError:
                time.sleep(seconds)
                bar.update(retry + 1)
            else:
                conn.close()
                is_postgres_up = True
                bar.update(retries)
                break
        print('\n')
        if is_postgres_up:
            print('Postgres is up and running!')
            code = 0
        else:
            print('Could not connect to Postgres!')
            code = -1

        sys.exit(code)


if __name__ == '__main__':
    postgres_ready(auto_envvar_prefix='POSTGRES')
