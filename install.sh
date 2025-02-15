#!/bin/zsh

# Me Tool Installation Script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

# Check for yq dependency
if ! command -v yq &> /dev/null; then
    print_error "yq is required for YAML parsing"
    print_info "Installing yq..."
    if command -v brew &> /dev/null; then
        brew install yq
    else
        print_error "Homebrew not found. Please install yq manually:"
        echo "Visit: https://github.com/mikefarah/yq#install"
        exit 1
    fi
fi

# Get the directory where the script is located
SCRIPT_DIR="${0:A:h}"

# Installation destination
INSTALL_DIR="$HOME/.me-tool"
BIN_DIR="$HOME/bin"
CONFIG_DIR="$HOME/.config/me-tool"

# Create installation directories
print_info "Creating installation directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"

# Copy files to installation directory
print_info "Copying files..."
cp -r "$SCRIPT_DIR/src" "$INSTALL_DIR/"
cp -r "$SCRIPT_DIR/bin/me" "$BIN_DIR/"

# Make scripts executable
print_info "Setting permissions..."
chmod +x "$BIN_DIR/me"
chmod +x "$INSTALL_DIR/src/utils/"*.sh

# Update script paths
print_info "Updating script paths..."
sed -i '' "s|PROJECT_ROOT=\"\${SCRIPT_DIR:h}\"|PROJECT_ROOT=\"$INSTALL_DIR\"|" "$BIN_DIR/me"

# Create user config if it doesn't exist
if [[ ! -f "$CONFIG_DIR/config.yml" ]]; then
    print_info "Creating user configuration..."
    cat > "$CONFIG_DIR/config.yml" << EOF
# Me Tool User Configuration
# This file will be merged with the system configuration

# Example of extending/overriding system config:
# categories:
#   custom:
#     name: "Custom Commands"
#     description: "Your custom command category"
#     commands:
#       example:
#         description: "Example custom command"
#         usage: "me custom example"
#         implementation: "echo 'Custom command executed'"
EOF
fi

# Add bin directory to current PATH
export PATH="$PATH:$BIN_DIR"

# Add to shell configuration if not already there
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    print_info "Making PATH changes permanent..."
    
    # Detect shell
    SHELL_RC=""
    if [[ "$SHELL" == */zsh ]]; then
        SHELL_RC="$HOME/.zshrc"
    elif [[ "$SHELL" == */bash ]]; then
        SHELL_RC="$HOME/.bashrc"
    fi
    
    if [[ -n "$SHELL_RC" ]]; then
        echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$SHELL_RC"
        print_success "Added $BIN_DIR to PATH in $SHELL_RC"
        print_info "Note: PATH is updated for current session"
        print_info "Changes will be permanent next time you open a terminal"
    else
        print_error "Unsupported shell: $SHELL"
        print_info "Please manually add $BIN_DIR to your PATH"
    fi
fi

print_success "\nMe Tool installation completed!"
print_info "\nUsage:"
echo "  me help           # Show help"
echo "  me git status     # Git status"
echo "  me dir goto dev   # Go to Development directory"
echo "  me sys update     # Update system"
echo "  me proj start     # Start development server"

print_info "\nCustomization:"
echo "  Edit ~/.config/me-tool/config.yml to add or modify commands"
echo "  Changes take effect immediately, no restart required"

print_info "\nFor more information, run: me help"
