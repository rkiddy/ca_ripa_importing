
# First create the state-wide summaries table

if [ "$1" = "" ]; then

    cat county.sql | sed 's/_XXX//' | sed 's/_YYY//' | grep -v 'where' ; echo ";"

    echo ""

    echo "select code from ripa_counties;" | \
        mysql --skip-column-names ca_ripa | \
        awk '{print "bash county.sh "$0}' | \
        bash

else

    cat county.sql | sed 's/_XXX/_'$1'/' | sed 's/XXX/'$1'/' | sed 's/_YYY/_summaries/'

    echo ""

fi

