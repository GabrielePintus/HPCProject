#!/bin/bash
counter=1

file_path="size_values.txt"

while IFS= read -r line
do
    echo "Processing line $counter: $line"
    ((counter++))
done < "$file_path"


