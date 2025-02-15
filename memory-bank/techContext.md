# Technical Context

## Technology Stack
- Shell: Zsh (default shell)
- Implementation: Shell Script
- Configuration: YAML

## Development Environment
- macOS
- Command line interface
- Shell script development

## Project Structure
```
me-tool/
├── bin/
│   └── me              # Main executable
├── src/
│   ├── categories/     # Command categories
│   │   ├── sys.sh     # System commands
│   │   ├── git.sh     # Git commands
│   │   ├── dir.sh     # Directory commands
│   │   └── proj.sh    # Project commands
│   ├── utils/         
│   │   ├── parser.sh  # Smart command parsing
│   │   ├── resolver.sh # Command conflict resolution
│   │   └── helpers.sh # Utility functions
│   └── config/        
│       ├── paths.sh   # Path configurations
│       └── aliases.sh # Command aliases/shortcuts
└── tests/             
    └── categories/    # Category tests
```

## Dependencies
- Zsh shell
- YAML parser (for configuration)
- Standard Unix utilities

## Technical Requirements
- Shell script compatibility
- Efficient command parsing
- Fast execution
- Minimal resource usage
- Easy maintenance and extension
