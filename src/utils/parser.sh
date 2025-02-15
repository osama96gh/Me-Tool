#!/bin/zsh

# Me Tool - Command Parser

# Parse command arguments
parse_args() {
    # Initialize arrays
    set -A args
    set -A result
    
    # Copy arguments to args array
    for arg in "$@"; do
        args+=("$arg")
    done
    
    # Skip processing if no arguments
    if [[ ${#args} -eq 0 ]]; then
        return 1
    fi
    
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

# Get command category
get_category() {
    local cmd="$1"
    
    # First check if it's an explicit category
    if validate_category "$cmd"; then
        echo "$cmd"
        return 0
    fi
    
    # Then check command patterns
    case "$cmd" in
        # Git commands
        status|push|pull|commit|branch|checkout|merge)
            echo "git"
            ;;
        
        # Directory commands
        dev|doc|down|home|projects)
            echo "dir"
            ;;
        
        # Project commands
        serve|build|test|start|install)
            echo "proj"
            ;;
        
        # System commands
        update|clean|reboot|shutdown)
            echo "sys"
            ;;
        
        *)
            # Unknown command
            return 1
            ;;
    esac
    
    return 0
}

# Validate command for category
validate_command() {
    local category="$1"
    local cmd="$2"
    
    case "$category" in
        git)
            case "$cmd" in
                status|push|pull|commit|branch|checkout|merge)
                    return 0 ;;
                *) return 1 ;;
            esac
            ;;
        
        dir)
            case "$cmd" in
                dev|doc|down|home|projects)
                    return 0 ;;
                *) return 1 ;;
            esac
            ;;
        
        proj)
            case "$cmd" in
                serve|build|test|start|install)
                    return 0 ;;
                *) return 1 ;;
            esac
            ;;
        
        sys)
            case "$cmd" in
                update|clean|reboot|shutdown)
                    return 0 ;;
                *) return 1 ;;
            esac
            ;;
        
        *)
            return 1
            ;;
    esac
}

# Parse command string into parts
parse_command() {
    local input="$1"
    set -A parts
    
    # Split input into words
    set -A words
    words=(${(s: :)input})
    
    # Process each word
    for word in "${words[@]}"; do
        # Clean the word
        word="$(trim "$word")"
        
        # Skip empty words
        if is_empty "$word"; then
            continue
        fi
        
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
    set -A args
    for arg in "$@"; do
        args+=("$arg")
    done
    
    local start_index=2  # Skip category and command
    
    if [[ ${#args} -lt $start_index ]]; then
        echo ""
        return 0
    fi
    
    print -l -- "${args[@]:$start_index}"
    return 0
}

# Check if command needs confirmation
needs_confirmation() {
    local category="$1"
    local cmd="$2"
    
    case "$category" in
        sys)
            case "$cmd" in
                reboot|shutdown) return 0 ;;
                *) return 1 ;;
            esac
            ;;
        *) return 1 ;;
    esac
}

# Format command for display
format_command() {
    local category="$1"
    local cmd="$2"
    shift 2
    set -A args
    for arg in "$@"; do
        args+=("$arg")
    done
    
    local formatted="me"
    
    # Add category if provided
    if [[ -n "$category" ]]; then
        formatted+=" $category"
    fi
    
    # Add command
    formatted+=" $cmd"
    
    # Add arguments if any
    if [[ ${#args} -gt 0 ]]; then
        formatted+=" ${args[@]}"
    fi
    
    echo "$formatted"
}
