#!/bin/bash

PSQL="psql -U freecodecamp -d periodic_table -t --no-align -c"

if [[ $1 ]];
then
  INPUT=$1
  if [[ $INPUT =~ ^[0-9]+$ ]];
  then
    QUERY_RESULT=$($PSQL "select e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                          from elements e inner join properties p on (e.atomic_number=p.atomic_number) inner join types t on (p.type_id=t.type_id)
                          where e.atomic_number= $INPUT;")
  else
    QUERY_RESULT=$($PSQL "select e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                          from elements e inner join properties p on (e.atomic_number=p.atomic_number) inner join types t on (p.type_id=t.type_id)
                          where e.symbol = '$INPUT' or e.name = '$INPUT';")
  fi

  if [[ -z $QUERY_RESULT ]];
  then
        echo "I could not find that element in the database."
  else
    echo $QUERY_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
else
  echo "Please provide an element as an argument."
fi
