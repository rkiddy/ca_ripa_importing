# Importing RIPA data from the state of California

Go to:

   https://openjustice.doj.ca.gov/data

Go to the section on "RIPA Stop Data" and download the zip files and unzip them.

To create the database and needed stuff:

     $ mysql
     mysql> create database ca_ripa;
     mysql> quit
     $ mysql ca_ripa < ca_ripa.sql
     $ find * -name \*.xlsx | sort | \
         awk '{print "insert into ripa_files values ("NR", '\''"$0"'\'');"}' | mysql ca_ripa
     $

This last will create all of the tables, put data into the cjis_codes table (from within the
ca_ripa.sql file) and put data into the ripa_files table.

Then do the standard stuff to use python:

     $ virtualenv .venv
     $ source .venv/bin/activate
     $ pip install -r requirements.txt
     (.venv) $ SQLALCHEMY_SILENCE_UBER_WARNING=1 python load.py

and wait... and wait... and wait.

Additionally, the 'tinyint' flag columns are set to 0 or 1, but some are NULL. I am setting
NULL values to 0. There may be much smarter things to do here, but this is what I have. Any
suggestions in the form of pull-requests would be appreciated.

     $ pk=`echo "select (count(0)+10000) from ca_ripa;" | mysql --skip-column-names ca_ripa`
     $ echo "desc ripa;" | mysql --skip-column-names ca_ripa | \
          awk 'BEGIN{FS="\t"}{if ($2 == "tinyint") print $1}' | \
          awk '{for (i=1;i<'$pk';i=i+10000) {
                    print "update ripa set "$0" = 0 where";
                    print "pk >= "i" and pk < "(i+10000)" and "$0" is NULL;"}' | \
          mysql -vvv ca_ripa

TODO This process is taking entirelty too long. There will be a much smarter way to do this.

# Fixes to the data.

The county.sql file and the county.sh script will create a "summaries" table, and then they
will create different summaries tables for each county for which there is data.

     $ bash county.sh | mysql -vvv ca_ripa

This will take more than a few minutes to run, but not very much more.

# "Light-time" analysis.

For an analysis of stops vis a vis the amount of available light, see the sunlight.md file.

