# Me Tool

A smart command-line utility that provides shortcuts for frequently used commands with intelligent category-based organization and automatic command resolution.

## Features

- Dynamic command configuration through YAML
- Category-based command organization
- Smart command resolution
- User-customizable commands and categories
- Automatic help generation
- Support for command aliases
- Working directory management
- Git repository awareness
- Sudo and confirmation requirements

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/me-tool.git
cd me-tool

# Run installation script
./install.sh
```

The installation script will:
1. Check for and install required dependencies (yq)
2. Create necessary directories
3. Install the tool and configuration files
4. Add the tool to your PATH
5. Create a user configuration file

## Usage

Basic command structure:
```bash
me [category] <command> [arguments]
```

Examples:
```bash
me git status           # Show git status
me sys update          # Update system packages
me dir goto dev        # Navigate to development directory
me proj start          # Start development server
me help                # Show general help
me help git            # Show git category help
```

## Configuration

The Me Tool uses a YAML-based configuration system that allows for easy extension and customization.

### System Configuration

The system configuration (`src/config/config.yml`) defines the base commands and categories:

```yaml
categories:
  git:
    name: "Git Operations"
    description: "Git version control commands"
    commands:
      status:
        description: "Show git status"
        usage: "me git status"
        implementation: "git status"
        requires_git: true
```

### User Configuration

You can extend or override the system configuration by editing `~/.config/me-tool/config.yml`:

```yaml
categories:
  custom:
    name: "Custom Commands"
    description: "Your custom command category"
    commands:
      example:
        description: "Example custom command"
        usage: "me custom example"
        implementation: "echo 'Custom command executed'"
```

### Command Properties

Each command can have the following properties:

- `description`: Human-readable description
- `usage`: Usage example
- `implementation`: The actual command to execute
- `requires_git`: Whether the command requires a git repository
- `requires_sudo`: Whether the command needs sudo privileges
- `requires_confirmation`: Whether to prompt for confirmation
- `args_required`: Whether arguments are required
- `error_message`: Custom error message for invalid usage
- `working_dir`: Working directory for command execution

## Categories

### Git Operations
Git-related commands with repository awareness:
```bash
me git status          # Show repository status
me git push           # Push changes
me git pull          # Pull changes
me git commit        # Commit changes
me git branch        # Manage branches
me git checkout     # Switch branches
me git merge        # Merge branches
```

### System Operations
System maintenance and utilities:
```bash
me sys update        # Update system packages
me sys clean         # Clean system caches
me sys reboot        # Reboot system (requires confirmation)
```

### Directory Navigation
Quick directory navigation and management:
```bash
me dir goto work     # Navigate to work directory
me dir save proj     # Save current directory as 'proj'
me dir list          # List saved directories
```

### Project Operations
Project development commands:
```bash
me proj start        # Start development server
me proj build        # Build project
me proj test         # Run tests
```

## Extending

To add new commands or categories:

1. Edit your user configuration at `~/.config/me-tool/config.yml`
2. Add your new category and/or commands following the YAML structure
3. Changes take effect immediately - no restart required

Example of adding a new category:
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
      images:
        description: "List images"
        usage: "me docker images"
        implementation: "docker images"
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
