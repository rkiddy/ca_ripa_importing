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

That is all.

