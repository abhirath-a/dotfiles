#!/run/current-system/sw/bin/bash

year=$(( RANDOM % 27 + 2000 ))
question=$(( RANDOM % 25 + 1 ))

options_type=("10" "12")
options_letter=("A" "B")

contest_type=${options_type[$(( RANDOM % 2 ))]}
letter_type=${options_letter[$(( RANDOM % 2 ))]}

url="https://artofproblemsolving.com/wiki/index.php?title=${year}_AMC_${contest_type}${letter_type}_Problems/Problem_${question}"

if command -v xdg-open &> /dev/null; then
    xdg-open "$url"
fi
echo "URL is: $url"
