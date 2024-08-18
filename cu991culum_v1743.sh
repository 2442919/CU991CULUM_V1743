#!/bin/bash

# Function to get user input
# Función para obtener la entrada del usuario
# Funcție pentru a obține input-ul utilizatorului
get_input() {
    read -p "$1: " input
    echo "$input"
}

# Function to collect multiple lines of input
# Función para recopilar múltiples líneas de entrada
# Funcție pentru a colecta mai multe linii de input
get_multiline_input() {
    echo "$1 (escribe 'done' para terminar):"  # Spanish
    echo "$1 (scrie 'done' pentru a încheia):" # Romanian
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

# Function to convert Arabic numbers to Roman numerals
# Función para convertir números arábigos a números romanos
# Funcție pentru a converti numerele arabe în romane
arabic_to_roman() {
    local num=$1
    local roman=""
    local values=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
    local numerals=("M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I")
    
    for i in "${!values[@]}"; do
        while ((num >= values[i])); do
            roman+="${numerals[i]}"
            ((num -= values[i]))
        done
    done
    echo "$roman"
}

# Main function to generate the CV
# Función principal para generar el CV
# Funcție principală pentru a genera CV-ul
generate_cv() {
    language=$1
    if [[ "$language" == "en" ]]; then
        prompt_name="Enter your full name"
        prompt_email="Enter your email address"
        prompt_phone="Enter your phone number"
        prompt_address="Enter your address"
        prompt_education="Enter your education details (e.g., Degree, Institution, Year)"
        prompt_experience="Enter your work experience details (e.g., Position, Company, Years)"
        prompt_skills="Enter your skills (e.g., Python, Project Management)"
        prompt_languages="Enter the languages you know (e.g., English, Spanish)"
        prompt_cover_letter="Enter your cover letter"
        prompt_export="Do you want to export the CV to PDF and DOCX? (yes/no)"
        msg_export_installed="Your CV has been saved as 'cv.pdf' and 'cv.docx'."
        msg_export_not_installed="Pandoc is not installed. Please install it to export the CV to PDF and DOCX."
        msg_saved="Your CV has been saved as 'cv.txt'."
        msg_no_pandoc="Pandoc is not installed. To export to PDF and DOCX, please install pandoc."
    elif [[ "$language" == "es" ]]; then
        prompt_name="Introduce tu nombre completo"
        prompt_email="Introduce tu correo electrónico"
        prompt_phone="Introduce tu número de teléfono"
        prompt_address="Introduce tu dirección"
        prompt_education="Introduce los detalles de tu educación (por ejemplo, Título, Institución, Año)"
        prompt_experience="Introduce los detalles de tu experiencia laboral (por ejemplo, Cargo, Empresa, Años)"
        prompt_skills="Introduce tus habilidades (por ejemplo, Python, Gestión de Proyectos)"
        prompt_languages="Introduce los idiomas que conoces (por ejemplo, Inglés, Español)"
        prompt_cover_letter="Introduce tu carta de presentación"
        prompt_export="¿Deseas exportar el CV a PDF y DOCX? (sí/no)"
        msg_export_installed="Tu CV ha sido guardado como 'cv.pdf' y 'cv.docx'."
        msg_export_not_installed="Pandoc no está instalado. Por favor, instálalo para exportar el CV a PDF y DOCX."
        msg_saved="Tu CV ha sido generado y guardado como 'cv.txt'."
        msg_no_pandoc="Pandoc no está instalado. Para exportar a PDF y DOCX, por favor instala pandoc."
    elif [[ "$language" == "ro" ]]; then
        prompt_name="Introduceți numele complet"
        prompt_email="Introduceți adresa de email"
        prompt_phone="Introduceți numărul de telefon"
        prompt_address="Introduceți adresa"
        prompt_education="Introduceți detaliile educației dvs. (de exemplu, Diplomă, Instituție, An)"
        prompt_experience="Introduceți detaliile experienței dvs. (de exemplu, Funcție, Companie, Ani)"
        prompt_skills="Introduceți abilitățile dvs. (de exemplu, Python, Management de Proiecte)"
        prompt_languages="Introduceți limbile cunoscute (de exemplu, Engleză, Spaniolă)"
        prompt_cover_letter="Introduceți scrisoarea de intenție"
        prompt_export="Doriți să exportați CV-ul în PDF și DOCX? (da/nu)"
        msg_export_installed="CV-ul tău a fost salvat ca 'cv.pdf' și 'cv.docx'."
        msg_export_not_installed="Pandoc nu este instalat. Te rugăm să-l instalezi pentru a exporta CV-ul în PDF și DOCX."
        msg_saved="CV-ul tău a fost generat și salvat ca 'cv.txt'."
        msg_no_pandoc="Pandoc nu este instalat. Pentru a exporta în PDF și DOCX, te rugăm să instalezi pandoc."
    else
        echo "Invalid language choice."
        echo "Elección de idioma inválida."
        echo "Alegere de limbă nevalidă."
        exit 1
    fi

    name=$(get_input "$prompt_name")
    email=$(get_input "$prompt_email")
    phone=$(get_input "$prompt_phone")
    address=$(get_input "$prompt_address")

    education=$(get_multiline_input "$prompt_education")
    experience=$(get_multiline_input "$prompt_experience")
    skills=$(get_multiline_input "$prompt_skills")
    languages=$(get_multiline_input "$prompt_languages")

    cover_letter=$(get_multiline_input "$prompt_cover_letter")

    # Get current date
    # Obtén la fecha actual
    # Obțineți data curentă
    day=$(date +"%d")
    month=$(date +"%m")
    year=$(date +"%Y")

    # Convert date to Roman numerals
    # Convierte la fecha a números romanos
    # Convertiți data în numere romane
    day_roman=$(arabic_to_roman "$day")
    month_roman=$(arabic_to_roman "$month")
    year_roman=$(arabic_to_roman "$year")
    date_str="$day_roman.$month_roman.$year_roman A.C."

    # Create CV content
    # Crear contenido del CV
    # Crează conținutul CV-ului
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

Date:
-----
Date: $date_str

Signature: $name
EOF
    )

    # Save CV content to a txt file
    # Guarda el contenido del CV en un archivo txt
    # Salvează conținutul CV-ului într-un fișier txt
    echo -e "$cv_content" > cv.txt
    echo "$msg_saved"

    # Ask if the user wants to export to PDF and DOCX
    # Pregunta si el usuario desea exportar a PDF y DOCX
    # Întreabă dacă utilizatorul dorește să exporte în PDF și DOCX
    read -p "$prompt_export: " export_choice
    if [[ "$export_choice" == "sí" || "$export_choice" == "da" || "$export_choice" == "yes" ]]; then
        # Check if pandoc is installed
        # Verifica si pandoc está instalado
        # Verifică dacă pandoc este instalat
        if command -v pandoc &> /dev/null; then
            # Convert txt to pdf and docx using pandoc
            # Convierte txt a pdf y docx usando pandoc
            # Convertește txt în pdf și docx folosind pandoc
            pandoc cv.txt -o cv.pdf
            pandoc cv.txt -o cv.docx
            echo "$msg_export_installed"
        else
            echo "$msg_export_not_installed"
            echo "$msg_saved"
        fi
    else
        echo "$msg_saved"
    fi
}

# Ask in which language to complete the CV
# Pregunta en qué idioma desea completar el CV
# Întreabă în ce limbă dorește să completeze CV-ul
echo "Please choose the language for completing the CV:"
echo "1. English"
echo "2. Español"
echo "3. Română"
read -p "Enter 1, 2, or 3: " lang_choice

case $lang_choice in
    1)
        language="en"
        ;;
    2)
        language="es"
        ;;
    3)
        language="ro"
        ;;
    *)
        echo "Invalid choice."
        echo "Elección inválida."
        echo "Alegere nevalidă."
        exit 1
        ;;
esac

# Check if pandoc is installed
# Verifica si pandoc está instalado
# Verifică dacă pandoc este instalat
if ! command -v pandoc &> /dev/null; then
    echo "$msg_no_pandoc"
fi

generate_cv "$language"
