#!/bin/bash

# PostgreSQL command setup
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query database for element properties using atomic number symbol, or name
RESULT=$($PSQL "SELECT e.name, e.symbol, p.atomic_number, p.atomic_mass, t.type, p.melting_point_celsius, p.boiling_point_celsius
                FROM elements e
                JOIN properties p ON e.atomic_number = p.atomic_number
                JOIN types t ON p.type_id = t.type_id
                WHERE e.atomic_number::text = '$1' OR e.symbol = '$1' OR e.name = '$1';")

# Check if query returned any result
if [ -z "$RESULT" ]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse the query result
IFS="|" read name symbol atomic_number atomic_mass type melting_point boiling_point <<< "$RESULT"

# Output
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
