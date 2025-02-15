# Extending Me Tool

This guide explains how to extend and customize the Me Tool using the configuration system.

## Table of Contents
1. [Configuration Overview](#configuration-overview)
2. [Adding Commands](#adding-commands)
3. [Creating Categories](#creating-categories)
4. [Command Properties](#command-properties)
5. [Examples](#examples)

## Configuration Overview

The Me Tool uses a dual-configuration system:
1. System configuration (`src/config/config.yml`)
2. User configuration (`~/.config/me-tool/config.yml`)

User configuration overrides and extends the system configuration, allowing for customization without modifying the core system.

## Adding Commands

### 1. Edit User Configuration
Open `~/.config/me-tool/config.yml` and add your commands under the appropriate category:

```yaml
categories:
  git:  # Existing category
    commands:
      custom:  # New command
        description: "Custom git command"
        usage: "me git custom [args]"
        implementation: "git custom-command"
        requires_git: true
```

### 2. Command Properties
Each command requires:
- `description`: Human-readable description
- `usage`: Usage example
- `implementation`: Actual command to execute

Optional properties:
- `requires_git`: Git repository requirement
- `requires_sudo`: Sudo requirement
- `requires_confirmation`: Confirmation prompt
- `args_required`: Argument requirement
- `error_message`: Custom error message
- `working_dir`: Working directory control

## Creating Categories

### 1. Add Category Definition
Add a new category to your user configuration:

```yaml
categories:
  docker:  # New category
    name: "Docker Commands"
    description: "Docker container management"
    commands:
      ps:
        description: "List containers"
        usage: "me docker ps"
        implementation: "docker ps"
      images:
        description: "List images"
        usage: "me docker images"
        implementation: "docker images"
```

### 2. Category Properties
Each category requires:
- `name`: Display name
- `description`: Category description
- `commands`: Command definitions

## Command Properties

### Basic Properties
```yaml
command_name:
  description: "Command description"
  usage: "Usage example"
  implementation: "Command to execute"
```

### Advanced Properties
```yaml
command_name:
  description: "Command description"
  usage: "Usage example"
  implementation: "Command to execute"
  requires_git: true       # Requires git repository
  requires_sudo: true      # Requires sudo privileges
  requires_confirmation: true  # Requires user confirmation
  args_required: true      # Requires arguments
  error_message: "Custom error"  # Custom error message
  working_dir: "project_root"  # Working directory
```

## Examples

### Adding Git Commands
```yaml
categories:
  git:
    commands:
      stash-all:
        description: "Stash all changes including untracked files"
        usage: "me git stash-all"
        implementation: "git stash --include-untracked"
        requires_git: true
```

### Creating a Docker Category
```yaml
categories:
  docker:
    name: "Docker Commands"
    description: "Docker container management"
    commands:
      ps:
        description: "List containers"
        usage: "me docker ps"
        implementation: "docker ps"
      stop-all:
        description: "Stop all containers"
        usage: "me docker stop-all"
        implementation: "docker stop $(docker ps -q)"
        requires_confirmation: true
        error_message: "No running containers"
```

### Project-Specific Commands
```yaml
categories:
  proj:
    commands:
      deploy:
        description: "Deploy to production"
        usage: "me proj deploy"
        implementation: "npm run deploy"
        working_dir: "project_root"
        requires_confirmation: true
```

### System Utilities
```yaml
categories:
  sys:
    commands:
      cleanup:
        description: "Clean system caches"
        usage: "me sys cleanup"
        implementation: "rm -rf ~/Library/Caches/*"
        requires_confirmation: true
        requires_sudo: true
```

## Best Practices

1. Command Naming
   - Use clear, descriptive names
   - Follow existing naming patterns
   - Use hyphens for multi-word commands

2. Command Properties
   - Always provide clear descriptions
   - Include helpful usage examples
   - Set appropriate requirements
   - Use meaningful error messages

3. Implementation
   - Test commands thoroughly
   - Consider error cases
   - Use appropriate working directories
   - Handle command arguments properly

4. Documentation
   - Keep command descriptions up to date
   - Document any prerequisites
   - Include example usage
   - Explain any special behavior

## Testing

After adding new commands:
1. Verify help documentation (`me help <category>`)
2. Test basic functionality
3. Test with various arguments
4. Verify error handling
5. Check working directory behavior

Changes take effect immediately - no restart required.
