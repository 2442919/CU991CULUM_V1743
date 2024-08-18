#!/bin/bash

# Función para obtener la entrada del usuario
get_input() {
    read -p "$1: " input
    echo "$input"
}

# Función para recopilar múltiples líneas de entrada
get_multiline_input() {
    echo "$1 (escribe 'done' para terminar):"
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

# Función principal para generar el CV y la carta de presentación
generate_cv() {
    name=$(get_input "Introduce tu nombre completo")
    email=$(get_input "Introduce tu correo electrónico")
    phone=$(get_input "Introduce tu número de teléfono")
    address=$(get_input "Introduce tu dirección")

    education=$(get_multiline_input "Introduce los detalles de tu educación (por ejemplo, Título, Institución, Año)")
    experience=$(get_multiline_input "Introduce los detalles de tu experiencia laboral (por ejemplo, Cargo, Empresa, Años)")
    skills=$(get_multiline_input "Introduce tus habilidades (por ejemplo, Python, Gestión de Proyectos)")
    languages=$(get_multiline_input "Introduce los idiomas que conoces (por ejemplo, Inglés, Español)")

    cover_letter=$(get_multiline_input "Introduce tu carta de presentación")

    cv_content=$(cat <<EOF
Curriculum Vitae

Información Personal:
---------------------
Nombre: $name
Correo Electrónico: $email
Teléfono: $phone
Dirección: $address

Educación:
----------
$education

Experiencia Laboral:
--------------------
$experience

Habilidades:
------------
$skills

Idiomas:
--------
$languages

Carta de Presentación:
----------------------
$cover_letter
EOF
    )

    # Guarda el contenido del CV en un archivo txt
    echo -e "$cv_content" > cv.txt
    echo "Tu CV ha sido generado y guardado como 'cv.txt'."

    # Pregunta si el usuario desea exportar a PDF y DOCX
    read -p "¿Deseas exportar el CV a PDF y DOCX? (sí/no): " export_choice
    if [[ "$export_choice" == "sí" ]]; then
        # Verifica si pandoc está instalado
        if command -v pandoc &> /dev/null; then
            # Convierte txt a pdf y docx usando pandoc
            pandoc cv.txt -o cv.pdf
            pandoc cv.txt -o cv.docx
            echo "Tu CV ha sido guardado como 'cv.pdf' y 'cv.docx'."
        else
            echo "Pandoc no está instalado. Por favor, instálalo para exportar el CV a PDF y DOCX."
            echo "Tu CV ha sido generado y guardado solo como 'cv.txt'."
        fi
    else
        echo "Tu CV ha sido generado y guardado solo como 'cv.txt'."
    fi
}

# Verifica si pandoc está instalado
if ! command -v pandoc &> /dev/null; then
    echo "Pandoc no está instalado. Para exportar a PDF y DOCX, por favor instala pandoc."
fi

generate_cv
