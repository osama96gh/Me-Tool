# System Patterns

## Configuration-Driven Architecture
```mermaid
flowchart TD
    A[System Config] --> C[Config Manager]
    B[User Config] --> C
    C --> D[Command Maps]
    D --> E[Command Execution]
    
    subgraph Config
        F[Categories]
        G[Commands]
        H[Properties]
        
        F --> G
        G --> H
    end
    
    C --> Config
```

## Command Resolution Flow
```mermaid
flowchart TD
    A[Command Input] --> B[Parse Command]
    B --> C{Category Specified?}
    
    C -->|Yes| D[Load Category]
    C -->|No| E[Find Command Category]
    
    D --> F[Validate Command]
    E --> F
    
    F --> G{Valid Command?}
    G -->|Yes| H[Load Command Config]
    G -->|No| I[Show Error]
    
    H --> J[Check Requirements]
    J --> K{Requirements Met?}
    K -->|Yes| L[Execute Command]
    K -->|No| M[Show Error]
```

## Configuration Management
```mermaid
flowchart TD
    A[Load Configs] --> B{User Config Exists?}
    
    B -->|Yes| C[Merge Configs]
    B -->|No| D[Use System Config]
    
    C --> E[Build Command Maps]
    D --> E
    
    E --> F[Category Map]
    E --> G[Command Map]
    E --> H[Property Map]
```

## Command Properties
Each command in the configuration defines:
- Description and usage
- Implementation details
- Execution requirements
- Error handling
- Working directory

## Command Categories
Categories are defined in config.yml with:
- Category name and description
- Command definitions
- Category-specific settings
- Help documentation

## Configuration Structure
```yaml
categories:
  category_name:
    name: "Display Name"
    description: "Category Description"
    commands:
      command_name:
        description: "Command Description"
        usage: "Usage Example"
        implementation: "Command to Execute"
        # Optional properties
        requires_git: boolean
        requires_sudo: boolean
        requires_confirmation: boolean
        args_required: boolean
        error_message: "Custom Error"
        working_dir: "Directory Path"
```

## Error Handling
- Configuration validation
- Command validation
- Requirement checking
- User-friendly error messages
- Custom error messages per command

## Extension Pattern
New functionality can be added by:
1. Editing user config (~/.config/me-tool/config.yml)
2. Adding new category or commands
3. Defining command properties
4. Changes take effect immediately

## Help System
Help documentation is generated from:
- Category descriptions
- Command descriptions
- Usage examples
- All sourced from configuration

## Working Directory Management
Commands can specify working directory:
- Absolute paths
- Special values (e.g., "project_root")
- Directory is restored after execution
