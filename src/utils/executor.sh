#!/bin/zsh

# Me Tool - Dynamic Command Executor

# Execute command based on configuration
execute_command() {
    local category="$1"
    local cmd="$2"
    shift 2
    typeset -a args
    args=($@)
    
    # Get command information
    local implementation
    implementation=$(get_command_implementation "$category" "$cmd") || {
        print_error "Unknown command: $category $cmd"
        return 1
    }
    
    # Check git repository requirement
    local requires_git
    requires_git=$(command_requires_git "$category" "$cmd")
    if [[ "$requires_git" == "true" ]]; then
        if ! is_git_repository; then
            print_error "Not in a git repository"
            return 1
        fi
    fi
    
    # Check argument requirement
    local args_required
    args_required=$(command_requires_args "$category" "$cmd")
    if [[ "$args_required" == "true" ]]; then
        if [[ ${#args} -eq 0 ]]; then
            local error_msg
            error_msg=$(get_command_error_message "$category" "$cmd")
            print_error "${error_msg:-"Arguments required for this command"}"
            echo "Usage: $(yq e ".categories.$category.commands.$cmd.usage" "$CONFIG_FILE")"
            return 1
        fi
    fi
    
    # Check confirmation requirement
    local needs_confirmation
    needs_confirmation=$(command_needs_confirmation "$category" "$cmd")
    if [[ "$needs_confirmation" == "true" ]]; then
        print_warning "This command requires confirmation"
        read "response?Are you sure you want to continue? [y/N] "
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Operation cancelled"
            return 0
        fi
    fi
    
    # Handle working directory
    local working_dir
    working_dir=$(get_command_working_dir "$category" "$cmd")
    if [[ -n "$working_dir" ]]; then
        case "$working_dir" in
            "project_root")
                # Find project root (e.g., directory with package.json)
                local current_dir="$PWD"
                while [[ "$current_dir" != "/" ]]; do
                    if [[ -f "$current_dir/package.json" ]]; then
                        cd "$current_dir"
                        break
                    fi
                    current_dir="$(dirname "$current_dir")"
                done
                ;;
            *)
                cd "$working_dir"
                ;;
        esac
    fi
    
    # Execute command
    local exit_code=0
    local needs_sudo
    needs_sudo=$(command_needs_sudo "$category" "$cmd")
    if [[ "$needs_sudo" == "true" ]]; then
        if [[ ${#args} -eq 0 ]]; then
            sudo $implementation
        else
            sudo $implementation "${args[@]}"
        fi
        exit_code=$?
    else
        if [[ ${#args} -eq 0 ]]; then
            eval "$implementation"
        else
            eval "$implementation ${args[@]}"
        fi
        exit_code=$?
    fi
    
    # Restore original directory if changed
    [[ -n "$working_dir" ]] && cd - > /dev/null
    
    return $exit_code
}

# Show help for category
show_category_help() {
    local category="$1"
    generate_category_help "$category"
}

# Show general help
show_general_help() {
    echo "Me Tool - Command Line Utility"
    echo ""
    echo "Categories:"
    
    local category name description
    for category in $(get_categories); do
        name=$(yq e ".categories.$category.name" "$CONFIG_FILE")
        description=$(yq e ".categories.$category.description" "$CONFIG_FILE")
        printf "  %-15s %s\n" "$category" "$name"
        echo "    $description"
        echo ""
    done
    
    echo "Usage: me <category> <command> [args...]"
    echo "       me help             Show this help"
    echo "       me <category> help  Show category help"
}
