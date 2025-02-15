#!/bin/zsh

# Me Tool - Configuration Manager

# Dependencies check
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

command_exists yq || {
    print_error "yq is required for YAML parsing. Please install it:"
    echo "brew install yq"
    exit 1
}

# Global configuration
CONFIG_FILE="$PROJECT_ROOT/src/config/config.yml"
USER_CONFIG_FILE="$HOME/.config/me-tool/config.yml"

# Load configuration
load_config() {
    [[ -f "$CONFIG_FILE" ]] || {
        print_error "Configuration file not found: $CONFIG_FILE"
        return 1
    }

    # Merge user config if exists
    if [[ -f "$USER_CONFIG_FILE" ]]; then
        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$CONFIG_FILE" "$USER_CONFIG_FILE"
    else
        cat "$CONFIG_FILE"
    fi
}

# Get category names
get_categories() {
    yq e '.categories | keys | .[]' "$CONFIG_FILE"
}

# Get category details
get_category_info() {
    local category="$1"
    yq e ".categories.$category" "$CONFIG_FILE"
}

# Get category commands
get_category_commands() {
    local category="$1"
    yq e ".categories.$category.commands | keys | .[]" "$CONFIG_FILE"
}

# Get command details
get_command_info() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command" "$CONFIG_FILE"
}

# Get command implementation
get_command_implementation() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.implementation" "$CONFIG_FILE"
}

# Check if command requires confirmation
command_needs_confirmation() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.requires_confirmation // false" "$CONFIG_FILE"
}

# Check if command requires sudo
command_needs_sudo() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.requires_sudo // false" "$CONFIG_FILE"
}

# Check if command requires git repository
command_requires_git() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.requires_git // false" "$CONFIG_FILE"
}

# Check if command requires arguments
command_requires_args() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.args_required // false" "$CONFIG_FILE"
}

# Get command error message
get_command_error_message() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.error_message // \"\"" "$CONFIG_FILE"
}

# Get command working directory
get_command_working_dir() {
    local category="$1"
    local command="$2"
    yq e ".categories.$category.commands.$command.working_dir // \"\"" "$CONFIG_FILE"
}

# Generate help documentation for category
generate_category_help() {
    local category="$1"
    local name=$(yq e ".categories.$category.name" "$CONFIG_FILE")
    local description=$(yq e ".categories.$category.description" "$CONFIG_FILE")
    
    echo "$name"
    echo "$description"
    echo ""
    echo "Commands:"
    
    # List all commands with descriptions and usage
    for cmd in $(get_category_commands "$category"); do
        local cmd_desc=$(yq e ".categories.$category.commands.$cmd.description" "$CONFIG_FILE")
        local cmd_usage=$(yq e ".categories.$category.commands.$cmd.usage" "$CONFIG_FILE")
        printf "  %-15s %s\n" "$cmd" "$cmd_desc"
        echo "    Usage: $cmd_usage"
        echo ""
    done
}

# Initialize configuration
init_config() {
    # Create user config directory if it doesn't exist
    [[ -d "$HOME/.config/me-tool" ]] || mkdir -p "$HOME/.config/me-tool"
    
    # Create user config file if it doesn't exist
    [[ -f "$USER_CONFIG_FILE" ]] || {
        cat > "$USER_CONFIG_FILE" << EOF
# Me Tool User Configuration
# This file will be merged with the system configuration

# Example of extending/overriding system config:
# categories:
#   git:
#     commands:
#       custom:
#         description: "Custom git command"
#         usage: "me git custom"
#         implementation: "git custom-command"
EOF
    }
}
