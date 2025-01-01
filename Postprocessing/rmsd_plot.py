import matplotlib.pyplot as plt
import os

# Define your dictionary

# Define colors for different tests
colors = ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'orange', 'purple']

# Create a 3x3 grid of subplots
fig, axes = plt.subplots(4, 5, figsize=(20, 15))
#axes = axes.flatten()

#for idx, (system, tests) in enumerate(aa.items()):
 #   ax = axes[idx]
  #  for i, test in enumerate(tests):
parent_directory = '/scratch/amondal2/brave/test_20_miss/diff_dock_misses20/'

# List to store directories that start with '5'
system = []

# Iterate over the items in the parent directory
for item in os.listdir(parent_directory):
    # Create the full path to the item
    item_path = os.path.join(parent_directory, item)
    # Check if the item is a directory and starts with '5'
    if os.path.isdir(item_path) and item.startswith('base'):
        system.append(item)
print(system)
ligand=['rank1_mod']
for i in range(4):
    for j in range(5):    
        ax = axes[i,j]
        for trial in range(1, 4):
            trial_dir = f"./{system[5*i+j]}/{ligand[0]}/trial_{trial}"
            rmsd_file = os.path.join(trial_dir, "lig_rmsd.out")

            if os.path.exists(rmsd_file):
                # Assuming rmsd_backbone.out has two columns: time and rmsd values
                times = []
                rmsds = []
                with open(rmsd_file, 'r') as f:
                    next(f)  # Skip the header if there is one
                    for x, line in enumerate(f):
                        #if j >= 4000:
                         #   break
                        parts = line.split()
                        if len(parts) >= 2:
                            times.append(float(parts[0]))
                            rmsds.append(float(parts[1]))

                if times and rmsds:  # Only plot if data is not empty
                    ax.plot(times, rmsds, label=f"{system[5*i+j]}_{ligand[0]}_{trial}", alpha=0.6, color=colors[trial])
        ax.set_ylim(0,30)
        ax.set_title(system[5*i+j]+'/'+ligand[0])
        ax.legend()
        ax.set_xlabel("Time")
        ax.set_ylabel("lig RMSD")

# Adjust layout
plt.tight_layout()
plt.savefig('fixed_rmsd_lig_1.png')
plt.show()

