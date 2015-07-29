#!/system/bin/sh

BB=/sbin/busybox

############################
# Custom Kernel Settings for Llama sweet

stop mpdecision

############################
# Scheduler and Read Ahead
#
echo zen > /sys/block/mmcblk0/queue/scheduler
echo 2048 > /sys/block/mmcblk0/bdi/read_ahead_kb



############################
# LMK Tweaks
#
echo 2560,4096,8192,16384,24576,32768 > /sys/module/lowmemorykiller/parameters/minfree
echo 32 > /sys/module/lowmemorykiller/parameters/cost


############################
# GPU Governor
#
echo nightmare > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo nightmare > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo nightmare > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo nightmare > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo "50" > /sys/devices/system/cpu/cpufreq/nightmare/dec_cpu_load
echo "540000" > /sys/devices/system/cpu/cpufreq/nightmare/freq_for_responsiveness
echo "1890000" > /sys/devices/system/cpu/cpufreq/nightmare/freq_for_responsiveness_max
echo "20" > /sys/devices/system/cpu/cpufreq/nightmare/freq_step
echo "20" > /sys/devices/system/cpu/cpufreq/nightmare/freq_step_at_min_freq
echo "10" > /sys/devices/system/cpu/cpufreq/nightmare/freq_step_dec
echo "10" > /sys/devices/system/cpu/cpufreq/nightmare/freq_step_dec_at_max_freq
echo "30" > /sys/devices/system/cpu/cpufreq/nightmare/freq_up_brake
echo "30" > /sys/devices/system/cpu/cpufreq/nightmare/freq_up_brake_at_min_freq
echo "70" > /sys/devices/system/cpu/cpufreq/nightmare/inc_cpu_load
echo "60" > /sys/devices/system/cpu/cpufreq/nightmare/inc_cpu_load_at_min_freq
echo "60000" > /sys/devices/system/cpu/cpufreq/nightmare/sampling_rate
	
# Ondemand
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo 95 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
echo 75 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
echo 3 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
echo 960000 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
echo 960000 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
echo 85 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load

# Interactive
echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo 20000 1400000:40000 1700000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo 1190400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo 85 1500000:90 1800000:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack

############################
# Tweak Background Writeout
#
echo "70" > /proc/sys/vm/dirty_background_ratio
echo "250" > /proc/sys/vm/dirty_expire_centisecs
echo "90" > /proc/sys/vm/dirty_ratio
echo "500" > /proc/sys/vm/dirty_writeback_centisecs
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "60" > /proc/sys/vm/swappiness
echo "10" > /proc/sys/vm/vfs_cache_pressure
echo "3" > /proc/sys/vm/drop_caches


# Turn off debugging for certain modules
echo 0 > /sys/module/kernel/parameters/initcall_debug
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
echo 0 > /sys/module/alarm/parameters/debug_mask
echo 0 > /sys/module/alarm_dev/parameters/debug_mask
echo 0 > /sys/module/binder/parameters/debug_mask
echo 0 > /sys/module/xt_qtaguid/parameters/debug_mask

############################
# Power Effecient Workqueues (Enable for battery)
#
echo 1 > /sys/module/workqueue/parameters/power_efficient
echo 0 > /sys/module/subsystem_restart/parameters/enable_ramdumps


############################
# Test Debugging!!!
#
echo 0 > /sys/kernel/sched/gentle_fair_sleepers
echo 1 > /sys/module/msm_thermal/parameters/enabled


############################
# Activate Simple_GPU_Algorithym
#
echo 1 > /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate


# Mount root as RW to apply tweaks and settings
$BB mount -o remount,rw /;
$BB mount -o rw,remount /system

# Cleanup.
$BB rm -f /res/synapse/debug/* 

# Make tmp folder
$BB mkdir /tmp;

# Give permissions to execute
$BB chown -R root:system /tmp/;
$BB chmod -R 777 /tmp/;
$BB chmod -R 777 /res/;
$BB chmod -R 6755 /res/synapse/actions/;
$BB chmod -R 6755 /res/synapse/files/;
$BB chmod -R 6755 /sbin/;
$BB chmod -R 6755 /system/xbin/;
$BB echo "Boot initiated on $(date)" > /tmp/bootcheck;

ln -s /res/synapse/uci /sbin/uci
/sbin/uci

