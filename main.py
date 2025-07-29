import os

TEMPLATE_DIR = 'templates'
OUTPUT_DIR = 'output'

def replace_placeholders(template_text, design_name):
    return template_text.replace('{{ design_name }}', design_name)

def generate_uvm_code(design_name, templates):
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    for template_file in templates:
        component = template_file.replace('.tpl', '')
        template_path = os.path.join(TEMPLATE_DIR, template_file)

        if not os.path.exists(template_path):
            print(f"[!] Template not found: {template_path}")
            continue

        with open(template_path, 'r') as file:
            template_content = file.read()

        rendered_content = replace_placeholders(template_content, design_name)
        output_filename = f"{design_name}_{component}.sv"
        output_path = os.path.join(OUTPUT_DIR, output_filename)

        with open(output_path, 'w') as out_file:
            out_file.write(rendered_content)

        print(f"[✓] Generated: {output_path}")

def main():
    design_name = input("Enter the design/module name (e.g. alu): ").strip().lower()

    if not design_name:
        print("[!] Design name cannot be empty.")
        return

    if not os.path.exists(TEMPLATE_DIR):
        print(f"[!] Template directory '{TEMPLATE_DIR}' not found.")
        return

    templates = [f for f in os.listdir(TEMPLATE_DIR) if f.endswith('.tpl')]

    if not templates:
        print("[!] No template files found in 'templates/'")
        return

    generate_uvm_code(design_name, templates)

if __name__ == '__main__':
    main()
