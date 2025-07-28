/**

 * This program reads template files from the 'template/' directory, replaces
 * placeholders based on a predefined VIP name (e.g., "ahb"), and writes the
 * output files to the 'output/' directory. It is designed to be compiled and
 * run using the provided Makefile.
 *
 * How to Modify:
 * 
 * - Change the 'vip_name' variable in the main() function to your desired protocol (e.g., "apb", "axi").
 *
 * How to Compile (using the Makefile):
 * make
 *
 * How to Run (using the Makefile):
 * make run
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <errno.h> // Required for checking errno after mkdir

// Platform-specific directory creation
#ifdef _WIN32
#include <direct.h>
#define MKDIR(path) _mkdir(path)
#else
#include <unistd.h>
#define MKDIR(path) mkdir(path, 0777)
#endif

#define MAX_LINE_LENGTH 4096
#define MAX_NAME_LENGTH 256
#define TEMPLATE_DIR "template"
#define OUTPUT_DIR "output"

typedef struct {
    const char *placeholder;
    const char *value;
} Replacement;

void create_directory_if_not_exists(const char *path) {
    if (MKDIR(path) == -1) {
        if (errno != EEXIST) {
            fprintf(stderr, "Error: Could not create directory '%s'\n", path);
            perror("Reason");
            exit(EXIT_FAILURE);
        }
    }
}

/**
 * @brief Replaces all placeholder occurrences in an input stream and writes to an output stream.
 * @param in The input file stream (template).
 * @param out The output file stream (generated file).
 * @param replacements An array of Replacement structs.
 * @param num_replacements The number of items in the replacements array.
 */
void replace_placeholders_in_stream(FILE *in, FILE *out, const Replacement replacements[], int num_replacements) {
    char line[MAX_LINE_LENGTH];

    while (fgets(line, sizeof(line), in)) {
        char *current_pos = line;

        while (*current_pos) {
            char *next_placeholder_pos = NULL;
            int replacement_index = -1;

            // Find the *earliest* occurring placeholder in the rest of the line
            for (int i = 0; i < num_replacements; ++i) {
                char *found = strstr(current_pos, replacements[i].placeholder);
                if (found && (next_placeholder_pos == NULL || found < next_placeholder_pos)) {
                    next_placeholder_pos = found;
                    replacement_index = i;
                }
            }

            if (next_placeholder_pos) {
                // Write the segment of the line before the found placeholder
                fwrite(current_pos, 1, next_placeholder_pos - current_pos, out);
                // Write the replacement value for the placeholder
                fputs(replacements[replacement_index].value, out);
                // Move the current position past the placeholder we just replaced
                current_pos = next_placeholder_pos + strlen(replacements[replacement_index].placeholder);
            } else {
                // No more placeholders found, write the remainder and break
                fputs(current_pos, out);
                break;
            }
        }
    }
}

/**
 * @brief Generates a single output file from a template file.
 * @param template_filename The name of the template file (e.g., "transaction.tpl").
 * @param output_filename The name of the output file (e.g., "transaction.sv").
 * @param replacements An array of Replacement structs.
 * @param num_replacements The number of items in the replacements array.
 */
void generate_file(const char *template_filename, const char *output_filename, const Replacement replacements[], int num_replacements) {
    char template_path[MAX_NAME_LENGTH];
    char output_path[MAX_NAME_LENGTH];

    snprintf(template_path, sizeof(template_path), "%s/%s", TEMPLATE_DIR, template_filename);
    snprintf(output_path, sizeof(output_path), "%s/%s", OUTPUT_DIR, output_filename);

    FILE *in = fopen(template_path, "r");
    if (!in) {
        fprintf(stderr, "❌ Error: Could not open template file: %s\n", template_path);
        perror("Reason");
        return;
    }

    FILE *out = fopen(output_path, "w");
    if (!out) {
        fprintf(stderr, "❌ Error: Could not open output file: %s\n", output_path);
        perror("Reason");
        fclose(in);
        return;
    }

    printf("  - Generating '%s' from '%s'...\n", output_path, template_path);
    replace_placeholders_in_stream(in, out, replacements, num_replacements);

    fclose(in);
    fclose(out);
}

int main(void) {
    // --- Configuration ---
    // Change this value to the desired VIP name (e.g., "apb", "axi", "my_protocol")
    const char *vip_name = "ahb";

    char txn_name[MAX_NAME_LENGTH];
    char seq_name[MAX_NAME_LENGTH];
    char txn_output_file[MAX_NAME_LENGTH];
    char seq_output_file[MAX_NAME_LENGTH];

    // --- Construct names based on vip_name ---
    snprintf(txn_name, sizeof(txn_name), "%s_transaction", vip_name);
    snprintf(seq_name, sizeof(seq_name), "%s_sequence", vip_name);
    snprintf(txn_output_file, sizeof(txn_output_file), "%s_transaction.sv", vip_name);
    snprintf(seq_output_file, sizeof(seq_output_file), "%s_sequence.sv", vip_name);

    // --- Setup Replacements ---
    Replacement replacements[] = {
        {"{{txn_name}}", txn_name},
        {"{{seq_name}}", seq_name}
    };
    int num_replacements = sizeof(replacements) / sizeof(replacements[0]);

    printf(" Configuration:\n");
    printf("  - VIP Name:         %s\n", vip_name);
    printf("  - Template Dir:     %s/\n", TEMPLATE_DIR);
    printf("  - Output Dir:       %s/\n\n", OUTPUT_DIR);

    create_directory_if_not_exists(OUTPUT_DIR);

    printf("Starting file generation...\n");
    generate_file("transaction.tpl", txn_output_file, replacements, num_replacements);
    generate_file("sequence.tpl", seq_output_file, replacements, num_replacements);

    printf("\n Done! Files generated in '%s/' directory.\n", OUTPUT_DIR);

    return EXIT_SUCCESS;
}
