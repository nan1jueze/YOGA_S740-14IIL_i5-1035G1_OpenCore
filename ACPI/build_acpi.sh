#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 6 Jun, 2020
#
# Build ACPI SSDTs for XiaoMi-Pro EFI
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# Vars
# CFURL="https://hackintosh.stevezheng.workers.dev"
systemLanguage=$(locale | grep LANG | sed s/'LANG='// | tr -d '"' | cut -d "." -f 1)

# Colors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)
bold=$(tput bold)

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from ${1}, please check your connection!"
  exit 1
}

# Exit on Compile Issue
function compileErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to compile dsl!"
  find . -maxdepth 1 -name "*.aml" -exec rm -rf {} + > /dev/null 2>&1
  exit 1
}

function init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  cd "$(dirname "$0")" || exit 1

  if [[ -f "iasl-stable" ]]; then
    rm -rf "iasl-stable"
  fi
  if [[ -d "Compiled" ]]; then
    rm -rf "Compiled"
  fi
  mkdir -p Compiled
}

# Download iasl from Acidanthera's MaciASL repository
function download() {
  local url="https://raw.githubusercontent.com/$1/$2/master/$3"
  #if [[ ${systemLanguage} == "zh_CN" ]]; then
  #  url=${url/#/${CFURL}/}
  #fi
  echo "${green}[${reset}${blue}${bold} Downloading ${3##*\/} ${reset}${green}]${reset}"
  echo "${cyan}"
  curl -# -L -O "${url}" || networkErr "${3##*\/}"
  echo "${reset}"
}

function compile() {
  chmod +x iasl*
  echo "${green}[${reset}${magenta}${bold} Compiling ACPI Files ${reset}${green}]${reset}"
  echo
  find . -name '*.dsl' -exec sh -c '
    ./iasl* -vw 2095 -vw 2173 -vs -p "${1%/*}/../Compiled/${1##*/}" "${1%}" > /dev/null 2>&1 || compileErr
  ' sh {} \;
  
    rm -rf iasl*
}

function enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
  open ./
}

function main() {
  init
  download Acidanthera MaciASL Dist/iasl-stable
  compile
  enjoy
}

main
