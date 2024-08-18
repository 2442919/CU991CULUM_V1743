#!/bin/bash

# Function to get user input
get_input() {
    read -p "$1: " input
    echo "$input"
}

# Function to gather multiple lines of input
get_multiline_input() {
    echo "$1 (type 'done' to finish):"
    input=""
    while true; do
        read line
        if [[ "$line" == "done" ]]; then
            break
        fi
        input+="$line\n"
    done
    echo -e "$input"
}

# Main function to generate CV and cover letter
generate_cv() {
    name=$(get_input "Enter your full name")
    email=$(get_input "Enter your email")
    phone=$(get_input "Enter your phone number")
    address=$(get_input "Enter your address")

    education=$(get_multiline_input "Enter your education details (e.g., Degree, Institution, Year)")
    experience=$(get_multiline_input "Enter your work experience details (e.g., Job Title, Company, Years)")
    skills=$(get_multiline_input "Enter your skills (e.g., Python, Project Management)")
    languages=$(get_multiline_input "Enter the languages you know (e.g., English, Spanish)")

    cover_letter=$(get_multiline_input "Enter your cover letter")

    cv_content=$(cat <<EOF
Curriculum Vitae

Personal Information:
---------------------
Name: $name
Email: $email
Phone: $phone
Address: $address

Education:
----------
$education

Work Experience:
----------------
$experience

Skills:
-------
$skills

Languages:
----------
$languages

Cover Letter:
-------------
$cover_letter
EOF
    )

    # Save CV content to txt file
    echo -e "$cv_content" > cv.txt
    echo "Your CV has been generated and saved as 'cv.txt'."

    # Ask if user wants to export to PDF and DOCX
    read -p "Do you want to export the CV to PDF and DOCX? (yes/no): " export_choice
    if [[ "$export_choice" == "yes" ]]; then
        # Check if pandoc is installed
        if command -v pandoc &> /dev/null; then
            # Convert txt to pdf and docx using pandoc
            pandoc cv.txt -o cv.pdf
            pandoc cv.txt -o cv.docx
            echo "Your CV has been saved as 'cv.pdf' and 'cv.docx'."
        else
            echo "Pandoc is not installed. Please install it to export the CV to PDF and DOCX."
            echo "Your CV has been generated and saved only as 'cv.txt'."
        fi
    else
        echo "Your CV has been generated and saved only as 'cv.txt'."
    fi
}

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Pandoc is not installed. For exporting to PDF and DOCX, please install pandoc."
fi

generate_cv
