import sys
import re

def replace_odoo_version_in_file(file_path, version):
    """Replace the Odoo version number in the specified file."""
    with open(file_path, 'r') as file:
        contents = file.read()

    pattern = r'(revision="[^\".]*\.)(12)([^\".]*")'
    replacement = r'\g<1>' + version + r'\g<3>'

    contents = re.sub(pattern, replacement, contents)

    with open(file_path, 'w') as file:
        file.write(contents)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 script.py VERSION")
        sys.exit(1)

    version = sys.argv[1]

    try:
        version_int = int(version)
        if version_int < 5 or version_int > 17:
            raise ValueError
    except ValueError:
        print("Version must be an integer between 5 and 17")
        sys.exit(1)

    file_path = "./manifest/version_asked.dev.xml"
    replace_odoo_version_in_file(file_path, version)

    print("Odoo version updated to", version, "in", file_path)
