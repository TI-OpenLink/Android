#!/system/bin/sh

chmod +w /sys/power/wake_lock
chmod +w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
chmod +w /sys/devices/system/cpu/cpu1/online
chmod +w /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor

echo manual_lock > /sys/power/wake_lock
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1 > /sys/devices/system/cpu/cpu1/online
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
