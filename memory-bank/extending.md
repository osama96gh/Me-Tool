# Extending Me Tool

This guide explains how to add new shortcuts and tools to the Me Tool.

## Table of Contents
1. [Adding Commands to Existing Categories](#adding-commands-to-existing-categories)
2. [Creating New Categories](#creating-new-categories)
3. [Core System Integration](#core-system-integration)
4. [Best Practices](#best-practices)
5. [Examples](#examples)

## Adding Commands to Existing Categories

### 1. Choose the Appropriate Category
The Me Tool organizes commands into categories:
- `sys`: System-related commands
- `git`: Git operations
- `dir`: Directory navigation
- `proj`: Project operations

### 2. Modify Category File
Navigate to `src/categories/` and edit the relevant category file (e.g., `sys.sh`).

1. Update Help Documentation:
```bash
show_sys_help() {
    cat << EOF
System Commands:
    existing    Existing command description
    newcmd     Your new command description  # Add this line

Usage:
    me sys existing    # Existing usage
    me sys newcmd     # Add your usage      # Add this line
EOF
}
```

2. Add Command Implementation:
```bash
execute_sys_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    case "$cmd" in
        # Existing commands...
        
        newcmd)
            print_info "Executing new command..."
            # Your command implementation here
            ;;
    esac
}
```

## Creating New Categories

### 1. Create Category File
Create a new file in `src/categories/` (e.g., `newcat.sh`):

```bash
#!/bin/zsh

# Show category help
show_newcat_help() {
    cat << EOF
New Category Commands:
    command1    First command description
    command2    Second command description

Usage:
    me newcat command1    # Command1 usage
    me newcat command2    # Command2 usage
EOF
}

# Execute category command
execute_newcat_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    case "$cmd" in
        command1)
            print_info "Executing command1..."
            # Command1 implementation
            ;;
        command2)
            print_info "Executing command2..."
            # Command2 implementation
            ;;
        *)
            print_error "Unknown command: $cmd"
            show_newcat_help
            return 1
            ;;
    esac
}
```

### 2. Update Core System

1. Modify `src/utils/parser.sh`:
```bash
# Update get_category()
get_category() {
    local cmd="$1"
    
    case "$cmd" in
        # Existing patterns...
        
        command1|command2)  # Add your commands
            echo "newcat"
            ;;
    esac
}

# Update validate_command()
validate_command() {
    local category="$1"
    local cmd="$2"
    
    case "$category" in
        newcat)  # Add your category
            case "$cmd" in
                command1|command2)  # Add your commands
                    return 0 ;;
                *) return 1 ;;
            esac
            ;;
    esac
}
```

2. Update `bin/me`:
```bash
# Update help message
show_help() {
    cat << EOF
Categories:
    sys      System commands
    git      Git operations
    dir      Directory navigation
    proj     Project operations
    newcat   Your category description  # Add this line
EOF
}

# Update category handling
case "$cmd" in
    sys|git|dir|proj|newcat)  # Add your category
        category="$cmd"
        cmd="$1"
        shift
        ;;
esac
```

## Best Practices

1. Command Naming
   - Use clear, descriptive names
   - Follow existing naming patterns
   - Avoid conflicts with existing commands

2. Error Handling
   - Use provided helper functions:
     * `print_error`: Display error messages
     * `print_info`: Show information
     * `print_success`: Indicate success
   - Validate inputs
   - Provide helpful error messages

3. Documentation
   - Update help documentation
   - Include usage examples
   - Document any requirements

4. Testing
   - Test basic functionality
   - Test error cases
   - Verify help documentation
   - Check for command conflicts

## Examples

### Adding a System Cleanup Command

1. Update `src/categories/sys.sh`:
```bash
# Add to help
show_sys_help() {
    cat << EOF
System Commands:
    cleanup    Clean temporary files
    
Usage:
    me sys cleanup    # Remove temporary files
EOF
}

# Add implementation
execute_sys_command() {
    case "$cmd" in
        cleanup)
            print_info "Cleaning temporary files..."
            rm -rf /tmp/*
            print_success "Cleanup complete"
            ;;
    esac
}
```

2. Update `src/utils/parser.sh`:
```bash
get_category() {
    case "$cmd" in
        cleanup)
            echo "sys"
            ;;
    esac
}
```

### Adding a New Category

Example of adding a 'docker' category:

1. Create `src/categories/docker.sh`:
```bash
#!/bin/zsh

show_docker_help() {
    cat << EOF
Docker Commands:
    ps        List containers
    images    List images
    
Usage:
    me docker ps        # List running containers
    me docker images    # List available images
EOF
}

execute_docker_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    case "$cmd" in
        ps)
            docker ps
            ;;
        images)
            docker images
            ;;
        *)
            print_error "Unknown docker command: $cmd"
            show_docker_help
            return 1
            ;;
    esac
}
```

2. Update core files as described in the [Core System Integration](#core-system-integration) section.

Remember to test thoroughly after adding new commands or categories. Use the help system to verify documentation, and test both success and error cases.
