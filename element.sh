#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ $# -ne 1 ]; then
    echo "Please provide an element as an argument."
    exit 0
fi

# Escape single quotes in the argument and use double quotes around '$1' in the query
escaped_arg=$(echo "$1" | sed "s/'/''/g")
query="SELECT elements.atomic_number, elements.name, elements.symbol, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number WHERE CAST(elements.atomic_number AS TEXT) = '$escaped_arg' OR elements.symbol = '$escaped_arg' OR elements.name ILIKE '$escaped_arg';"
result=$($PSQL "$query")

if [ -z "$result" ]; then
    echo "I could not find that element in the database."
    exit 0
fi

IFS='|' read -ra element_info <<< "$result"
atomic_number="${element_info[0]}"
name="${element_info[1]}"
symbol="${element_info[2]}"
atomic_mass="${element_info[3]}"
melting_point="${element_info[4]}"
boiling_point="${element_info[5]}"

echo "The element with atomic number $atomic_number is $name ($symbol). It's a nonmetal, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."