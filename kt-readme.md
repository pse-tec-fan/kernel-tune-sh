# Kernel Tuning Scripts for Linux

These two scripts help apply and verify kernel parameters optimized for **low-latency** and **responsive** desktop/gaming use on modern Linux systems (e.g., Ubuntu 24.04+).

The parameters used in these scripts are based on the recommendations from this Ubuntu Community Hub article:
https://discourse.ubuntu.com/t/fine-tuning-the-ubuntu-24-04-kernel-for-low-latency-throughput-and-power-efficiency/44834

These tweaks aim to:
- Disable proactive memory compaction (`vm.compaction_proactiveness = 0`)
- Reduce writeback ratios to prevent stuttering during intense I/O (`vm.dirty_ratio = 5`, `vm.dirty_background_ratio = 5`)
- Disable Kernel Same-page Merging (KSM)
- Set a minimum TTL for LRU generation to mitigate thrashing
- Use the "conservative" CPU governor (can be changed in the script if desired)

**Warning**: These are aggressive settings focused on responsiveness. They may increase power consumption or reduce throughput in some workloads. Test thoroughly on your system and revert if necessary. A reboot is recommended after applying the changes.


## Files

- `check_kernel_tune.sh` — Shows the current values of the tuned parameters.
- `setup_kernel_tune.sh` — Creates configuration files and applies the kernel tuning.


## Usage

Run the scripts from the terminal (they will prompt for sudo when needed):

```bash
./check_kernel_tune.sh    # Verify current settings
./setup_kernel_tune.sh    # Apply the kernel tuning
```

After running setup_kernel_tune.sh, reboot your system for all changes to take full effect.


## Reverting the changes

To undo the tuning:

```bash
sudo rm /etc/sysctl.d/99-my_kernel_tune.conf
sudo rm /etc/tmpfiles.d/my_kernel_tune.conf
sudo sysctl --system
```

Then reboot or manually reset the parameters to their defaults.

