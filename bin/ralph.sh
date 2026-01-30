#!/bin/bash
# Based on Geoffrey Huntley's loop methodology
# https://ghuntley.com/loop/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Dependency check ---
check_dependencies() {
  if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required. Install with: brew install jq${NC}" >&2
    exit 1
  fi
}

check_dependencies

# --- Number formatting ---
# Format large numbers with K/M suffixes for human readability
# Usage: format_number 45200 -> "45.2K"
format_number() {
  local num="$1"
  
  # Handle empty or non-numeric input
  if [[ -z "$num" ]] || ! [[ "$num" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    echo "0"
    return
  fi
  
  # Use awk for floating point math
  awk -v n="$num" 'BEGIN {
    if (n >= 1000000) {
      printf "%.1fM", n / 1000000
    } else if (n >= 1000) {
      printf "%.1fK", n / 1000
    } else {
      printf "%.0f", n
    }
  }'
}

# --- Usage ---
usage() {
  echo "Usage: Ralph.sh [OPTIONS] [SPEC_FILE]"
  echo ""
  echo "Run an agentic loop using a markdown spec file."
  echo ""
  echo "Options:"
  echo "  --tool <opencode|claude>  Override tool selection"
  echo "  --model <model>           Model to use (e.g., anthropic/claude-sonnet-4-5)"
  echo "  -h, --help                Show this help message"
  echo ""
  echo "Spec file discovery (if not provided):"
  echo "  Looks for .ralph.md, ralph.md, or agents.md in current directory"
  echo ""
  echo "Environment variables:"
  echo "  RALPH_TOOL    Set default tool (opencode or claude)"
  echo "  RALPH_MODEL   Set default model"
  echo ""
  echo "Examples:"
  echo "  Ralph.sh                           # Auto-discover spec in current dir"
  echo "  Ralph.sh ./my-spec.md              # Use explicit spec file"
  echo "  Ralph.sh --tool opencode           # Force opencode"
  echo "  Ralph.sh --model anthropic/claude-sonnet-4-5  # Use specific model"
  echo "  RALPH_TOOL=claude Ralph.sh         # Use claude via env var"
  exit 0
}

# --- Argument parsing ---
TOOL_ARG=""
MODEL_ARG=""
SPEC_FILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --tool)
      TOOL_ARG="$2"
      shift 2
      ;;
    --model|-m)
      MODEL_ARG="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      SPEC_FILE="$1"
      shift
      ;;
  esac
done

# --- Tool selection ---
# Priority: CLI arg > env var > auto-detect
select_tool() {
  local tool=""
  
  # 1. CLI argument
  if [[ -n "$TOOL_ARG" ]]; then
    tool="$TOOL_ARG"
  # 2. Environment variable
  elif [[ -n "$RALPH_TOOL" ]]; then
    tool="$RALPH_TOOL"
  # 3. Auto-detect
  elif command -v opencode &> /dev/null; then
    tool="opencode"
  elif command -v claude &> /dev/null; then
    tool="claude"
  fi
  
  # Validate
  if [[ -z "$tool" ]]; then
    echo -e "${RED}Error: No supported tool found. Install opencode or claude.${NC}" >&2
    exit 1
  fi
  
  if [[ "$tool" != "opencode" && "$tool" != "claude" ]]; then
    echo -e "${RED}Error: Invalid tool '$tool'. Must be 'opencode' or 'claude'.${NC}" >&2
    exit 1
  fi
  
  # Verify tool exists
  if ! command -v "$tool" &> /dev/null; then
    echo -e "${RED}Error: Tool '$tool' not found in PATH.${NC}" >&2
    exit 1
  fi
  
  echo "$tool"
}

# --- Spec file discovery ---
find_spec_file() {
  local spec_names=(".ralph.md" "ralph.md" "agents.md")
  
  for name in "${spec_names[@]}"; do
    if [[ -f "$name" ]]; then
      echo "$name"
      return 0
    fi
  done
  
  return 1
}

# --- Parse frontmatter ---
# Extracts a value from YAML frontmatter
# Usage: parse_frontmatter "key" < file
parse_frontmatter_value() {
  local key="$1"
  local file="$2"
  
  # Extract content between first two --- lines, then find the key
  sed -n '/^---$/,/^---$/p' "$file" | \
    grep -E "^${key}:" | \
    sed -E "s/^${key}:[[:space:]]*//" | \
    head -1
}

# --- Extract template body ---
# Gets everything after the frontmatter
extract_body() {
  local file="$1"
  
  # Skip first --- line, then print from second --- line onwards (excluding it)
  awk '
    /^---$/ { count++; next }
    count >= 2 { print }
  ' "$file"
}

