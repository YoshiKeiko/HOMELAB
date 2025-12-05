#!/bin/bash

# Google Drive Download Script using rclone
# Downloads entire Google Drive to /Volumes/HomeLab-4TB/TRANSFER_FROM_GD

set -e

DEST_DIR="/Volumes/HomeLab-4TB/TRANSFER_FROM_GD"
REMOTE_NAME="gdrive"
LOG_FILE="${DEST_DIR}/download_log_$(date +%Y%m%d_%H%M%S).txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if destination drive is mounted
if [ ! -d "$DEST_DIR" ]; then
    echo_error "Destination directory $DEST_DIR does not exist!"
    echo_info "Please ensure the HomeLab-4TB drive is mounted."
    exit 1
fi

# Check if rclone is installed
if ! command -v rclone &> /dev/null; then
    echo_warn "rclone is not installed. Installing via Homebrew..."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo_error "Homebrew is not installed. Please install it first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    brew install rclone
    echo_info "rclone installed successfully!"
fi

# Check if remote is configured
if ! rclone listremotes | grep -q "^${REMOTE_NAME}:$"; then
    echo_warn "Google Drive remote '${REMOTE_NAME}' not configured."
    echo_info "Setting up Google Drive connection..."
    echo ""
    echo "=========================================="
    echo "  GOOGLE DRIVE AUTHORIZATION"
    echo "=========================================="
    echo ""
    echo "A browser window will open for you to sign in to Google."
    echo "Please authorize rclone to access your Google Drive."
    echo ""
    echo "Press Enter to continue..."
    read

    # Create the remote non-interactively, then authorize
    rclone config create "${REMOTE_NAME}" drive \
        scope=drive \
        --drive-acknowledge-abuse=true

    echo ""
    echo_info "Now authorizing with Google..."
    echo ""

    # Trigger the OAuth flow by trying to list the remote
    # This will open the browser for authorization
    if ! rclone lsd "${REMOTE_NAME}:" --max-depth 0 2>&1; then
        echo ""
        echo_error "Authorization may have failed. Let's try the interactive setup instead."
        echo ""
        echo "The interactive setup will now start."
        echo "Follow these steps:"
        echo "  1. Type 'n' for new remote"
        echo "  2. Name it: gdrive"
        echo "  3. Choose the number for 'Google Drive'"
        echo "  4. Press Enter to skip client_id and client_secret"
        echo "  5. Choose '1' for full access scope"
        echo "  6. Press Enter to skip service_account_file"
        echo "  7. Type 'n' for advanced config"
        echo "  8. Type 'y' for auto config (browser will open)"
        echo "  9. Type 'n' for team drive (unless you need it)"
        echo "  10. Type 'y' to confirm, then 'q' to quit"
        echo ""
        echo "Press Enter to start..."
        read

        # Remove the partially created remote and start fresh
        rclone config delete "${REMOTE_NAME}" 2>/dev/null || true
        rclone config
    fi

    # Verify configuration
    if ! rclone listremotes | grep -q "^${REMOTE_NAME}:$"; then
        echo_error "Remote '${REMOTE_NAME}' was not configured correctly."
        echo_info "Please run 'rclone config' manually and create a remote named '${REMOTE_NAME}'"
        exit 1
    fi

    echo_info "Google Drive remote configured successfully!"
fi

# Display drive info
echo ""
echo_info "Checking Google Drive connection..."
rclone about ${REMOTE_NAME}: 2>/dev/null || {
    echo_error "Failed to connect to Google Drive. Please check your configuration."
    exit 1
}

echo ""
echo "=========================================="
echo "  GOOGLE DRIVE DOWNLOAD"
echo "=========================================="
echo ""
echo "Source:      ${REMOTE_NAME}: (Google Drive root)"
echo "Destination: ${DEST_DIR}"
echo "Log file:    ${LOG_FILE}"
echo ""

# Get estimated size (this can take a while for large drives)
echo_info "Estimating total size (this may take a few minutes)..."
TOTAL_SIZE=$(rclone size ${REMOTE_NAME}: --json 2>/dev/null | grep -o '"bytes":[0-9]*' | cut -d: -f2)
if [ -n "$TOTAL_SIZE" ]; then
    HUMAN_SIZE=$(numfmt --to=iec-i --suffix=B $TOTAL_SIZE 2>/dev/null || echo "${TOTAL_SIZE} bytes")
    echo_info "Total size to download: ${HUMAN_SIZE}"
fi

echo ""
echo "Ready to start download. This will:"
echo "  - Download all files from Google Drive"
echo "  - Skip files that already exist (same size/date)"
echo "  - Convert Google Docs to Microsoft Office formats"
echo "  - Log progress to ${LOG_FILE}"
echo ""
read -p "Start download? (y/n): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo_info "Download cancelled."
    exit 0
fi

echo ""
echo_info "Starting download... (Press Ctrl+C to pause/cancel)"
echo_info "Progress will be logged to: ${LOG_FILE}"
echo ""

# Run rclone sync with:
# --progress: Show progress
# --transfers 4: 4 parallel transfers
# --checkers 8: 8 parallel checkers
# --drive-acknowledge-abuse: Download files flagged as abuse
# --drive-export-formats docx,xlsx,pptx: Convert Google Docs
# --log-file: Log to file
# --log-level INFO: Log level
# --stats 30s: Show stats every 30 seconds

rclone copy "${REMOTE_NAME}:" "${DEST_DIR}" \
    --progress \
    --transfers 4 \
    --checkers 8 \
    --drive-acknowledge-abuse \
    --drive-export-formats docx,xlsx,pptx,pdf \
    --log-file="${LOG_FILE}" \
    --log-level INFO \
    --stats 30s \
    --stats-one-line \
    2>&1 | tee -a "${LOG_FILE}"

RESULT=$?

echo ""
if [ $RESULT -eq 0 ]; then
    echo_info "=========================================="
    echo_info "  DOWNLOAD COMPLETE!"
    echo_info "=========================================="
    echo_info "Files downloaded to: ${DEST_DIR}"
    echo_info "Log file: ${LOG_FILE}"
else
    echo_error "Download finished with errors. Check log: ${LOG_FILE}"
fi

# Show disk usage
echo ""
echo_info "Disk usage summary:"
du -sh "${DEST_DIR}" 2>/dev/null || true

exit $RESULT
