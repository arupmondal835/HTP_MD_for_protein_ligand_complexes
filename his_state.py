def rename_histidines(pdb_file, output_file):
    with open(pdb_file, 'r') as infile, open(output_file, 'w') as outfile:
        residues = {}  # Store residue atoms to determine types

        for line in infile:
            if line.startswith(("ATOM", "HETATM")):
                atom_name = line[12:16].strip()
                residue_name = line[17:20].strip()
                residue_id = (line[21], int(line[22:26]))  # (chain ID, residue number)

                if residue_name == "HIS":
                    if residue_id not in residues:
                        residues[residue_id] = {"HD1": False, "HE2": False}
                    if atom_name in ["HD1", "HE2"]:
                        residues[residue_id][atom_name] = True

        infile.seek(0)  # Reset file pointer to start
        for line in infile:
            if line.startswith(("ATOM", "HETATM")):
                residue_name = line[17:20].strip()
                residue_id = (line[21], int(line[22:26]))  # (chain ID, residue number)

                # Rename HIS based on collected atoms
                if residue_name == "HIS" and residue_id in residues:
                    if residues[residue_id]["HD1"] and residues[residue_id]["HE2"]:
                        new_name = "HIP"
                    elif residues[residue_id]["HD1"]:
                        new_name = "HID"
                    elif residues[residue_id]["HE2"]:
                        new_name = "HIE"
                    else:
                        new_name = "HIS"
                    line = line[:17] + f"{new_name:<3}" + line[20:]

            outfile.write(line)

pdb_file = "initial.pdb"  # Replace with your PDB file
output_file = "receptor.pdb"
rename_histidines(pdb_file, output_file)

print(f"Modified PDB file saved to {output_file}.")

