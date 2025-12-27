#!/bin/bash

### Configuration text ###
sysctld_file_text="# Kernel tuning settings applied via /proc/sys/
vm.compaction_proactiveness = 0
vm.dirty_ratio = 5
vm.dirty_background_ratio = 5"

# Change "conservative" to another governor if desired (e.g., performance, ondemand, schedutil)
tmpfilesd_file_text="# Temporary kernel tuning overrides at boot
w /sys/kernel/mm/ksm/run - - - - 0
w /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 1000
w /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor - - - - conservative"


### Paths and files ###
sysctld_dir="/etc/sysctl.d/"
sysctld_file="99-my_kernel_tune.conf"
tmpfilesd_dir="/etc/tmpfiles.d/"
tmpfilesd_file="my_kernel_tune.conf"

available_governors=/sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors
scaling_governor=/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
ksm_run="/sys/kernel/mm/ksm/run"
min_ttl_ms="/sys/kernel/mm/lru_gen/min_ttl_ms"
compaction_proactiveness="/proc/sys/vm/compaction_proactiveness"
dirty_ratio="/proc/sys/vm/dirty_ratio"
dirty_background_ratio="/proc/sys/vm/dirty_background_ratio"


# --- Function to check if files/directories exist ---
check_existence() {
    for path in "$@"; do
        if [ ! -e "$path" ]; then
            echo "Error: Required file or directory not found: $path"
            echo "This usually means the kernel does not support one of the tuned features."
            exit 1
        fi
    done
}

# --- Verify required paths exist ---
echo "Checking system compatibility..."
check_existence \
    $available_governors \
    $scaling_governor \
    $ksm_run \
    $min_ttl_ms \
    $compaction_proactiveness \
    $dirty_ratio \
    $dirty_background_ratio \
    $sysctld_dir \
    $tmpfilesd_dir

# --- Create configuration files ---
echo
echo "This script requires sudo privileges to write configuration files."
echo

echo "Creating sysctl configuration file..."
echo "$sysctld_file_text" | sudo tee "${sysctld_dir}${sysctld_file}" > /dev/null
echo "Created: ${sysctld_dir}${sysctld_file}"
echo "Contents of ${sysctld_dir}:"
ls -l "$sysctld_dir"
echo

echo "Creating systemd-tmpfiles configuration..."
echo "$tmpfilesd_file_text" | sudo tee "${tmpfilesd_dir}${tmpfilesd_file}" > /dev/null
echo "Created: ${tmpfilesd_dir}${tmpfilesd_file}"
echo "Contents of ${tmpfilesd_dir}:"
ls -l "$tmpfilesd_dir"
echo

# --- Apply changes ---
echo "Applying kernel parameters..."
sudo sysctl --system > /dev/null

echo "Applying temporary overrides..."
sudo systemd-tmpfiles --create

echo
echo "Kernel tuning setup completed successfully!"
echo "A reboot is recommended for all changes to take full effect."

exit 0