# --- Main ---

# Resolve spec file
if [[ -n "$SPEC_FILE" ]]; then
  if [[ ! -f "$SPEC_FILE" ]]; then
    echo -e "${RED}Error: Spec file not found: $SPEC_FILE${NC}" >&2
    exit 1
  fi
else
  SPEC_FILE=$(find_spec_file) || {
    echo -e "${RED}Error: No spec file found.${NC}" >&2
    echo -e "Looking for: .ralph.md, ralph.md, or agents.md in current directory" >&2
    echo -e "Or provide a spec file path: Ralph.sh /path/to/spec.md" >&2
    exit 1
  }
fi

# Parse frontmatter
GOAL=$(parse_frontmatter_value "goal" "$SPEC_FILE")
REPO=$(parse_frontmatter_value "repo" "$SPEC_FILE")
MODEL_FRONTMATTER=$(parse_frontmatter_value "model" "$SPEC_FILE")

# Validate required fields
if [[ -z "$GOAL" ]]; then
  echo -e "${RED}Error: Missing required 'goal:' in frontmatter of $SPEC_FILE${NC}" >&2
  exit 1
fi

# Default repo to current directory if not specified
if [[ -z "$REPO" ]]; then
  REPO="$(pwd)"
else
  # Expand ~ in repo path
  REPO="${REPO/#\~/$HOME}"
fi

# Verify repo exists
if [[ ! -d "$REPO" ]]; then
  echo -e "${RED}Error: Repo directory not found: $REPO${NC}" >&2
  exit 1
fi

# Select tool
TOOL=$(select_tool)

# Select model: CLI arg > env var > frontmatter
MODEL=""
if [[ -n "$MODEL_ARG" ]]; then
  MODEL="$MODEL_ARG"
elif [[ -n "$RALPH_MODEL" ]]; then
  MODEL="$RALPH_MODEL"
elif [[ -n "$MODEL_FRONTMATTER" ]]; then
  MODEL="$MODEL_FRONTMATTER"
fi

# Extract and process template
TEMPLATE=$(extract_body "$SPEC_FILE")

# Substitute {{GOAL}} placeholder
PROMPT="${TEMPLATE//\{\{GOAL\}\}/$GOAL}"

