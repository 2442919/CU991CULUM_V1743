import os
import subprocess
import datetime

def get_input(prompt):
    return input(f"{prompt}: ")

def get_multiline_input(prompt):
    print(f"{prompt} (write 'done' to finish):")
    lines = []
    while True:
        line = input()
        if line.lower() == 'done':
            break
        lines.append(line)
    return "\n".join(lines)

def arabic_to_roman(num):
    val = [
        1000, 900, 500, 400,
        100, 90, 50, 40,
        10, 9, 5, 4,
        1
        ]
    syb = [
        "M", "CM", "D", "CD",
        "C", "XC", "L", "XL",
        "X", "IX", "V", "IV",
        "I"
        ]
    roman_num = ''
    i = 0
    while  num > 0:
        for _ in range(num // val[i]):
            roman_num += syb[i]
            num -= val[i]
        i += 1
    return roman_num

def generate_cv(language):
    if language == 'en':
        prompts = {
            "name": "Enter your full name",
            "email": "Enter your email address",
            "phone": "Enter your phone number",
            "address": "Enter your address",
            "education": "Enter your education details (e.g., Degree, Institution, Year)",
            "experience": "Enter your work experience details (e.g., Position, Company, Years)",
            "skills": "Enter your skills (e.g., Python, Project Management)",
            "languages": "Enter the languages you know (e.g., English, Spanish)",
            "cover_letter": "Enter your cover letter",
            "export": "Do you want to export the CV to PDF and DOCX? (yes/no)",
            "export_installed": "Your CV has been saved as 'cv.pdf' and 'cv.docx'.",
            "export_not_installed": "Pandoc is not installed. Please install it to export the CV to PDF and DOCX.",
            "saved": "Your CV has been saved as 'cv.txt'.",
            "no_pandoc": "Pandoc is not installed. To export to PDF and DOCX, please install pandoc."
        }
    elif language == 'es':
        prompts = {
            "name": "Introduce tu nombre completo",
            "email": "Introduce tu correo electrónico",
            "phone": "Introduce tu número de teléfono",
            "address": "Introduce tu dirección",
            "education": "Introduce los detalles de tu educación (por ejemplo, Título, Institución, Año)",
            "experience": "Introduce los detalles de tu experiencia laboral (por ejemplo, Cargo, Empresa, Años)",
            "skills": "Introduce tus habilidades (por ejemplo, Python, Gestión de Proyectos)",
            "languages": "Introduce los idiomas que conoces (por ejemplo, Inglés, Español)",
            "cover_letter": "Introduce tu carta de presentación",
            "export": "¿Deseas exportar el CV a PDF y DOCX? (sí/no)",
            "export_installed": "Tu CV ha sido guardado como 'cv.pdf' y 'cv.docx'.",
            "export_not_installed": "Pandoc no está instalado. Por favor, instálalo para exportar el CV a PDF y DOCX.",
            "saved": "Tu CV ha sido generado y guardado como 'cv.txt'.",
            "no_pandoc": "Pandoc no está instalado. Para exportar a PDF y DOCX, por favor instala pandoc."
        }
    elif language == 'ro':
        prompts = {
            "name": "Introduceți numele complet",
            "email": "Introduceți adresa de email",
            "phone": "Introduceți numărul de telefon",
            "address": "Introduceți adresa",
            "education": "Introduceți detaliile educației dvs. (de exemplu, Diplomă, Instituție, An)",
            "experience": "Introduceți detaliile experienței dvs. (de exemplu, Funcție, Companie, Ani)",
            "skills": "Introduceți abilitățile dvs. (de exemplu, Python, Management de Proiecte)",
            "languages": "Introduceți limbile cunoscute (de exemplu, Engleză, Spaniolă)",
            "cover_letter": "Introduceți scrisoarea de intenție",
            "export": "Doriți să exportați CV-ul în PDF și DOCX? (da/nu)",
            "export_installed": "CV-ul tău a fost salvat ca 'cv.pdf' și 'cv.docx'.",
            "export_not_installed": "Pandoc nu este instalat. Te rugăm să-l instalezi pentru a exporta CV-ul în PDF și DOCX.",
            "saved": "CV-ul tău a fost generat și salvat ca 'cv.txt'.",
            "no_pandoc": "Pandoc nu este instalat. Pentru a exporta în PDF și DOCX, te rugăm să instalezi pandoc."
        }
    else:
        print("Invalid language choice.")
        return

    name = get_input(prompts["name"])
    email = get_input(prompts["email"])
    phone = get_input(prompts["phone"])
    address = get_input(prompts["address"])
    education = get_multiline_input(prompts["education"])
    experience = get_multiline_input(prompts["experience"])
    skills = get_multiline_input(prompts["skills"])
    languages = get_multiline_input(prompts["languages"])
    cover_letter = get_multiline_input(prompts["cover_letter"])

    now = datetime.datetime.now()
    day = arabic_to_roman(now.day)
    month = arabic_to_roman(now.month)
    year = arabic_to_roman(now.year)
    date_str = f"{day}.{month}.{year} A.C."

    cv_content = f"""
Curriculum Vitae

Personal Information:
---------------------
Name: {name}
Email: {email}
Phone: {phone}
Address: {address}

Education:
----------
{education}

Work Experience:
----------------
{experience}

Skills:
-------
{skills}

Languages:
----------
{languages}

Cover Letter:
-------------
{cover_letter}

Date:
-----
Date: {date_str}

Signature: {name}
"""

    with open("cv.txt", "w", encoding="utf-8") as file:
        file.write(cv_content)
    print(prompts["saved"])

    export_choice = get_input(prompts["export"]).lower()
    if export_choice in ["yes", "sí", "da"]:
        if subprocess.call("pandoc --version", shell=True) == 0:
            subprocess.call("pandoc cv.txt -o cv.pdf", shell=True)
            subprocess.call("pandoc cv.txt -o cv.docx", shell=True)
            print(prompts["export_installed"])
        else:
            print(prompts["export_not_installed"])

def main():
    print("Please choose the language for completing the CV:")
    print("1. English")
    print("2. Español")
    print("3. Română")
    lang_choice = input("Enter 1, 2, or 3: ").strip()

    if lang_choice == '1':
        language = 'en'
    elif lang_choice == '2':
        language = 'es'
    elif lang_choice == '3':
        language = 'ro'
    else:
        print("Invalid choice.")
        return

    if subprocess.call("pandoc --version", shell=True) != 0:
        print(prompts["no_pandoc"])

    generate_cv(language)

if __name__ == "__main__":
    main()
