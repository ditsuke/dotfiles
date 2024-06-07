#!/bin/bash

# Fix GPE interrupts issue
interrupt=/sys/firmware/acpi/interrupts/gpe6E
if [ "$(grep unmasked <$interrupt)" = "" ]; then
	echo "unmask" >$interrupt
fi

# Set charging limit to 80
echo 80 >/sys/class/power_supply/CMB0/charge_control_end_threshold

# Disable "Silent mode"
echo 1 >/sys/devices/platform/lg-laptop/fan_mode

# Unload the int3403 temp sensor library
rmmod int3403_thermal

# Uncomment the following lines to disable turbo boost
# echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo

# Uncomment the following lines to fix thermal throttle issue
# systemctl disable --now thermald
