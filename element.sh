#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ ! $1 ]]
then
  echo Please provide an element as an argument.

  else
  if [[ $1 =~ ^[0-9]+$ ]]
    then
    ELEMENT_ATOMIC_NUMBER=$($PSQL "select e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements e inner join properties p on e.atomic_number = p.atomic_number inner join types t  on t.type_id = p.type_id where e.atomic_number = '$1'")
    if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
    then
      echo I could not find that element in the database.

    else
      IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_ATOMIC_NUMBER"
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius." 
    fi
  else
      ELEMENT_INFO=$($PSQL "select e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements e inner join properties p on e.atomic_number = p.atomic_number inner join types t  on t.type_id = p.type_id where symbol ='$1' or  name ='$1'")
      if [[ -z $ELEMENT_INFO ]]
      then
        echo I could not find that element in the database.

      else
        IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_INFO"
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      fi
  fi
fi
