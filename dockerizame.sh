#!/bin/env bash

VERBOSE=
DESTINY="."

usage() { echo "Usage $0 [-h] [-v] [-d /folder/destiny] <executable> ";}

while getopts "hvd:" opt; do
	case ${opt} in
		h)
			usage;
			exit 0;
			;;
		v)
			VERBOSE=v;
			;;
		d)
			DESTINY="${OPTARG}"
			shift
			;;
		\?)
			usage;
			exit 1;
			;;
		:)
			usage;
			exit 1;
			;;
	esac
	shift
done

# Test requirements
if [ -z "$(command -v objdump)" ]; then
	echo "objdump required but not found";
	exit 1;
fi
if [ -z "$(command -v ldd)" ]; then
	echo "ldd required but not found";
	exit 1;
fi

# ld
LD=$(objdump -s -j .interp "$1" | tail -2 | awk -F " " '{printf $NF}')
LD=$(printf "%s" "${LD}" | cut -c -$((${#LD}-1)))

# others libraries
SHARED=$(ldd "$1" | awk -F " " '/=>/,/\(/{print $3}')

printf '%s\n%s\n' "${LD}" "${SHARED}" | while IFS= read -r line; do
	if [ ${VERBOSE} = "v" ]; then
		echo "$line";
	fi
	mkdir -p "$(dirname "$DESTINY$line")"
	cp -L "$line" "${DESTINY}$line"
done
