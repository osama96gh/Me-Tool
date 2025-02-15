#!/bin/zsh

# Me Tool - Git Category Implementation

# Show git category help
show_git_help() {
    cat << EOF
Git Commands:
  status    Show git status
  push      Push changes to remote
  pull      Pull changes from remote
  commit    Commit changes
  branch    Show or manage branches
  checkout  Switch branches
  merge     Merge branches

Usage:
  me git status          # Show repository status
  me git push           # Push to remote
  me git pull          # Pull from remote
  me git commit -m "..." # Commit with message
  me git branch        # List branches
  me git checkout dev  # Switch to dev branch
  me git merge main    # Merge main into current branch
EOF
}

# Execute git category command
execute_git_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    # Check if we're in a git repository
    if ! is_git_repository && [[ "$cmd" != "help" ]]; then
        print_error "Not in a git repository"
        return 1
    fi
    
    case "$cmd" in
        help)
            show_git_help
            ;;
        
        status)
            git status
            ;;
        
        push)
            if [[ ${#args} -eq 0 ]]; then
                # Default push behavior
                git push
            else
                # Push with arguments
                git push "${args[@]}"
            fi
            ;;
        
        pull)
            if [[ ${#args} -eq 0 ]]; then
                # Default pull behavior
                git pull
            else
                # Pull with arguments
                git pull "${args[@]}"
            fi
            ;;
        
        commit)
            if [[ ${#args} -eq 0 ]]; then
                print_error "Commit message required"
                echo "Usage: me git commit -m \"your message\""
                return 1
            else
                git commit "${args[@]}"
            fi
            ;;
        
        branch)
            if [[ ${#args} -eq 0 ]]; then
                # List branches
                git branch
            else
                # Branch operations with arguments
                git branch "${args[@]}"
            fi
            ;;
        
        checkout)
            if [[ ${#args} -eq 0 ]]; then
                print_error "Branch name required"
                echo "Usage: me git checkout <branch-name>"
                return 1
            else
                git checkout "${args[@]}"
            fi
            ;;
        
        merge)
            if [[ ${#args} -eq 0 ]]; then
                print_error "Branch name required"
                echo "Usage: me git merge <branch-name>"
                return 1
            else
                git merge "${args[@]}"
            fi
            ;;
        
        *)
            print_error "Unknown git command: $cmd"
            show_git_help
            return 1
            ;;
    esac
    
    return 0
}
