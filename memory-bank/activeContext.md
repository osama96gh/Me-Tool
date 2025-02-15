# Active Context

## Recent Changes
- Implemented dynamic configuration system using YAML
- Removed hardcoded category files in favor of config-driven approach
- Added yq dependency for YAML parsing
- Created user configuration support
- Updated installation process to handle configuration setup

## Current Focus
The system now uses a single source of truth (config.yml) for all command definitions, making it easier to:
- Add/remove categories
- Modify commands
- Extend functionality
- Customize behavior

## Active Decisions
1. Configuration Structure
   - System config in src/config/config.yml
   - User config in ~/.config/me-tool/config.yml
   - User config merges with system config

2. Command Properties
   - description: Human-readable description
   - usage: Usage example
   - implementation: Actual command to execute
   - requires_git: Git repository requirement
   - requires_sudo: Sudo requirement
   - requires_confirmation: Confirmation prompt
   - args_required: Argument requirement
   - error_message: Custom error message
   - working_dir: Working directory control

3. Dynamic Command Resolution
   - Commands resolved through YAML configuration
   - No hardcoded category files
   - Immediate effect of configuration changes
   - Support for command aliases

## Next Steps
1. Testing
   - Verify all commands work as expected
   - Test user configuration override
   - Test error handling
   - Test working directory management

2. Documentation
   - Update extending.md with new configuration approach
   - Add configuration examples
   - Document user customization process

3. Future Improvements
   - Add command validation in config
   - Support for command dependencies
   - Environment variable interpolation
   - Command suggestion system
