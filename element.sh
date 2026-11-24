#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type,
                        p.atomic_mass, p.melting_point_celsius,
                        p.boiling_point_celsius
                 FROM elements e
                 JOIN properties p USING (atomic_number)
                 JOIN types t USING (type_id)
                 WHERE e.atomic_number::text = '$1'
                    OR e.symbol = '$1'
                    OR e.name = '$1'")

IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING <<< "$ELEMENT"

if [[ -z "$1" ]]; then
echo Please provide an element as an argument.
exit 0
fi

if [[ "$1" = "$ATOMIC_NUMBER" ]]; 
then
echo "The element with atomic number "$ATOMIC_NUMBER" is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi

if [[ "$1" = "$NAME" ]]; 
then
echo "The element with atomic number "$ATOMIC_NUMBER" is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi

if [[ "$1" = "$SYMBOL" ]]; 
then
echo "The element with atomic number "$ATOMIC_NUMBER" is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi

if [[ "$1" != "$SYMBOL" && "$1" != "$NAME" && "$1" != "$ATOMIC_NUMBER" ]]; 
then
echo "I could not find that element in the database."
fi
ge
