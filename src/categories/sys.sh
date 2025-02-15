#!/bin/zsh

# Me Tool - System Category Implementation

# Show system category help
show_sys_help() {
    cat << EOF
System Commands:
  update    Update system and packages
  clean     Clean up system
  disk      Show disk usage
  reboot    Reboot system
  shutdown  Shutdown system

Usage:
  me sys update   # Update system and packages
  me sys clean    # Clean up system
  me sys disk     # Show disk usage
  me sys reboot   # Reboot system
  me sys shutdown # Shutdown system

Note: These commands can also be used directly:
  me update       # Same as 'me sys update'
  me clean        # Same as 'me sys clean'
EOF
}

# Execute system category command
execute_sys_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    case "$cmd" in
        help)
            show_sys_help
            ;;
        
        update)
            print_info "Updating system and packages..."
            
            # Check if brew exists
            if command_exists "brew"; then
                print_info "Updating Homebrew..."
                brew update && brew upgrade
                
                # Cleanup old versions
                print_info "Cleaning up old versions..."
                brew cleanup
            else
                print_error "Homebrew not found. Please install it first."
                return 1
            fi
            
            print_success "System update completed"
            ;;
        
        clean)
            print_info "Cleaning up system..."
            
            # Clear terminal
            clear
            
            # Clean up system logs
            if [[ -d "/var/log" ]]; then
                print_info "Cleaning system logs..."
                sudo rm -rf /var/log/*
            fi
            
            # Clean up temporary files
            print_info "Cleaning temporary files..."
            rm -rf ~/Library/Caches/*
            
            # Clean up downloads folder (optional)
            echo -n "Would you like to clean up Downloads folder? [y/N] "
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                print_info "Cleaning Downloads folder..."
                rm -rf ~/Downloads/*
            fi
            
            print_success "System cleanup completed"
            ;;
        
        disk)
            print_info "Disk usage summary:"
            df -h
            
            print_info "\nLargest directories in home:"
            du -h ~/ 2>/dev/null | sort -rh | head -n 10
            ;;
        
        reboot)
            print_info "Preparing to reboot system..."
            echo -n "Are you sure you want to reboot? [y/N] "
            read -r response
            
            if [[ "$response" =~ ^[Yy]$ ]]; then
                sudo shutdown -r now
            else
                print_info "Reboot cancelled"
            fi
            ;;
        
        shutdown)
            print_info "Preparing to shutdown system..."
            echo -n "Are you sure you want to shutdown? [y/N] "
            read -r response
            
            if [[ "$response" =~ ^[Yy]$ ]]; then
                sudo shutdown -h now
            else
                print_info "Shutdown cancelled"
            fi
            ;;
        
        *)
            print_error "Unknown system command: $cmd"
            show_sys_help
            return 1
            ;;
    esac
    
    return 0
}
