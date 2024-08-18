#!/bin/bash

# Funcție pentru a obține input de la utilizator
get_input() {
    read -p "$1: " input
    echo "$input"
}

# Funcție pentru a aduna multiple linii de input
get_multiline_input() {
    echo "$1 (tastează 'done' pentru a termina):"
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

# Funcție principală pentru a genera CV-ul și scrisoarea de intenție
generate_cv() {
    name=$(get_input "Introdu numele complet")
    email=$(get_input "Introdu email-ul")
    phone=$(get_input "Introdu numărul de telefon")
    address=$(get_input "Introdu adresa")

    education=$(get_multiline_input "Introdu detaliile educației (ex. Diplomă, Instituție, An)")
    experience=$(get_multiline_input "Introdu detaliile experienței profesionale (ex. Titlu de muncă, Companie, Ani)")
    skills=$(get_multiline_input "Introdu competențele (ex. Python, Management de proiect)")
    languages=$(get_multiline_input "Introdu limbile cunoscute (ex. Engleză, Spaniolă)")

    cover_letter=$(get_multiline_input "Introdu scrisoarea de intenție")

    cv_content=$(cat <<EOF
Curriculum Vitae

Informații personale:
---------------------
Nume: $name
Email: $email
Telefon: $phone
Adresă: $address

Educație:
----------
$education

Experiență profesională:
-------------------------
$experience

Competențe:
-----------
$skills

Limbi:
------
$languages

Scrisoare de intenție:
----------------------
$cover_letter
EOF
    )

    # Salvează conținutul CV-ului într-un fișier txt
    echo -e "$cv_content" > cv.txt
    echo "CV-ul tău a fost generat și salvat ca 'cv.txt'."

    # Întreabă dacă utilizatorul dorește exportul în PDF și DOCX
    read -p "Dorești să exporți CV-ul în PDF și DOCX? (da/nu): " export_choice
    if [[ "$export_choice" == "da" ]]; then
        # Verifică dacă pandoc este instalat
        if command -v pandoc &> /dev/null; then
            # Convertește txt în pdf și docx folosind pandoc
            pandoc cv.txt -o cv.pdf
            pandoc cv.txt -o cv.docx
            echo "CV-ul tău a fost salvat ca 'cv.pdf' și 'cv.docx'."
        else
            echo "Pandoc nu este instalat. Te rugăm să-l instalezi pentru a exporta CV-ul în PDF și DOCX."
            echo "CV-ul tău a fost generat și salvat doar ca 'cv.txt'."
        fi
    else
        echo "CV-ul tău a fost generat și salvat doar ca 'cv.txt'."
    fi
}

# Verifică dacă pandoc este instalat
if ! command -v pandoc &> /dev/null; then
    echo "Pandoc nu este instalat. Pentru a exporta în PDF și DOCX, te rugăm să instalezi pandoc."
fi

generate_cv
