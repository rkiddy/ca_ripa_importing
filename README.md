# CA RIPA

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

Then do the standard stuff to use python:

     $ virtualenv .venv
     $ source .venv/bin/activate
     $ pip install -r requirements.txt
     (.venv) $ SQLALCHEMY_SILENCE_UBER_WARNING=1 python load.py

and wait... and wait... and wait.

Additionally:

     # The 'tinyint' flag columns are set to 0 or 1, but some are NULL. If not set on import, set them now.
     #
     # This takes a very, vary long time to run.

     $ echo "desc ripa;" | mysql --skip-column-names ca_ripa | \
          awk 'BEGIN{FS="\t"}{if ($2 == "tinyint") print $1}' | \
          awk '{print "update ripa set "$0" = 0 where "$0" is NULL;"}' | \
          mysql -vvv ca_ripa

     # This still takes a while but it does not suck up all the RAM in the computer.
     #
     # It is the same as above, but it puts it into 10000 row buckets.
     #
     # TODO: There is probably a much better way to do this, probably while importing the data from the xlsx.
     #
     $ echo "desc ripa;" | mysql --skip-column-names ca_ripa | \
          awk 'BEGIN{FS="\t"}{if ($2 == "tinyint") print $1}' | \
          awk '{for (i=1;i<11920000;i=i+10000)
                    print "update ripa set "$0" = 0 where pk >= "i" and pk < "(i+10000)" and "$0" is NULL;"}' | \
          mysql -vvv ca_ripa