# Display startup info
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}  RALPH LOOP                    ${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "Spec:  ${YELLOW}$SPEC_FILE${NC}"
echo -e "Goal:  ${YELLOW}$GOAL${NC}"
echo -e "Repo:  ${YELLOW}$REPO${NC}"
echo -e "Tool:  ${YELLOW}$TOOL${NC}"
if [[ -n "$MODEL" ]]; then
  echo -e "Model: ${YELLOW}$MODEL${NC}"
fi
echo ""
echo "Press Ctrl+C at any time to stop the loop."
echo ""

LOOP_COUNT=0

# Session totals for token tracking
TOTAL_INPUT=0
TOTAL_OUTPUT=0
TOTAL_CACHE_READ=0
TOTAL_COST=0

# Create temp file for JSON output
TEMP_OUTPUT=$(mktemp)
trap "rm -f $TEMP_OUTPUT" EXIT

while true; do
  LOOP_COUNT=$((LOOP_COUNT + 1))
  echo -e "${GREEN}--- Loop #$LOOP_COUNT starting ---${NC}"
  echo ""

  echo -e "${YELLOW}Working... (this may take 1-2 minutes)${NC}"
  
  # Run the appropriate tool with JSON output, capturing to temp file
  cd "$REPO"
  if [[ "$TOOL" == "opencode" ]]; then
    if [[ -n "$MODEL" ]]; then
      opencode run --format json --model "$MODEL" "$PROMPT" > "$TEMP_OUTPUT" 2>&1
    else
      opencode run --format json "$PROMPT" > "$TEMP_OUTPUT" 2>&1
    fi
  else
    if [[ -n "$MODEL" ]]; then
      claude --print --dangerously-skip-permissions --output-format json --model "$MODEL" "$PROMPT" > "$TEMP_OUTPUT" 2>&1
    else
      claude --print --dangerously-skip-permissions --output-format json "$PROMPT" > "$TEMP_OUTPUT" 2>&1
    fi
  fi

  # Extract and display the response text
  if [[ "$TOOL" == "opencode" ]]; then
    # For opencode: extract the text content from the response
    jq -r '.response // .text // .content // .' "$TEMP_OUTPUT" 2>/dev/null || cat "$TEMP_OUTPUT"
  else
    # For claude: extract the result text from JSON
    jq -r '.result // .content // .' "$TEMP_OUTPUT" 2>/dev/null || cat "$TEMP_OUTPUT"
  fi

  # Parse token stats from JSON output
  LOOP_INPUT=0
  LOOP_OUTPUT=0
  LOOP_CACHE_READ=0
  LOOP_COST=0

  if [[ "$TOOL" == "opencode" ]]; then
    # opencode JSON format: tokens.input, tokens.output, tokens.cache.read, cost
    LOOP_INPUT=$(jq -r '.tokens.input // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
    LOOP_OUTPUT=$(jq -r '.tokens.output // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
    LOOP_CACHE_READ=$(jq -r '.tokens.cache.read // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
    LOOP_COST=$(jq -r '.cost // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
  else
    # claude JSON format: usage.input_tokens, usage.output_tokens, usage.cache_read_input_tokens, total_cost_usd
    LOOP_INPUT=$(jq -r '.usage.input_tokens // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
    LOOP_OUTPUT=$(jq -r '.usage.output_tokens // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
    LOOP_CACHE_READ=$(jq -r '.usage.cache_read_input_tokens // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
    LOOP_COST=$(jq -r '.total_cost_usd // 0' "$TEMP_OUTPUT" 2>/dev/null || echo 0)
  fi

  # Ensure we have numeric values (handle "null" or empty strings)
  [[ "$LOOP_INPUT" == "null" || -z "$LOOP_INPUT" ]] && LOOP_INPUT=0
  [[ "$LOOP_OUTPUT" == "null" || -z "$LOOP_OUTPUT" ]] && LOOP_OUTPUT=0
  [[ "$LOOP_CACHE_READ" == "null" || -z "$LOOP_CACHE_READ" ]] && LOOP_CACHE_READ=0
  [[ "$LOOP_COST" == "null" || -z "$LOOP_COST" ]] && LOOP_COST=0

  # Update session totals using awk for floating point math
  TOTAL_INPUT=$(awk "BEGIN {print $TOTAL_INPUT + $LOOP_INPUT}")
  TOTAL_OUTPUT=$(awk "BEGIN {print $TOTAL_OUTPUT + $LOOP_OUTPUT}")
  TOTAL_CACHE_READ=$(awk "BEGIN {print $TOTAL_CACHE_READ + $LOOP_CACHE_READ}")
  TOTAL_COST=$(awk "BEGIN {print $TOTAL_COST + $LOOP_COST}")

  echo ""
  echo -e "${GREEN}--- Loop #$LOOP_COUNT complete ---${NC}"
  echo ""

  # Display stats box with formatted numbers
  LOOP_IN_FMT=$(format_number "$LOOP_INPUT")
  LOOP_OUT_FMT=$(format_number "$LOOP_OUTPUT")
  LOOP_CACHE_FMT=$(format_number "$LOOP_CACHE_READ")
  LOOP_COST_FMT=$(awk "BEGIN {printf \"$%.2f\", $LOOP_COST}")
  
  SESS_IN_FMT=$(format_number "$TOTAL_INPUT")
  SESS_OUT_FMT=$(format_number "$TOTAL_OUTPUT")
  SESS_CACHE_FMT=$(format_number "$TOTAL_CACHE_READ")
  SESS_COST_FMT=$(awk "BEGIN {printf \"$%.2f\", $TOTAL_COST}")

  echo -e "${YELLOW}┌────────────────────────────────────────────────────────────────────┐${NC}"
  printf "${YELLOW}│${NC} %-9s ${YELLOW}│${NC} In: %-6s ${YELLOW}│${NC} Out: %-5s ${YELLOW}│${NC} Cache: %-5s ${YELLOW}│${NC} Cost: %-7s ${YELLOW}│${NC}\n" \
    "This Loop" "$LOOP_IN_FMT" "$LOOP_OUT_FMT" "$LOOP_CACHE_FMT" "$LOOP_COST_FMT"
  printf "${YELLOW}│${NC} %-9s ${YELLOW}│${NC} In: %-6s ${YELLOW}│${NC} Out: %-5s ${YELLOW}│${NC} Cache: %-5s ${YELLOW}│${NC} Cost: %-7s ${YELLOW}│${NC}\n" \
    "Session" "$SESS_IN_FMT" "$SESS_OUT_FMT" "$SESS_CACHE_FMT" "$SESS_COST_FMT"
  echo -e "${YELLOW}└────────────────────────────────────────────────────────────────────┘${NC}"
  echo ""

  echo -e "${YELLOW}Review the changes above.${NC}"
  echo -e "Options:"
  echo -e "  ${GREEN}Enter${NC}     - Continue to next loop"
  echo -e "  ${RED}Ctrl+C${NC}   - Stop the loop"
  echo ""
  read -p "Press Enter to continue..."
  echo ""
done
