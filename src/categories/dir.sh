#!/bin/zsh

# Me Tool - Directory Navigation Category Implementation

# Show directory category help
show_dir_help() {
    cat << EOF
Directory Navigation Commands:
  dev       Go to Development directory
  doc       Go to Documents directory
  down      Go to Downloads directory
  home      Go to Home directory
  projects  Go to Projects directory

Usage:
  me dir dev      # cd to Development
  me dir doc      # cd to Documents
  me dir down     # cd to Downloads
  me dir home     # cd to Home
  me dir projects # cd to Projects

Note: These commands can also be used directly:
  me dev          # Same as 'me dir dev'
  me doc          # Same as 'me dir doc'
  me down         # Same as 'me dir down'
EOF
}

# Execute directory category command
execute_dir_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    # Get target directory based on command
    local target_dir=""
    case "$cmd" in
        help)
            show_dir_help
            return 0
            ;;
        
        dev|development)
            target_dir="$(get_dev_dir)"
            ;;
        
        doc|documents)
            target_dir="$(get_documents_dir)"
            ;;
        
        down|downloads)
            target_dir="$(get_downloads_dir)"
            ;;
        
        home)
            target_dir="$(get_home_dir)"
            ;;
        
        projects)
            target_dir="$(get_dev_dir)/Projects"
            ;;
        
        *)
            print_error "Unknown directory command: $cmd"
            show_dir_help
            return 1
            ;;
    esac
    
    # Validate target directory
    if [[ ! -d "$target_dir" ]]; then
        print_error "Directory does not exist: $target_dir"
        
        # Offer to create directory
        echo -n "Would you like to create this directory? [y/N] "
        read -r response
        
        if [[ "$response" =~ ^[Yy]$ ]]; then
            mkdir -p "$target_dir"
            print_success "Created directory: $target_dir"
        else
            return 1
        fi
    fi
    
    # Change to target directory
    cd "$target_dir" && print_success "Changed to directory: $target_dir"
    
    # Show git status if it's a git repository
    if is_git_repository; then
        git status
    fi
    
    return 0
}
