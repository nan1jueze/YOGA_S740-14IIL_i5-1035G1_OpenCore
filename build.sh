#!/bin/bash

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
gray=$(tput setaf 8)
reset=$(tput sgr0)
bold=$(tput bold)

###### Logger Util
function logger_info {
  echo "${gray}[$(date '+%Y-%m-%d %H:%M:%S')]${reset} ${green}INFO${reset} $1"
}
function logger_warn {
  echo "${gray}[$(date '+%Y-%m-%d %H:%M:%S')]${reset} ${yellow}WARN${reset} $1"
}
function logger_error {
  echo "${gray}[$(date '+%Y-%m-%d %H:%M:%S')]${reset} ${red}ERROR${reset} $1"
}

# Exit on Copy Issue
function copyErr() {
  logger_error "Failed to copy resources!"
  cd ../../ || exit 1
  rm -rf "${OUTDir}"
  exit 1
}

rm -rf ./Output
mkdir -p ./Output

(
  bash ./ACPI/build_acpi.sh NOOPEN
)
(
  bash ./Kexts/Download_kexts.sh NOOPEN
)
(
  bash ./OC/oc.sh NOOPEN
)

cp -R ./OC/EFI ./Output || copyErr
cp -R ./ACPI/Compiled/* ./Output/EFI/OC/ACPI/ || copyErr
cp -R ./Kexts/Download/. ./Output/EFI/OC/Kexts || copyErr
cp -R ./Kexts/Shared/. ./Output/EFI/OC/Kexts || copyErr
#cp -R ./Drivers/. ./Output/EFI/OC/Drivers || copyErr
cp -R ./Config/ ./Output/EFI/OC/ || copyErr

logger_info "Done!"
