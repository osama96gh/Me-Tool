#!/bin/zsh

# Me Tool - Command Parser

# Source configuration manager
source "$PROJECT_ROOT/src/utils/config.sh"

# Initialize configuration
init_config

# Parse command arguments
parse_args() {
    # Initialize arrays
    typeset -a args
    typeset -a result
    
    # Copy arguments to args array
    args=($@)
    
    # Skip processing if no arguments
    [[ ${#args} -eq 0 ]] && return 1
    
    # Process arguments
    local i=0
    while [[ $i -lt ${#args} ]]; do
        local arg="${args[$i]}"
        
        # Handle special cases
        case "$arg" in
            -h|--help)
                result+=("help")
                ;;
            -v|--version)
                result+=("version")
                ;;
            *)
                # Clean and validate argument
                arg="$(trim "$arg")"
                if is_alphanumeric "$arg"; then
                    result+=("$arg")
                else
                    print_error "Invalid argument: $arg"
                    return 1
                fi
                ;;
        esac
        
        ((i++))
    done
    
    print -l -- "${result[@]}"
    return 0
}

# Get command category from config
get_category() {
    local cmd="$1"
    
    # Check if it's a valid category
    yq e ".categories.$cmd" "$CONFIG_FILE" &> /dev/null && {
        echo "$cmd"
        return 0
    }
    
    # Search for command in all categories
    local category
    for category in $(get_categories); do
        yq e ".categories.$category.commands.$cmd" "$CONFIG_FILE" &> /dev/null && {
            echo "$category"
            return 0
        }
    done
    
    return 1
}

# Validate command for category
validate_command() {
    local category="$1"
    local cmd="$2"
    
    # Check if command exists in category
    yq e ".categories.$category.commands.$cmd" "$CONFIG_FILE" &> /dev/null && return 0
    
    return 1
}

# Parse command string into parts
parse_command() {
    local input="$1"
    typeset -a parts
    
    # Split input into words
    typeset -a words
    words=(${(s: :)input})
    
    # Process each word
    local word
    for word in "${words[@]}"; do
        # Clean the word
        word="$(trim "$word")"
        
        # Skip empty words
        is_empty "$word" && continue
        
        # Validate word
        if ! is_alphanumeric "$word"; then
            print_error "Invalid command part: $word"
            return 1
        fi
        
        parts+=("$word")
    done
    
    print -l -- "${parts[@]}"
    return 0
}

# Get command arguments
get_command_args() {
    typeset -a args
    args=($@)
    
    local start_index=2  # Skip category and command
    
    [[ ${#args} -lt $start_index ]] && {
        echo ""
        return 0
    }
    
    print -l -- "${args[@]:$start_index}"
    return 0
}

# Check if command needs confirmation
needs_confirmation() {
    command_needs_confirmation "$1" "$2"
}

# Format command for display
format_command() {
    local category="$1"
    local cmd="$2"
    shift 2
    typeset -a args
    args=($@)
    
    local formatted="me"
    
    # Add category if provided
    [[ -n "$category" ]] && formatted+=" $category"
    
    # Add command
    formatted+=" $cmd"
    
    # Add arguments if any
    [[ ${#args} -gt 0 ]] && formatted+=" ${args[@]}"
    
    echo "$formatted"
}
