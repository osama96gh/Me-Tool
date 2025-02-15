#!/bin/zsh

# Me Tool - Project Category Implementation

# Show project category help
show_proj_help() {
    cat << EOF
Project Commands:
  serve     Start development server
  build     Build project
  test      Run tests
  install   Install dependencies
  start     Start project
  status    Show project status

Usage:
  me proj serve    # Start development server
  me proj build    # Build project
  me proj test     # Run tests
  me proj install  # Install dependencies
  me proj start    # Start project
  me proj status   # Show project status

Note: These commands can also be used directly:
  me serve         # Same as 'me proj serve'
  me build         # Same as 'me proj build'
  me test          # Same as 'me proj test'
EOF
}

# Detect project type
detect_project_type() {
    if [[ -f "package.json" ]]; then
        echo "node"
    elif [[ -f "requirements.txt" ]]; then
        echo "python"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "go.mod" ]]; then
        echo "go"
    else
        echo "unknown"
    fi
}

# Execute project category command
execute_proj_command() {
    local cmd="$1"
    shift
    typeset -a args
    args=($@)
    
    # Get project type
    local proj_type="$(detect_project_type)"
    
    case "$cmd" in
        help)
            show_proj_help
            ;;
        
        serve)
            case "$proj_type" in
                node)
                    if grep -q "\"dev\"" package.json; then
                        npm run dev
                    elif grep -q "\"serve\"" package.json; then
                        npm run serve
                    elif grep -q "\"start\"" package.json; then
                        npm start
                    else
                        print_error "No development script found in package.json"
                        return 1
                    fi
                    ;;
                python)
                    if [[ -f "manage.py" ]]; then
                        python manage.py runserver
                    elif [[ -f "app.py" ]]; then
                        python app.py
                    else
                        print_error "No server script found"
                        return 1
                    fi
                    ;;
                *)
                    print_error "Project type not supported or couldn't be detected"
                    return 1
                    ;;
            esac
            ;;
        
        build)
            case "$proj_type" in
                node)
                    if grep -q "\"build\"" package.json; then
                        npm run build
                    else
                        print_error "No build script found in package.json"
                        return 1
                    fi
                    ;;
                rust)
                    cargo build
                    ;;
                go)
                    go build
                    ;;
                *)
                    print_error "Project type not supported or couldn't be detected"
                    return 1
                    ;;
            esac
            ;;
        
        test)
            case "$proj_type" in
                node)
                    if grep -q "\"test\"" package.json; then
                        npm test
                    else
                        print_error "No test script found in package.json"
                        return 1
                    fi
                    ;;
                python)
                    if [[ -f "pytest.ini" ]]; then
                        pytest
                    elif [[ -f "manage.py" ]]; then
                        python manage.py test
                    else
                        python -m unittest discover
                    fi
                    ;;
                rust)
                    cargo test
                    ;;
                go)
                    go test ./...
                    ;;
                *)
                    print_error "Project type not supported or couldn't be detected"
                    return 1
                    ;;
            esac
            ;;
        
        install)
            case "$proj_type" in
                node)
                    npm install
                    ;;
                python)
                    if [[ -f "requirements.txt" ]]; then
                        pip install -r requirements.txt
                    else
                        print_error "No requirements.txt found"
                        return 1
                    fi
                    ;;
                rust)
                    cargo fetch
                    ;;
                go)
                    go mod download
                    ;;
                *)
                    print_error "Project type not supported or couldn't be detected"
                    return 1
                    ;;
            esac
            ;;
        
        start)
            case "$proj_type" in
                node)
                    if grep -q "\"start\"" package.json; then
                        npm start
                    else
                        print_error "No start script found in package.json"
                        return 1
                    fi
                    ;;
                python)
                    if [[ -f "manage.py" ]]; then
                        python manage.py runserver
                    elif [[ -f "app.py" ]]; then
                        python app.py
                    else
                        print_error "No start script found"
                        return 1
                    fi
                    ;;
                *)
                    print_error "Project type not supported or couldn't be detected"
                    return 1
                    ;;
            esac
            ;;
        
        status)
            print_info "Project Status:"
            echo "Type: $proj_type"
            
            case "$proj_type" in
                node)
                    echo "\nNode version: $(node -v)"
                    echo "NPM version: $(npm -v)"
                    echo "\nDependencies:"
                    npm list --depth=0
                    ;;
                python)
                    echo "\nPython version: $(python --version)"
                    if [[ -f "requirements.txt" ]]; then
                        echo "\nDependencies:"
                        cat requirements.txt
                    fi
                    ;;
                rust)
                    echo "\nRust version: $(rustc --version)"
                    echo "Cargo version: $(cargo --version)"
                    ;;
                go)
                    echo "\nGo version: $(go version)"
                    ;;
                *)
                    print_error "Project type not supported or couldn't be detected"
                    return 1
                    ;;
            esac
            ;;
        
        *)
            print_error "Unknown project command: $cmd"
            show_proj_help
            return 1
            ;;
    esac
    
    return 0
}
