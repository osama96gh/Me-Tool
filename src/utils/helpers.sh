#!/bin/zsh

# Me Tool - Helper Functions

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate category name
validate_category() {
    local category="$1"
    case "$category" in
        sys|git|dir|proj) return 0 ;;
        *) return 1 ;;
    esac
}

# Get user's home directory
get_home_dir() {
    echo "$HOME"
}

# Get common directories
get_dev_dir() {
    echo "$(get_home_dir)/Development"
}

get_downloads_dir() {
    echo "$(get_home_dir)/Downloads"
}

get_documents_dir() {
    echo "$(get_home_dir)/Documents"
}

# Print colored output
print_error() {
    echo "\033[31mError: $1\033[0m" >&2
}

print_success() {
    echo "\033[32m$1\033[0m"
}

print_info() {
    echo "\033[34m$1\033[0m"
}

# Check if we're in a git repository
is_git_repository() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Load configuration
load_config() {
    local config_file="${PROJECT_ROOT}/src/config/config.yml"
    # TODO: Implement YAML parsing
    # For now, return default values
    return 0
}

# Suggest similar commands
suggest_command() {
    local cmd="$1"
    local suggestions=()
    
    # Simple suggestion logic based on common commands
    case "$cmd" in
        stat*) suggestions+=("status") ;;
        pus*) suggestions+=("push") ;;
        pul*) suggestions+=("pull") ;;
        com*) suggestions+=("commit") ;;
        buil*) suggestions+=("build") ;;
        ser*) suggestions+=("serve") ;;
        upd*) suggestions+=("update") ;;
    esac
    
    if [[ ${#suggestions[@]} -gt 0 ]]; then
        echo "Did you mean:"
        printf "  %s\n" "${suggestions[@]}"
    fi
}

# Check if a path exists
path_exists() {
    [[ -e "$1" ]]
}

# Create directory if it doesn't exist
ensure_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

# Get absolute path
get_absolute_path() {
    local path="$1"
    echo "${path:A}"
}

# Check if string contains only alphanumeric characters
is_alphanumeric() {
    [[ "$1" =~ ^[a-zA-Z0-9]+$ ]]
}

# Trim whitespace from string
trim() {
    local str="$1"
    echo "${str## }${str%% }"
}

# Join array elements with delimiter
join_by() {
    local d="$1"
    shift
    echo -n "$1"
    shift
    printf "%s" "${@/#/$d}"
}

# Check if variable is empty or only whitespace
is_empty() {
    [[ -z "${1// }" ]]
}
