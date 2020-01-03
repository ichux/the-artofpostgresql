## artofpostgresql
I bought the [book](https://postgresql.thinkific.com/) and needed to bootstrap a docker container for it so 
I came up with this. The project has been structured in such a way that the necessary extensions, 
[ip4r](https://github.com/RhodiumToad/ip4r.git) and [postgresql-hll](https://github.com/citusdata/postgresql-hll.git), 
are present before you begin to dump the data.

## Assumptions
I assume that you will do the following things:
1. > git clone git@github.com:ichux/the-artofpostgresql artofpostgresql
2. > cd artofpostgresql
3. read the `note` section and resume on step 4 of this section
4. type `make bootstrap`
5. `Go do something else and come back some minutes later`. This is dependent on the speed of your connection though!

## Note
1. You can change the published port, `5440` to taste inside the [docker-compose.yml](docker-compose.yml)
2. You should rename your dump file to `appdev.dump` for the container to work properly. My own dump file was originally
named `appdev-1566753884415.dump`
3. There is a commented line when you type `make down`, be free to run that line to do final clean up
4. To see all commands you have access to, just type `make`. You can also alter the `Makefile` to taste
4. The [gui-connection.jpg](gui-connection.png) shows the parameters you can enter to access the DB in a GUI.
The password is empty

## In case
I added a commented out section that looks like this

```
docker-compose run --rm database pg_restore taop.dump -f taop.sql
$(APPDEV) -waq -f taop.sql
```
Uncomment that section if your dump file is named `taop.dump` and then comment out the section

```
docker-compose run --rm database pg_restore appdev.dump -f appdev.sql
$(APPDEV) -waq -f appdev.sql
```
These can be found in the `dumps` section of the Makefile.
The `taop.dump` file has more information than the `appdev.dump`

## Suggestions, improvements, errors?
I would love to see those PRs.