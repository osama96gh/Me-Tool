#!/bin/zsh

# Me Tool - Helper Functions

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

# String manipulation
trim() {
    local str="$1"
    # Remove leading and trailing whitespace
    str="${str#"${str%%[![:space:]]*}"}"
    str="${str%"${str##*[![:space:]]}"}"
    echo "$str"
}

# String validation
is_empty() {
    local str="$1"
    [[ -z "${str// }" ]]
}

is_alphanumeric() {
    local str="$1"
    [[ "$str" =~ ^[a-zA-Z0-9_-]+$ ]]
}

# Git repository check
is_git_repository() {
    git rev-parse --is-inside-work-tree &> /dev/null
}

# Directory validation
is_directory() {
    local dir="$1"
    [[ -d "$dir" ]]
}

# File validation
is_file() {
    local file="$1"
    [[ -f "$file" ]]
}

# Command validation
command_exists() {
    local cmd="$1"
    command -v "$cmd" &> /dev/null
}

# Array functions
join_by() {
    local d=${1-} f=${2-}
    if shift 2; then
        printf %s "$f" "${@/#/$d}"
    fi
}

# Path manipulation
normalize_path() {
    local path="$1"
    echo "${path/#\~/$HOME}"
}

# Version comparison
version_compare() {
    if [[ "$1" == "$2" ]]; then
        echo "="
    elif [[ "$1" == "$(echo -e "$1\n$2" | sort -V | head -n1)" ]]; then
        echo "<"
    else
        echo ">"
    fi
}

# Environment check
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

is_linux() {
    [[ "$(uname)" == "Linux" ]]
}

# Sudo check
has_sudo() {
    sudo -n true 2>/dev/null
}

# Process check
is_running() {
    local pid="$1"
    kill -0 "$pid" 2>/dev/null
}

# Network check
has_internet() {
    ping -c 1 8.8.8.8 &>/dev/null
}

# File system functions
ensure_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}

backup_file() {
    local file="$1"
    [[ -f "$file" ]] && cp "$file" "${file}.bak"
}

# Configuration functions
validate_yaml() {
    local file="$1"
    yq e '.' "$file" &>/dev/null
}

merge_yaml() {
    local file1="$1"
    local file2="$2"
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$file1" "$file2"
}

# Logging functions
log_error() {
    local msg="$1"
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $msg" >&2
}

log_info() {
    local msg="$1"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $msg"
}

log_debug() {
    [[ "${DEBUG:-0}" == "1" ]] && {
        local msg="$1"
        echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - $msg"
    }
}
