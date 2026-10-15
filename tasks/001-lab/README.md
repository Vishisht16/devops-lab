# Lab Setup

## Goal

Set up codespaces and stuff for work later

## What I did

Created repo, set up the structure, read book chapter 1

## What broke and how I fixed it

The image source in devcontainer was wrong earlier so the right image couldn't be fetched and I got an error. Then I switched to a stale ubuntu-24.04 image and now I'm finally at the right ubuntu24.04 image, which gets updates.

## What AI did

Wrote devcontainer.json

## Evidence

@Vishisht16 ➜ /workspaces/devops-lab (main) $ shellcheck --version
ShellCheck - shell script analysis tool
version: 0.9.0
license: GNU General Public License, version 3
website: https://www.shellcheck.net
@Vishisht16 ➜ /workspaces/devops-lab (main) $ cat /etc/os-release 
PRETTY_NAME="Ubuntu 24.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.5 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo

## Open questions

None
