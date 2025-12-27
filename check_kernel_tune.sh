#!/bin/bash

### Paths ###
available_governors=/sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors
scaling_governor=/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
ksm_run="/sys/kernel/mm/ksm/run"
min_ttl_ms="/sys/kernel/mm/lru_gen/min_ttl_ms"
compaction_proactiveness="/proc/sys/vm/compaction_proactiveness"
dirty_ratio="/proc/sys/vm/dirty_ratio"
dirty_background_ratio="/proc/sys/vm/dirty_background_ratio"


echo "=== Current Kernel Tuning Status ==="
echo
echo "Available CPU frequency scaling governors:"
for file in $available_governors; do
    echo "  $(dirname "$file")/: $(cat "$file")"
done | sort -u
echo
echo "Current CPU scaling governor:"
for file in $scaling_governor; do
    echo "  $(dirname "$file")/: $(cat "$file")"
done | sort -u
echo
echo "KSM (Kernel Same-page Merging) status:"
echo "  $ksm_run = $(cat $ksm_run 2>/dev/null || echo "N/A")"
echo
echo "LRU generation minimum TTL:"
echo "  $min_ttl_ms = $(cat $min_ttl_ms 2>/dev/null || echo "N/A")"
echo
echo "Memory compaction proactiveness:"
echo "  $compaction_proactiveness = $(cat $compaction_proactiveness 2>/dev/null || echo "N/A")"
echo
echo "Dirty page writeback ratios:"
echo "  $dirty_ratio = $(cat $dirty_ratio 2>/dev/null || echo "N/A")"
echo "  $dirty_background_ratio = $(cat $dirty_background_ratio 2>/dev/null || echo "N/A")"
echo

echo "Check completed."

exit 0
