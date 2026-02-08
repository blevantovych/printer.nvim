#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DEPS_DIR="$PLUGIN_DIR/.tests/deps"

# nvim-treesitter commit that still includes ts_utils module
NVIM_TREESITTER_REV="42fc28ba918343ebfd5565147a42a26580579482"

# Clone dependencies if not present
if [ ! -d "$DEPS_DIR/plenary.nvim" ]; then
    echo "Installing plenary.nvim..."
    mkdir -p "$DEPS_DIR"
    git clone --depth 1 https://github.com/nvim-lua/plenary.nvim "$DEPS_DIR/plenary.nvim"
fi

if [ ! -d "$DEPS_DIR/nvim-treesitter" ]; then
    echo "Installing nvim-treesitter..."
    mkdir -p "$DEPS_DIR"
    git clone https://github.com/nvim-treesitter/nvim-treesitter "$DEPS_DIR/nvim-treesitter"
    git -C "$DEPS_DIR/nvim-treesitter" checkout "$NVIM_TREESITTER_REV"
fi

# Ensure JavaScript and TSX parsers are installed
nvim --headless --clean \
    -u "$SCRIPT_DIR/minimal_init.lua" \
    -c "TSInstallSync! javascript tsx" \
    -c "qa" 2>/dev/null || true

cd "$SCRIPT_DIR"

exit_code=0

for test_file in *.lua
do
    [ "$test_file" = "minimal_init.lua" ] && continue
    [ "$test_file" = "helpers.lua" ] && continue

    filename="${test_file%.*}"

    # Find fixture file (.js, .jsx, or .tsx)
    input_file=""
    for ext in js jsx tsx; do
        if [ -f "$filename.$ext" ]; then
            input_file="$filename.$ext"
            break
        fi
    done

    if [ -z "$input_file" ]; then
        echo "No fixture found for $test_file, skipping."
        continue
    fi

    # Detect parser language from extension
    case "$input_file" in
        *.tsx) lang="tsx" ;;
        *)     lang="javascript" ;;
    esac

    echo "Running $test_file..."
    nvim --headless --clean \
        -u "$SCRIPT_DIR/minimal_init.lua" \
        "$input_file" \
        -c "lua vim.treesitter.get_parser(0, '$lang'):parse()" \
        -c "lua require('plenary.busted').run('$SCRIPT_DIR/$test_file')" || exit_code=1
done

exit $exit_code
