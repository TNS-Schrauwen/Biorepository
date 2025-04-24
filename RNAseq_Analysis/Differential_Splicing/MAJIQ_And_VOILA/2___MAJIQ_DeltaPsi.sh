

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Load the Singularity module:
module load Singularity Version

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Define your MAJIQ build directory and group names
majiq_build_directory="/path/to/your/general/MAJIQ/folder"
# Use the same names are in the config file:
control_name="Control"
experimental_name="Experimental"

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

# The Singularity image:
singularity_image="/path/to/your/MAJIQ.sif"

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Get the current timestamp:
start_timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Print the timestamp to stdout:
echo -e "\n\n**Job Started At:** $start_timestamp\n" 

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Check if the directory exists
if [ -d "$majiq_build_directory" ]; then
    echo "Majiq build directory exists: $majiq_build_directory"

else
    echo "Majiq build directory not found."
    echo "Exiting the script."
    exit 1  # Exit with an error code
fi

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

if [ -n "$control_name" ]; then
    echo "Control name is set: $control_name"
else
    echo "Control name is not set."
    echo "Exiting the script."
    exit 1  # Exit with an error code
fi


# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

if [ -n "$experimental_name" ]; then
    echo "Experimental name is set: $experimental_name"
else
    echo "Experimental name is not set."
    echo "Exiting the script."
    exit 1  # Exit with an error code
fi

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

# Check if the file exists
if [ -f "$singularity_image" ]; then
    echo "Singularity image exists: $singularity_image"

else
    echo "Singularity image not found."
    echo "Exiting the script."
    exit 1  # Exit with an error code
fi

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Automatically find and select control and experimental MAJIQ files - modify to your purposes
# Define the paths to the Control .majiq files
control_majiq_files=($(find "$majiq_build_directory" -type f -name "Control*.majiq"))
experimental_majiq_files=($(find "$majiq_build_directory" -type f -name "Experimental*.majiq"))

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Check if control_majiq_files is empty
if [ ${#control_majiq_files[@]} -eq 0 ]; then
    echo "Control Majiq files are not found."
    echo "Exiting the script."
    exit 1  # Exit with an error code
else
    echo "Control Majiq Files Are: ${control_majiq_files[@]}"
fi

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

# Check if experimental_majiq_files is empty
if [ ${#experimental_majiq_files[@]} -eq 0 ]; then
    echo "Experimental Majiq files are not found."
    echo "Exiting the script."
    exit 1  # Exit with an error code
else
    echo "Experimental Majiq Files Are: ${experimental_majiq_files[@]}"
fi

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Run the majiq deltapsi command
singularity exec "${singularity_image}" majiq deltapsi \
    -o "${majiq_build_directory}" \
    -n "$control_name" "$experimental_name" \
    -grp1 "${control_majiq_files[@]}" \
    -grp2 "${experimental_majiq_files[@]}"

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

# Get the timestamp when the command completes:
end_timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# Print the end timestamp to stdout:
echo -e "\n**Job Ended At:** $end_timestamp\n"

#____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________