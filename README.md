# Me Tool

A smart command-line utility that provides shortcuts for frequently used commands with intelligent category-based organization.

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/me-tool.git

# Navigate to the directory
cd me-tool

# Run the installation script
./install.sh
```

## Usage

The Me Tool organizes commands into categories for easy access. You can use commands either with or without explicitly specifying their category.

### Basic Syntax

```bash
me [category] <command> [arguments]
```

### Categories

1. System Commands (sys)
```bash
# Update system and packages
me sys update

# Clean up system
me sys clean

# Show disk usage
me sys disk

# System operations (requires confirmation)
me sys reboot
me sys shutdown
```

2. Git Operations (git)
```bash
# Show repository status
me git status

# Push/pull changes
me git push
me git pull

# Commit changes
me git commit -m "your message"

# Branch operations
me git branch          # List branches
me git checkout main   # Switch to main branch
me git merge dev      # Merge dev branch
```

3. Directory Navigation (dir)
```bash
# Quick directory access
me dir dev       # Go to Development directory
me dir doc       # Go to Documents
me dir down      # Go to Downloads
me dir home      # Go to Home directory
me dir projects  # Go to Projects directory
```

4. Project Operations (proj)
```bash
# Show project status
me proj status

# Development server
me proj serve

# Build project
me proj build

# Run tests
me proj test

# Dependency management
me proj install
```

### Smart Command Resolution

You can use commands without specifying their category. The tool will automatically determine the appropriate category:

```bash
me status    # Same as 'me git status' if in a git repository
me update    # Same as 'me sys update'
me dev       # Same as 'me dir dev'
me build     # Same as 'me proj build'
```

If a command exists in multiple categories, you'll be prompted to choose:
```bash
$ me status
Command 'status' exists in multiple categories:
1) git status
2) proj status
Select category (1-2):
```

### Getting Help

```bash
# Show general help
me help

# Show category-specific help
me help sys
me help git
me help dir
me help proj
```

## Features

- Smart command resolution
- Category-based organization
- Command conflict handling
- Intuitive navigation
- Project type detection
- System operation shortcuts
- Git workflow optimization

## Project Types

The project category automatically detects and supports different project types:

1. Node.js Projects
   - Detected by `package.json`
   - Supports npm commands
   - Handles dev servers

2. Python Projects
   - Detected by `requirements.txt`
   - Supports pip package management
   - Handles Django/Flask servers

3. Rust Projects
   - Detected by `Cargo.toml`
   - Supports cargo commands

4. Go Projects
   - Detected by `go.mod`
   - Supports go commands

## Examples

1. Git Workflow
```bash
me status              # Check git status
me pull               # Pull latest changes
me commit -m "fix"    # Commit changes
me push               # Push to remote
```

2. Project Development
```bash
me proj install       # Install dependencies
me serve             # Start development server
me test              # Run tests
me build             # Build project
```

3. System Management
```bash
me sys update        # Update system
me sys clean         # Clean up system
me sys disk          # Check disk usage
```

4. Directory Navigation
```bash
me dev              # Go to Development directory
me projects         # Go to Projects directory
```

## Contributing

See [extending.md](memory-bank/extending.md) for detailed information on how to add new commands and categories to the Me Tool.

## License

MIT License - feel free to use and modify as needed.
