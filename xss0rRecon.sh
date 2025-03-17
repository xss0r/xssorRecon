#!/bin/bash

# Function to Install prerequired files
# Check if python3-venv is installed
if ! dpkg -l | grep -q python3-venv; then
    echo "python3-venv not found. Installing..."
    sudo apt install -y python3-venv
else
    echo "python3-venv is already installed."
fi

# Create and activate virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Function to handle errors with manual installation solutions
handle_error_with_solution() {
    echo -e "${RED}Error occurred during the execution of $1. Exiting step but continuing with the next installation.${NC}"
    echo "Error during: $1" >> error.log
    echo -e "${YELLOW}Possible Solution for manual installation:${NC}"
    echo -e "${BOLD_WHITE}$2${NC}"
}

# Define colors
BOLD_WHITE='\033[1;97m'
BOLD_BLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'  # No Color

# Function to handle errors
handle_error() {
    echo -e "${RED}Error occurred during the execution of $1. Exiting.${NC}"
    echo "Error during: $1" >> error.log
    exit 1
}

# Function to show progress with emoji
show_progress() {
    echo -e "${BOLD_BLUE}Current process: $1...⌛️${NC}"
}

# Function to check if a command exists and is executable
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}$1 could not be found or is not installed correctly.${NC}"
        handle_error "$1 installation check"
    else
        echo -e "${BOLD_BLUE}$1 installed correctly.${NC}"
    fi
}

# Clear the terminal
clear

# Display banner
echo -e "${BOLD_BLUE}"
echo "               ___         ____                              _____ "
echo "__  _____ ___ / _ \ _ __  |  _ \ ___  ___ ___  _ __   __   _|___ / "
echo "\ \/ / __/ __| | | | '__| | |_) / _ \/ __/ _ \| '_ \  \ \ / / |_ \ "
echo " >  <\__ \__ \ |_| | |    |  _ <  __/ (_| (_) | | | |  \ V / ___) |"
echo "/_/\_\___/___/\___/|_|    |_| \_\___|\___\___/|_| |_|   \_/ |____/ "
echo "                           xss0r Recon v3"
echo -e "${NC}"

# Centered Contact Information
echo -e "${BOLD_BLUE}                      Website: store.xss0r.com${NC}"
echo -e "${BOLD_BLUE}                      Free BlindXSS Testing: xss0r.com${NC}"
echo -e "${BOLD_BLUE}                      X: x.com/xss0r${NC}"

# Function to display options
display_options() {
    echo -e "${BOLD_BLUE}Please select an option:${NC}"
    echo -e "${RED}1: Install all tools${NC}"
    echo -e "${RED}2: Enter a domain name of the target${NC}"
    echo -e "${YELLOW}3: Domain Enumeration and Filtering${NC}"
    echo -e "${YELLOW}4: URL Crawling and Filtering${NC}"
    echo -e "${YELLOW}5: In-depth URL Filtering${NC}"
    echo -e "${YELLOW}6: HiddenParamFinder${NC}"
    echo -e "${YELLOW}7: Preparing for XSS Detection and Query String URL Analysis${NC}"
    echo -e "${YELLOW}8: Launching xss0r Tool${NC}"
    echo -e "${YELLOW}9: Exit${NC}"
    echo -e "${YELLOW}10: Guide to Deploying xss0r on VPS Servers${NC}"
    echo -e "${YELLOW}11: Path-based XSS${NC}"
    echo -e "${YELLOW}12: Domains Search Inputs${NC}"
}


# Function to display Guide to Deploying xss0r on VPS Servers information with better formatting and crystal-like color
show_vps_info() {
    echo -e "${CYAN}To run xss0r continuously on bug bounty programs and keep it running in the background, a VPS server is highly recommended.${NC}"
    echo -e "${CYAN}I personally recommend Contabo, which I've been using for the past three years. It has performed reliably without any restrictions.${NC}"
    echo -e "${CYAN}Additionally, the pricing is very competitive.${NC}\n"
    
    echo -e "${CYAN}Here is the link to purchase the Contabo VPS 2 server Debian OS:${NC}"
    echo -e "${CYAN}Make sure to select under OS settings to be DEBIAN OS 12:${NC}"
    echo -e "${CYAN}https://contabo.com/en/vps/cloud-vps-2/?image=debian.329&qty=1&contract=1&storage-type=vps2-400-gb-sdd${NC}\n"
    echo -e "${CYAN}You can select any plan from Contabo Hosting https://contabo.com/en/vps/${NC}\n"
    
    echo -e "${CYAN}After completing the purchase, you can expect to receive your credentials via email within 15 minutes to 3 hours.${NC}\n"
    
    echo -e "${CYAN}Next, update your VPS and install tmux to allow xss0r to run in the background.${NC}\n"
    
    echo -e "${CYAN}Below are the essential tmux commands:${NC}\n"
    
    echo -e "${CYAN}#### Start a new tmux session:${NC}"
    echo -e "${CYAN}apt install tmux                          # Install tmux${NC}"
    echo -e "${CYAN}tmux new-session -s xss0r                 # Create a new tmux session${NC}"
    echo -e "${CYAN}tmux attach-session -t xss0r              # Reattach to an existing tmux session from another terminal tab${NC}"
    echo -e "${CYAN}tmux detach -s xss0r                      # Detach from the tmux session${NC}"
    echo -e "${CYAN}tmux kill-session -t xss0r                # Terminate the xss0r tmux session${NC}"
    echo -e "${CYAN}tmux kill-server                          # Terminate all tmux sessions${NC}"
    echo -e "${CYAN}tmux ls                                   # List all active tmux sessions${NC}\n"
    
echo -e "${CYAN}#### Install and Configure Cockpit https://YourVpsIP:9090${NC}"
echo -e "${CYAN}#### Cockpit it WEB GUI for SSH with many features like Navigator (File Manmager) for quick upload/download files:${NC}"
echo -e "${CYAN}sudo apt install cockpit cockpit-podman -y  # Install Cockpit and Podman support${NC}"
echo -e "${CYAN}sudo systemctl start cockpit               # Start Cockpit service${NC}"
echo -e "${CYAN}sudo systemctl enable cockpit              # Enable Cockpit to start on boot${NC}"
echo -e "${CYAN}sudo apt install ufw -y                    # Install UFW firewall${NC}"
echo -e "${CYAN}sudo ufw enable                            # Enable UFW firewall${NC}"
echo -e "${CYAN}sudo ufw allow 9090                        # Allow Cockpit access on port 9090${NC}"
echo -e "${CYAN}sudo ufw allow 80                          # Allow HTTP access${NC}"
echo -e "${CYAN}sudo ufw allow 22                          # Allow SSH access${NC}"
echo -e "${CYAN}sudo ufw allow 3389                        # Allow RDP access${NC}"
echo -e "${CYAN}sudo ufw reload                            # Reload UFW rules${NC}\n"
echo -e "${CYAN}sudo ufw allow 22/tcp                      # Allow ssh over tcp${NC}\n"
echo -e "${CYAN}sudo ufw allow ssh                         # Allow ssh
echo -e "${CYAN}Configure Cockpit to Allow                 # Unencrypted Access and Root Login:${NC}"
echo -e "${CYAN}sudo nano /etc/cockpit/cockpit.conf        # Add settings to cockpit.conf${NC}"
echo -e "${CYAN}[WebService]\nAllowUnencrypted = true\nLogin= root\n" # Configuration content for cockpit.conf
echo -e "${CYAN}sudo systemctl restart cockpit             # Restart Cockpit service to apply changes${NC}"
echo -e "${CYAN}sudo apt-get upgrade cockpit               # Upgrade Cockpit${NC}"
echo -e "${CYAN}sudo nano /etc/cockpit/disallowed-users    # Delete 'root' user from disallowed-users${NC}"
echo -e "${CYAN}sudo nano /etc/pam.d/cockpit               # Comment pam_listfile.so item=user sense=deny line${NC}"
echo -e "${CYAN}sudo mkdir -p /etc/cockpit/ws-certs.d      # Create directory for certificates${NC}"
echo -e "${CYAN}sudo rm /etc/cockpit/ws-certs.d/0-self-signed.cert # Remove self-signed cert${NC}"
echo -e "${CYAN}sudo systemctl restart cockpit             # Restart Cockpit service${NC}\n"

echo -e "${CYAN}#### Install Cockpit Navigator Plugin & ZIP archive:${NC}"
echo -e "${CYAN}sudo apt-get install rsync zip  # Install rsync zip${NC}"
echo -e "${CYAN}sudo apt-get install unzip  # Install unzip ${NC}"
echo -e "${CYAN}sudo apt-get install p7zip-full  # Install p7zip${NC}"
echo -e "${CYAN}wget https://github.com/45Drives/cockpit-navigator/releases/download/v0.5.10/cockpit-navigator_0.5.10-1focal_all.deb  # Download Cockpit Navigator${NC}"
echo -e "${CYAN}sudo dpkg -i cockpit-navigator_0.5.10-1focal_all.deb  # Install Cockpit Navigator${NC}"
echo -e "${CYAN}Navigate to https://YourVpsIP:9090/navigator  # Access Cockpit Navigator in your browser${NC}\n"

echo -e "${CYAN}#### Install Kali Linux and Desktop Environment:${NC}"
echo -e "${CYAN}sudo nano /etc/apt/sources.list             # Add Kali repository to sources.list${NC}"
echo -e "${CYAN}deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware\n"
echo -e "${CYAN}wget -q -O - https://archive.kali.org/archive-key.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg # Import Kali keyring${NC}"
echo -e "${CYAN}sudo apt update                             # Update package list${NC}"
echo -e "${CYAN}sudo apt upgrade                            # Upgrade packages${NC}"
echo -e "${CYAN}sudo apt full-upgrade                       # Full system upgrade${NC}"
echo -e "${CYAN}sudo apt dist-upgrade                       # Distribution upgrade${NC}"
echo -e "${CYAN}sudo apt -y install kali-linux-everything   # Install all Kali tools${NC}"
echo -e "${CYAN}sudo apt install kali-desktop-gnome         # Install Kali GNOME Desktop${NC}"
echo -e "${CYAN}sudo apt install kali-linux-default         # Install default Kali packages${NC}"
echo -e "${CYAN}sudo apt update --fix-missing               # Fix missing dependencies${NC}"
echo -e "${CYAN}sudo apt --fix-broken install               # Fix broken installations${NC}"
echo -e "${CYAN}sudo dpkg --configure -a                    # Reconfigure dpkg${NC}"
echo -e "${CYAN}sudo update-alternatives --config x-session-manager  # Configure session manager${NC}"
echo -e "${CYAN}sudo apt -y install kali-root-login         # Enable root login${NC}"
echo -e "${CYAN}sudo passwd                                 # Set root password${NC}"
echo -e "${CYAN}sudo apt autoremove                         # Remove unnecessary packages${NC}"
echo -e "${CYAN}sudo apt clean                              # Clean up package cache${NC}\n"
echo -e "${CYAN}sudo reboot                                 # Update changes to VPS server${NC}\n"


# Steps for installing xss0r on VPS
echo -e "${CYAN}#### Steps for installing xss0r on VPS:${NC}"

echo -e "${CYAN}1. Install Cockpit                         ${NC} # Install Cockpit for VPS management"
echo -e "${CYAN}2. Install Debian                          ${NC} # Install the Debian OS"
echo -e "${CYAN}3. nano /etc/apt/sources.list              ${NC} # Edit source list in Debian OS"
echo -e "${CYAN}4. deb http://asi-fs-d.contabo.net/debian bookworm main non-free-firmware  ${NC} # Change 'bookworm' to 'testing'"
echo -e "${CYAN}5. deb-src http://asi-fs-d.contabo.net/debian bookworm main non-free-firmware ${NC} # Change 'bookworm' to 'testing'"
echo -e "${CYAN}6. Update & Upgrade                        ${NC} # sudo apt update && sudo apt install libc6 -y && sudo apt install gnome -y"
echo -e "${CYAN}7. Install Kali OS                         ${NC} # Not needed any changes except updates & upgrades"
echo -e "${CYAN}8. Upload all files to your VPS            ${NC} # Upload xss0r + xss0rRecon files"
echo -e "${CYAN}9. chmod +x xss0r                          ${NC} # Add execute permission to the xss0r tool"
echo -e "${CYAN}10. Install required Chrome version from the eBook ${NC} # Install the required Chrome version as outlined in the eBook"
echo -e "${CYAN}11. Run xss0r and enter API License         ${NC} # Run xss0r tool and enter your API license"
echo -e "${CYAN}12. Run xss0rRecon and install all tools   ${NC} # Run xss0rRecon and install necessary tools"
echo -e "${CYAN}13. Ensure all files in the same folder    ${NC} # Make sure all files are inside the same folder"
echo -e "${CYAN}14. Run xss0r tool                         ${NC} # Launch and run xss0r tool"

}

# Initialize a variable for the domain name
domain_name=""
last_completed_option=1
skip_order_check_for_option_4=false
total_merged_urls=0

# Function to run step 1 (Install all tools)
install_tools() {
    # Find the current directory path
    CURRENT_DIR=$(pwd)

    echo -e "${BOLD_WHITE}You selected: Install all tools${NC}"

    show_progress "Installing dependencies"
    sudo apt-mark hold google-chrome-stable
    sudo apt install git
    sudo apt update && sudo apt install needrestart -y && sudo apt upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" && sudo apt dist-upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" && sudo dpkg --configure -a && sudo apt -f install -y && sudo needrestart -q -n    sudo apt update --fix-missing
    # Check if the OS is Ubuntu
if grep -qi "ubuntu" /etc/*release; then
    echo "Ubuntu detected! Running installation commands..."
    
    # Update and upgrade packages
    apt update && apt upgrade -y

    # Install required dependencies
    apt install software-properties-common -y

    # Add the deadsnakes PPA
    add-apt-repository ppa:deadsnakes/ppa -y

    # Update package list again
    apt update

    # Install Python 3.12
    apt install python3.12 -y

    # Verify installation
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
    sudo update-alternatives --config python3
    sudo ln -sf /usr/bin/python3 /usr/bin/python
    sudo apt install --reinstall python3-apt
    sudo apt install python3-distutils
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3
    sudo apt install --reinstall python3-pip
    python3.12 --version
else
    echo "This is not an Ubuntu system. Skipping installation."
fi
    sudo apt install python3.12-venv
    python3 -m venv .venv
    source .venv/bin/activate 
    sudo apt install -y python3-pip
    sudo apt upgrade python3
    sudo apt install pip
    sudo apt install pip3
    pip3 install requests urllib3
    sudo pip uninstall -y subprober subdominator dnsbruter --break-system-packages
    sudo apt install -y python3.12
    sudo apt install -y build-essential libssl-dev zlib1g-dev libncurses5-dev libnss3-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev make
    sudo apt install -y pkg-config
    sudo apt install -y libssl-dev libffi-dev
    sudo pip install colorama --break-system-packages
    sudo pip install aiodns --break-system-packages
    sudo pip install aiofiles --break-system-packages
    sudo pip install -U bs4 --break-system-packages
    sudo pip install -U lxml --break-system-packages
    sudo pip install --upgrade cython
    sudo pip install aiojarm --break-system-packages
    sudo pip install playwright --break-system-packages
    sudo pip install subprober --break-system-packages --no-deps anyio==4.6.2
    sudo pip install uvloop --break-system-packages
    sudo pip install -U bs4 --break-system-packages
    sudo pip install -U lxml --break-system-packages
    sudo apt --fix-broken install
    sudo apt install -y python3 python3-pip python3-venv python3-setuptools git wget curl
    sudo apt-get install -y rsync zip unzip p7zip-full golang-go terminator pipx tmux

    # Remove conflicting package if it exists
    sudo apt remove -y python3-structlog

    # Set full permissions for the xss0rRecon script
    sudo chmod 755 xss0rRecon.sh

    # Step 1: Install Python3 virtual environment and structlog in venv
    show_progress "Installing python3-venv and setting up virtual environment"

    # Upgrade pip 
    sudo pip install --upgrade pip 
    sudo pip install tldextract --break-system-packages
    sudo pip install structlog requests uvloop setuptools pipx

    # Install necessary Python packages within the virtual environment
    sudo pip install structlog requests uvloop setuptools

    # Install pipx within the virtual environment
    sudo pip install pipx
    sudo pip install asynciolimiter
    sudo pip install aiojarm
    sudo pip install playwright
    

    # Install Dnsbruter, Subdominator, SubProber within the virtual environment
    sudo pip install git+https://github.com/RevoltSecurities/Dnsbruter
    sudo pip install git+https://github.com/RevoltSecurities/Subdominator --break-system-packages
    sudo pip install git+https://github.com/RevoltSecurities/Subdominator --no-deps httpx==0.25.2
    pipx install git+https://github.com/RevoltSecurities/Subdominator
    sudo pip install git+https://github.com/RevoltSecurities/Subprober --break-system-packages
    sudo pip install git+https://github.com/RevoltSecurities/Subprober --break-system-packages
    sudo pip install subprober --break-system-packages --no-deps anyio==4.6.2
    sudo pip install git+https://github.com/RevoltSecurities/Subprober.git --no-deps aiojarm
    sudo pip install git+https://github.com/RevoltSecurities/Subprober.git --no-deps playwright
    pipx install git+https://github.com/RevoltSecurities/Subprober --break-system-packages

    # Install Uro, Arjun, and other required Python packages
    sudo pip install uro
    sudo pip install arjun
    sudo pip install alive_progress ratelimit

    # Add Go bin to PATH
    export PATH=$PATH:$(go env GOPATH)/bin

    # Dynamically set the PATH based on the current user
    if [ "$EUID" -eq 0 ]; then
        echo "You are the root user."
        export PATH="$PATH:/root/.local/bin"
    else
        # Detect the username of the home user
        USERNAME=$(whoami)
        echo "You are the home user: $USERNAME"
        export PATH="$PATH:/home/$USERNAME/.local/bin"
    fi

    # Sleep for 3 seconds
    sleep 3

    # Print the updated PATH for confirmation
    echo "Updated PATH: $PATH"

    # Display installed tools
    echo -e "${BOLD_BLUE}All tools have been successfully installed within the virtual environment.${NC}"


    # Sleep for 3 seconds
    sleep 3

    # Print the updated PATH for confirmation
    echo "Updated PATH: $PATH"

    # Step 2: Install the latest version of pip
    show_progress "Installing/Upgrading pip"
    sudo apt update && sudo apt install python3-pip -y
    sudo pip3 install --upgrade pip --root-user-action=ignore
    sudo pip install tldextract --break-system-packages
    echo "managed by system package manager" | sudo tee /usr/lib/python3.12/EXTERNALLY-MANAGED
    sleep 3

   # Step 3: Install Go
show_progress "Installing Go 1.22.5"

# Step 1: Remove any existing Go installations
echo "Removing existing Go installations and cache..."
sudo apt remove --purge golang -y
sudo apt autoremove --purge -y
sudo apt clean
sudo rm -rf /usr/local/go /usr/bin/go /usr/local/bin/go /root/go ~/go ~/.cache/go-build ~/.config/go ~/.config/gopls

# Remove Go from PATH if previously added
export PATH=$(echo "$PATH" | sed -e 's|:/usr/local/go/bin||' -e 's|:$HOME/go/bin||')

# Confirm removal
echo "Existing Go installations removed."

# Step 2: Download and Install Go
echo "Downloading Go 1.22.5..."
sudo apt install golang -y
wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz

echo "Installing Go 1.22.5..."
sudo tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz

# Clean up the downloaded tarball
sudo rm -r go1.22.5.linux-amd64.tar.gz

# Step 3: Set up environment variables
echo "Configuring Go environment..."
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile.d/go.sh
echo 'export GOPATH=$HOME/go' | sudo tee -a /etc/profile.d/go.sh
echo 'export PATH=$PATH:$GOPATH/bin' | sudo tee -a /etc/profile.d/go.sh

# Apply environment changes immediately
source /etc/profile.d/go.sh

# Make Go available globally for all users
sudo ln -sf /usr/local/go/bin/go /usr/bin/go
sudo ln -sf /usr/local/go/bin/gofmt /usr/bin/gofmt

# Step 4: Verify the installation
echo "Verifying Go installation..."
if go version; then
    echo -e "Go 1.22.5 has been successfully installed and configured."
else
    echo -e "Failed to install Go. Please check for errors and retry."
    exit 1
fi

# Step 5: Install dependencies for GVM (optional, for managing multiple Go versions)
echo "Installing dependencies for GVM..."
sudo apt install -y curl git mercurial make binutils bison gcc build-essential

# Step 6: (Optional) Install and Configure GVM for Version Management
echo "Installing GVM..."
if [ ! -d "$HOME/.gvm" ]; then
    bash < <(curl -sSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    source ~/.gvm/scripts/gvm
    gvm install go1.22.5
    gvm use go1.22.5 --default
else
    echo "GVM is already installed."
fi

# Final Step: Clean Go cache
go clean
echo "Go installation complete!"

# Check if Go is installed and its version
echo "Checking Go version..."
if command -v go &> /dev/null; then
    GO_VERSION=$(go version)
    if [[ $GO_VERSION == go\ version\ go* ]]; then
        echo "Go is installed: $GO_VERSION"
    else
        echo "Go command exists, but the version could not be determined."
    fi
else
    echo "Go is not installed on this system."
fi
# Confirm successful installation
echo -e "${BOLD_BLUE}Go has been successfully installed and configured.${NC}"

# Sleep to allow changes to take effect
sleep 3

    # Install Python 3.12
    sudo apt install python3.12 -y

    # Install pip for Python 3.12
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3.12 get-pip.py

    # Install pipx and ensure it's in the PATH
    pip install pipx==1.7.1 --break-system-packages --root-user-action=ignore
    pipx ensurepath

    # Verify Python, pip, and pipx installations
    python3 --version
    pip --version
    pipx --version
    sudo pip install structlog requests
    sudo pip install --upgrade pip
    sudo pip install --upgrade pipx
    sudo apt install pipx -y
    pipx ensurepath
    subprober -up
    cp /root/.local/bin/subprober /usr/local/bin

    # Step 4: Install Dnsbruter (Skip if already installed)
if ! command -v dnsbruter &> /dev/null; then
    show_progress "Installing Dnsbruter"

    # Try installing directly with pip
    python3 -m venv .venv
    source .venv/bin/activate 
    sudo pip install --no-deps --force-reinstall --break-system-packages git+https://github.com/RevoltSecurities/Dnsbruter
    pipx install git+https://github.com/RevoltSecurities/Dnsbruter.git


    # Check if the installation was successful
        python3 -m venv .venv
        source .venv/bin/activate
        python3 -m pip install --upgrade dnsbruter
        python3 -m pip install --break-system-packages --upgrade dnsbruter
        dnsbruter -up
    if ! pip show dnsbruter &> /dev/null; then
        echo "Direct installation failed. Attempting installation via cloning the repository."

        # Clone the repository and install from source
        git clone https://github.com/RevoltSecurities/Dnsbruter.git
        cd Dnsbruter || exit

        # Install from the local cloned repository
        sudo pip install . --break-system-packages --root-user-action=ignore
        python3 -m venv .venv
        source .venv/bin/activate
        python3 -m pip install --upgrade dnsbruter
        python3 -m pip install --break-system-packages --upgrade dnsbruter
        dnsbruter -up

        # Clean up by removing the cloned directory after installation
        cd ..
        sudo rm -rf Dnsbruter
    else
        echo "Dnsbruter installed successfully using pip."
    fi

    # Final check to ensure dnsbruter is accessible globally
    if command -v dnsbruter &> /dev/null; then
        echo "Dnsbruter is successfully installed and globally available."
        dnsbruter -up && dnsbruter -h
    else
        echo "Dnsbruter installation failed. Please check the installation steps."
    fi

    show_progress "Dnsbruter installation complete."
    sleep 3
    python3 -m venv .venv
    source .venv/bin/activate
    sudo pip3 install dnsbruter "aiodns>=3.2.0" "aiofiles>=24.1.0" "alive_progress>=3.2.0" "art>=6.1" "asynciolimiter>=1.1.0.post3" "colorama>=0.4.4" "requests>=2.32.3" "setuptools>=75.2.0" "uvloop>=0.21.0"

else
    show_progress "Dnsbruter is already installed. Skipping installation."
fi

    # Step 5: Install Subdominator (Skip if the folder already exists)
if [ ! -d "Subdominator" ]; then
    show_progress "Installing Subdominator"

    # Try installing directly with pip
    python3 -m venv .venv
    source .venv/bin/activate
    sudo pip uninstall uvloop -y && sudo pip3 uninstall uvloop -y && sudo pipx uninstall uvloop || true && sudo pip install uvloop --break-system-packages
    sudo pip install --upgrade aiodns pycares --break-system-packages
    sudo pip install git+https://github.com/RevoltSecurities/Subdominator --break-system-packages --root-user-action=ignore
    sudo pip install git+https://github.com/RevoltSecurities/Subdominator --no-deps httpx==0.25.2

    # Check if the installation was successful
    if ! pip show subdominator &> /dev/null; then
        echo "Direct installation failed. Attempting installation via cloning the repository."

        # Clone the repository and install from source
        git clone https://github.com/RevoltSecurities/Subdominator.git
        cd Subdominator || exit

        # Install from local cloned repository
        sudo pip install . --break-system-packages --root-user-action=ignore
        subdominator -up

        # Clean up by removing the cloned directory after installation
        cd ..
        sudo rm -rf Subdominator
        python3 -m venv .venv
        source .venv/bin/activate
        sudo pipx inject subdominator "aiofiles>=23.2.1" "aiohttp>=3.9.4" "appdirs>=1.4.4" "httpx>=0.27.2" "art>=6.1" "beautifulsoup4>=4.11.1" "colorama>=0.4.6" "fake_useragent>=1.5.0" "PyYAML>=6.0.1" "requests>=2.31.0" "rich>=13.7.1" "urllib3>=1.26.18" "tldextract>=5.1.2"

    else
        echo "Subdominator installed successfully using pip."
    fi

    show_progress "Subdominator installation complete."
    sleep 3
else
    show_progress "Subdominator is already installed. Skipping installation."
fi

    # Step 6: Install SubProber (Skip if the folder already exists)
if [ ! -d "SubProber" ]; then
    show_progress "Installing SubProber"

    # Try installing directly with pip
    python3 -m venv .venv
    source .venv/bin/activate 
    sudo pip install git+https://github.com/RevoltSecurities/Subprober --break-system-packages --root-user-action=ignore
    pipx install git+https://github.com/RevoltSecurities/Subprober.git

    # Check if the installation was successful
    if ! pip show subprober &> /dev/null; then
        echo "Direct installation failed. Attempting installation via cloning the repository."

        # Clone the repository and install from source
        git clone https://github.com/RevoltSecurities/Subprober.git
        cd Subprober || exit

        # Install from local cloned repository
        sudo pip install . --break-system-packages --root-user-action=ignore
        pip install subprober aiojarm
        subprober -up

        # Clean up by removing the cloned directory after installation
        cd ..
        sudo rm -rf Subprober
        cp /root/.local/bin/subprober /usr/local/bin
    else
        echo "SubProber installed successfully using pip."
    fi

    show_progress "SubProber installation complete."
    python3 -m venv .venv
    source .venv/bin/activate
    sudo pip3 install --break-system-packages "subprober" "aiodns>=3.2.0" "aiofiles>=24.1.0" "aiojarm>=0.2.2" "alive_progress>=3.2.0" "appdirs>=1.4.4" "art>=6.4" "asynciolimiter>=1.1.1" "beautifulsoup4>=4.12.3" "colorama>=0.4.6" "cryptography>=44.0.0" "fake_useragent>=1.5.1" "httpx>=0.28.1" "mmh3>=5.0.1" "playwright>=1.49.1" "requests>=2.32.3" "rich>=13.9.4" "setuptools>=75.2.0" "simhash>=2.1.2" "urllib3>=1.26.18" "uvloop>=0.21.0" "websockets>=14.1" "bs4>=0.0.2" "lxml>=5.3.0"
    for t in dnsbruter subdominator subprober; do [ -f "$HOME/.local/bin/$t" ] && [ "$HOME/.local/bin/$t" != "/usr/local/bin/$t" ] && sudo cp "$HOME/.local/bin/$t" /usr/local/bin/; done 
    pwd && ORIGIN="$(pwd)" && cd "$ORIGIN/.venv/bin" && sudo cp * /usr/local/bin && cd "$ORIGIN"
    pip install subprober
    sleep 3
else
    show_progress "SubProber is already installed. Skipping installation."
fi

    # Step 7: Install GoSpider
python3 -m venv .venv
source .venv/bin/activate 
show_progress "Installing GoSpider"


# Attempt to install GoSpider using 'go install'
echo -e "${BOLD_WHITE}Attempting to install GoSpider using 'go install'...${NC}"
if go install github.com/jaeles-project/gospider@latest; then
    echo -e "${BOLD_BLUE}GoSpider installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/gospider" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install GoSpider via 'go install'. Attempting to install from source...${NC}"

    # Clone the GoSpider repository
    git clone https://github.com/jaeles-project/gospider.git
    cd gospider

    # Build the GoSpider binary
    if go build; then
        chmod +x gospider
        sudo mv gospider /usr/local/bin/
        echo -e "${BOLD_BLUE}GoSpider installed successfully from source.${NC}"
        cd ..
        sudo rm -rf gospider
    else
        echo -e "${RED}Failed to build GoSpider from source.${NC}"
        cd ..
        rm -rf gospider
        exit 1
    fi
fi

# Ensure /usr/local/bin is in PATH
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="$PATH:/usr/local/bin"
fi

# Verify that GoSpider is accessible
if ! command -v gospider &> /dev/null; then
    echo -e "${RED}GoSpider is not in your PATH. Please ensure /usr/local/bin is in your PATH.${NC}"
    exit 1
fi

sleep 3

    # Step 8: Install Hakrawler
python3 -m venv .venv
source .venv/bin/activate 
show_progress "Installing Hakrawler"


# Attempt to install Hakrawler using 'go install'
echo -e "${BOLD_WHITE}Attempting to install Hakrawler using 'go install'...${NC}"
if go install github.com/hakluke/hakrawler@latest; then
    echo -e "${BOLD_BLUE}Hakrawler installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/hakrawler" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install Hakrawler via 'go install'. Attempting to install from source...${NC}"

    # Clone the Hakrawler repository
    git clone https://github.com/hakluke/hakrawler.git
    cd hakrawler

    # Build the Hakrawler binary
    if go build; then
        chmod +x hakrawler
        sudo mv hakrawler /usr/local/bin/
        echo -e "${BOLD_BLUE}Hakrawler installed successfully from source.${NC}"
        cd ..
        sudo rm -rf hakrawler
    else
        echo -e "${RED}Failed to build Hakrawler from source.${NC}"
        cd ..
        rm -rf hakrawler
        exit 1
    fi
fi

# Ensure /usr/local/bin is in PATH
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="$PATH:/usr/local/bin"
fi

# Verify that Hakrawler is accessible
if ! command -v hakrawler &> /dev/null; then
    echo -e "${RED}Hakrawler is not in your PATH. Please ensure /usr/local/bin is in your PATH.${NC}"
    exit 1
fi

sleep 3


# Step 8.1: Install URLFinder
python3 -m venv .venv
source .venv/bin/activate 
show_progress "Installing URLFinder"


# Attempt to install URLFinder using 'go install'
echo -e "${BOLD_WHITE}Attempting to install URLFinder using 'go install'...${NC}"
if go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest; then
    echo -e "${BOLD_BLUE}URLFinder installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/urlfinder" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install URLFinder via 'go install'. Attempting to install manually...${NC}"

    # Clone the URLFinder repository
    git clone https://github.com/projectdiscovery/urlfinder.git
    cd urlfinder/cmd/urlfinder

    # Build the URLFinder binary
    if go build; then
        chmod +x urlfinder
        sudo cp urlfinder /usr/local/bin/
        echo -e "${BOLD_BLUE}URLFinder installed successfully from source.${NC}"
        cd ../../../
        sudo rm -rf urlfinder
    else
        echo -e "${RED}Failed to build URLFinder from source.${NC}"
        cd ../../../
        rm -rf urlfinder
        exit 1
    fi
fi

# Ensure /usr/local/bin is in PATH
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="$PATH:/usr/local/bin"
fi

# Verify that URLFinder is accessible
if ! command -v urlfinder &> /dev/null; then
    echo -e "${RED}URLFinder is not in your PATH. Please ensure /usr/local/bin is in your PATH.${NC}"
    exit 1
fi

sleep 3



    # Step 9: Install Katana
python3 -m venv .venv
source .venv/bin/activate 
show_progress "Installing Katana"


# Attempt to install Katana using 'go install'
echo -e "${BOLD_WHITE}Attempting to install Katana using 'go install'...${NC}"
if go install github.com/projectdiscovery/katana/cmd/katana@latest; then
    echo -e "${BOLD_BLUE}Katana installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/katana" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install Katana via 'go install'. Attempting to install from source...${NC}"

    # Clone the Katana repository
    git clone https://github.com/projectdiscovery/katana.git
    cd katana/cmd/katana

    # Build the Katana binary
    if go build; then
        chmod +x katana
        sudo mv katana /usr/local/bin/
        echo -e "${BOLD_BLUE}Katana installed successfully from source.${NC}"
        cd ../../..
        sudo rm -rf katana
    else
        echo -e "${RED}Failed to build Katana from source.${NC}"
        cd ../../..
        rm -rf katana
        exit 1
    fi
fi

# Ensure /usr/local/bin is in PATH
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="$PATH:/usr/local/bin"
fi

# Verify that Katana is accessible
if ! command -v katana &> /dev/null; then
    echo -e "${RED}Katana is not in your PATH. Please ensure /usr/local/bin is in your PATH.${NC}"
    exit 1
fi

sleep 3


    #  Install Gau
python3 -m venv .venv
source .venv/bin/activate 
show_progress "Installing Gau"


# Attempt to install Gau using 'go install'
echo -e "${BOLD_WHITE}Attempting to install Gau using 'go install'...${NC}"
if go install github.com/lc/gau/v2/cmd/gau@latest; then
    echo -e "${BOLD_BLUE}Gau installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/gau" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install Gau via 'go install'. Attempting to install from source...${NC}"

    # Clone the Gau repository
    git clone https://github.com/lc/gau
    cd gau/cmd/gau

    # Build the Gau binary
    if go build; then
        chmod +x gau
        sudo mv gau /usr/local/bin/
        echo -e "${BOLD_BLUE}Gau installed successfully from source.${NC}"
        cd ../../..
        sudo rm -rf gau
    else
        echo -e "${RED}Failed to build Gau from source.${NC}"
        cd ../../..
        rm -rf gau
        exit 1
    fi
fi

# Attempt to install Katana using 'go install'
python3 -m venv .venv
source .venv/bin/activate 
echo -e "${BOLD_WHITE}Attempting to install Katana using 'go install'...${NC}"
if go install github.com/projectdiscovery/katana/cmd/katana@latest; then
    echo -e "${BOLD_BLUE}Katana installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/katana" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install Katana via 'go install'. Attempting to install from source...${NC}"

    # Clone the Katana repository
    git clone https://github.com/projectdiscovery/katana.git
    cd katana/cmd/katana

    # Build the Katana binary
    if go build; then
        chmod +x katana
        sudo mv katana /usr/local/bin/
        echo -e "${BOLD_BLUE}Katana installed successfully from source.${NC}"
        cd ../../..
        sudo rm -rf katana
    else
        echo -e "${RED}Failed to build Katana from source.${NC}"
        cd ../../..
        rm -rf katana
        exit 1
    fi
fi

# Attempt to install Waybackurls using 'go install'
python3 -m venv .venv
source .venv/bin/activate 
echo -e "${BOLD_WHITE}Attempting to install Waybackurls using 'go install'...${NC}"
if go install github.com/tomnomnom/waybackurls@latest; then
    echo -e "${BOLD_BLUE}Waybackurls installed successfully via 'go install'.${NC}"

    # Copy the binary to /usr/local/bin for system-wide access
    sudo cp "$(go env GOPATH)/bin/waybackurls" /usr/local/bin/
else
    echo -e "${YELLOW}Failed to install Waybackurls via 'go install'. Attempting to install from source...${NC}"

    # Clone the Waybackurls repository
    git clone https://github.com/tomnomnom/waybackurls.git
    cd waybackurls

    # Build the Waybackurls binary
    if go build; then
        chmod +x waybackurls
        sudo mv waybackurls /usr/local/bin/
        echo -e "${BOLD_BLUE}Waybackurls installed successfully from source.${NC}"
        cd ..
        sudo rm -rf waybackurls
    else
        echo -e "${RED}Failed to build Waybackurls from source.${NC}"
        cd ..
        rm -rf waybackurls
        deactivate
        rm -rf .venv
        python3 -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip setuptools wheel
        pip install git+https://github.com/RevoltSecurities/Dnsbruter
        pip install git+https://github.com/RevoltSecurities/Subprober
        pip install aiodns aiofiles alive_progress art asynciolimiter colorama requests uvloop
        exit 1
    fi
fi


# Ensure /usr/local/bin is in PATH
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="$PATH:/usr/local/bin"
fi

# Confirm installation and configuration
if command -v gau &> /dev/null; then
    echo -e "${BOLD_BLUE}Gau is successfully installed and globally available.${NC}"
else
    echo -e "${RED}Gau installation failed. Please check the installation steps.${NC}"
    exit 1
fi

sleep 3

    # Step 12: Install Uro
    show_progress "Installing Uro"
    pip install uro --break-system-packages --root-user-action=ignore
    uro -h  # Ensure Uro runs with sudo
    sleep 3

    # Step 13: Install Arjun
    show_progress "Installing Arjun"
    sudo apt install -y arjun
    sudo pip3 install arjun --break-system-packages --root-user-action=ignore
    sudo pip install alive_progress --break-system-packages --root-user-action=ignore
    sudo pip install ratelimit --break-system-packages --root-user-action=ignore
    sudo mv /usr/lib/python3.12/EXTERNALLY-MANAGED /usr/lib/python3.12/EXTERNALLY-MANAGED.bak
    sleep 3

    # Step 14: Install Tmux
    show_progress "Installing Tmux"
    sudo apt install -y tmux
    sudo apt --fix-broken install
    sudo apt update
    dnsbruter -up
    sleep 3

    # Set specific permissions for installed tools
    sudo chmod 755 /usr/local/bin/waybackurls
    sudo chmod 755 /usr/local/bin/katana
    sudo chmod 755 /usr/local/bin/gau
    sudo chmod 755 /usr/local/bin/uro
    sudo chmod 755 /usr/local/bin/gospider
    sudo chmod 755 /usr/local/bin/hakrawler
    sudo chmod 755 /usr/local/bin/urlfinder

    # Find paths for subprober, subdominator, and dnsbruter
    SUBPROBER_PATH=$(which subprober)
    SUBDOMINATOR_PATH=$(which subdominator)
    DNSBRUTER_PATH=$(which dnsbruter)

    # Check if the tools are found and copy them to the .venv/bin directory
    if [ -n "$SUBPROBER_PATH" ]; then
        sudo cp "$SUBPROBER_PATH" .venv/bin/
    else
        echo "subprober not found!"
    fi

    if [ -n "$SUBDOMINATOR_PATH" ]; then
        sudo cp "$SUBDOMINATOR_PATH" .venv/bin/
    else
        echo "subdominator not found!"
    fi

    if [ -n "$DNSBRUTER_PATH" ]; then
        sudo cp "$DNSBRUTER_PATH" .venv/bin/
    else
        echo "dnsbruter not found!"
    fi

    # Display installed tools
    echo -e "${BOLD_BLUE}All tools have been successfully installed.${NC}"

# Checking each tool with -h for verification
echo -e "${BOLD_WHITE}Checking installed tools...${NC}"

echo -e "${BOLD_WHITE}1. Dnsbruter:${NC}"
dnsbruter -h > /dev/null 2>&1 && echo "Dnsbruter is installed" || echo "Dnsbruter is not installed correctly"

echo -e "${BOLD_WHITE}2. Subdominator:${NC}"
subdominator -h > /dev/null 2>&1 && echo "Subdominator is installed" || echo "Subdominator is not installed correctly"

echo -e "${BOLD_WHITE}3. SubProber:${NC}"
subprober -h > /dev/null 2>&1 && echo "SubProber is installed" || echo "SubProber is not installed correctly"

echo -e "${BOLD_WHITE}4. GoSpider:${NC}"
gospider -h > /dev/null 2>&1 && echo "GoSpider is installed" || echo "GoSpider is not installed correctly"

echo -e "${BOLD_WHITE}5. Hakrawler:${NC}"
hakrawler --help > /dev/null 2>&1 && echo "Hakrawler is installed" || echo "Hakrawler is not installed correctly"

echo -e "${BOLD_WHITE}6. URLFinder:${NC}"
urlfinder --help > /dev/null 2>&1 && echo "URLFinder is installed" || echo "URLFinder is not installed correctly"

echo -e "${BOLD_WHITE}6. Katana:${NC}"
katana -h > /dev/null 2>&1 && echo "Katana is installed" || echo "Katana is not installed correctly"

echo -e "${BOLD_WHITE}7. Waybackurls:${NC}"
waybackurls -h > /dev/null 2>&1 && echo "Waybackurls is installed" || echo "Waybackurls is not installed correctly"

echo -e "${BOLD_WHITE}8. Gau:${NC}"
gau -h > /dev/null 2>&1 && echo "Gau is installed" || echo "Gau is not installed correctly"

echo -e "${BOLD_WHITE}9. Uro:${NC}"
uro -h > /dev/null 2>&1 && echo "Uro is installed" || echo "Uro is not installed correctly"

echo -e "${BOLD_WHITE}10. Arjun:${NC}"
arjun -h > /dev/null 2>&1 && echo "Arjun is installed" || echo "Arjun is not installed correctly"

echo -e "${BOLD_WHITE}11. URLFinder:${NC}"
urlfinder -h > /dev/null 2>&1 && echo "URLFinder is installed" || echo "URLFinder is not installed correctly"

echo -e "${BOLD_WHITE}11. Tmux:${NC}"
echo "Tmux is installed (skipping check)"

# Cyan and White message with tool links for manual installation
echo -e "\n${BOLD_CYAN}If you encounter any issues or are unable to run any of the tools,${NC}"
echo -e "${BOLD_WHITE}please refer to the following links for manual installation:${NC}"
echo -e "${BOLD_WHITE}Waybackurls:${NC} https://github.com/tomnomnom/waybackurls"
echo -e "${BOLD_WHITE}Gau:${NC} https://github.com/lc/gau"
echo -e "${BOLD_WHITE}Uro:${NC} https://github.com/s0md3v/uro"
echo -e "${BOLD_WHITE}Katana:${NC} https://github.com/projectdiscovery/katana"
echo -e "${BOLD_WHITE}Hakrawler:${NC} https://github.com/hakluke/hakrawler"
echo -e "${BOLD_WHITE}GoSpider:${NC} https://github.com/jaeles-project/gospider"
echo -e "${BOLD_WHITE}Arjun:${NC} https://github.com/s0md3v/Arjun"
echo -e "${BOLD_WHITE}Dnsbruter:${NC} https://github.com/RevoltSecurities/Dnsbruter"
echo -e "${BOLD_WHITE}SubProber:${NC} https://github.com/RevoltSecurities/SubProber"
echo -e "${BOLD_WHITE}Subdominator:${NC} https://github.com/RevoltSecurities/Subdominator"
echo -e "${BOLD_WHITE}UrlFinder:${NC} https://github.com/projectdiscovery/urlfinder"

# Adding extra space for separation
echo -e "\n\n"

# Bold blue message surrounded by a rectangle of lines with extra spacing
echo -e "${BOLD_BLUE}=============================================================================================${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}|  NOTE: To use this tool, you must have the xss0r tool, which is an XSS detection           |${NC}"
echo -e "${BOLD_BLUE}|  and exploitation tool for all types of XSS attacks, in the same directory.                |${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}|  Alongside the xss0r tool, you'll also need two wordlists and a 2 Pythons reflection       |${NC}"
echo -e "${BOLD_BLUE}|  detection tools. All of these can be found in any of the XSS plans available on the site. |${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}|  You can get them by visiting: https://store.xss0r.com/ and purchasing any plan that       |${NC}"
echo -e "${BOLD_BLUE}|  fits your needs.                                                                          |${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}|  If you already have a plan, simply copy the xss0r tool, the wordlists, and the            |${NC}"
echo -e "${BOLD_BLUE}|  reflection detection tool into the same folder where your xss0rRecon tool is located.     |${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}|  Alternatively, if you don't have a plan or the tools, you can use the PRO plan for free   |${NC}"
echo -e "${BOLD_BLUE}|  for 5 days each month from the 10th to the 15th.                                          |${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}|  The release of the key is posted on the homepage banner at store.xss0r.com, but this      |${NC}"
echo -e "${BOLD_BLUE}|  option is only available for those who have not yet tested the tool.                      |${NC}"
echo -e "${BOLD_BLUE}|                                                                                            |${NC}"
echo -e "${BOLD_BLUE}=============================================================================================${NC}"

echo -e "\n\n"

}


# Setup and activate Python virtual environment
setup_and_activate_venv() {
    echo -e "${BOLD_WHITE}Setting up and activating Python virtual environment...${NC}"
    # Create a virtual environment in the .venv directory if it doesn't already exist
    if [ ! -d ".venv" ]; then
        echo -e "${BOLD_BLUE}Creating Python virtual environment in .venv...${NC}"
        python3 -m venv .venv
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error: Failed to create virtual environment.${NC}"
            exit 1
        fi
    fi

    # Activate the virtual environment
    echo -e "${BOLD_BLUE}Activating virtual environment...${NC}"
    source .venv/bin/activate
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to activate virtual environment.${NC}"
        exit 1
    fi

    echo -e "${BOLD_GREEN}Virtual environment activated successfully!${NC}"
}

# Call the virtual environment setup before running step 3
setup_and_activate_venv

# Function to run step 3 (Domain Enumeration and Filtering)
run_step_3() {
    # Check if the user wants to skip the order check for step 3
    source "$(pwd)/.venv/bin/activate"
    if [ "$skip_order_check_for_option_4" = true ]; then
        echo -e "${BOLD_BLUE}Skipping step 3 order check and directly using the domain list provided...${NC}"
        if [ -f "${domain_name}-domains.txt" ]; then
            echo -e "${BOLD_WHITE}Using your provided list of domains from ${domain_name}-domains.txt${NC}"
            proceed_with_existing_file "${domain_name}-domains.txt"
        else
            echo -e "${RED}Error: File ${domain_name}-domains.txt not found. Please ensure the file is in the current directory.${NC}"
            exit 1
        fi
        return
    fi

    echo -e "${BOLD_WHITE}You selected: Domain Enumeration and Filtering for $domain_name${NC}"
    echo -e "${BOLD_WHITE}Do you want to use your own list of domains or xss0rRecon to find it for you? Enter Y for your list or N for xss0rRecon list - domain list must be in format ${domain_name}-domains.txt: ${NC}"
    read user_choice

    # Convert user input to uppercase
    user_choice=$(echo "$user_choice" | tr '[:lower:]' '[:upper:]')

    if [[ "$user_choice" == "Y" ]]; then
        if [ -f "${domain_name}-domains.txt" ]; then
            echo -e "${BOLD_WHITE}Using your provided list of domains from ${domain_name}-domains.txt${NC}"
            # Skip directly to the Y/N prompt for continuing the scan
            read -p "$(echo -e "${BOLD_WHITE}Your domain file has been created. Would you like to continue scanning your target domain, including all its subdomains? If so, please enter 'Y'. If you prefer to modify the domain file first, so you can delete these and add your domains, enter 'N', and you can manually proceed with step 4 afterwards. Do you want to continue scanning with all subdomains (Y/N)?: ${NC}")" continue_scan
            if [[ "$continue_scan" =~ ^[Yy]$ ]]; then
                # Step xx: Filtering ALIVE DOMAINS
                show_progress "Filtering ALIVE DOMAINS"
                python3 -m venv .venv
                source .venv/bin/activate 
                subprober -f "${domain_name}-domains.txt" -sc -ar -o "${domain_name}-alive" -nc -c 20 || handle_error "subprober"
                sleep 5
                rm -r "${domain_name}-domains.txt"
                mv "${domain_name}-alive" "${domain_name}-domains.txt"

                # Step xx: Filtering valid URLS
                show_progress "Filtering valid DOMAINS"
                grep -oP 'http[^\s]*' "${domain_name}-domains.txt" > ${domain_name}-valid || handle_error "grep valid urls"
                sleep 5
                rm -r "${domain_name}-domains.txt"
                mv ${domain_name}-valid "${domain_name}-domains.txt"

                # Step xx: Remove duplicates
                show_progress "Removing duplicate domains"
                initial_count=$(wc -l < "${domain_name}-domains.txt")
                awk '{if (!seen[$0]++) print}' "${domain_name}-domains.txt" >> "subs-filtered.txt" || handle_error "Removing duplicates from ${domain_name}-domains.txt"
                final_count_subs=$(wc -l < "subs-filtered.txt")
                removed_count=$((initial_count - final_count_subs))
                rm -r "${domain_name}-domains.txt"
                mv "subs-filtered.txt" "${domain_name}-domains.txt"
                echo -e "${RED}Removed $removed_count duplicate domains.${NC}"

                # Step xx: Normalize to `http://` and remove `www.`
                awk '{sub(/^https?:\/\//, "http://", $0); sub(/^http:\/\/www\./, "http://", $0); domain = $0; if (!seen[domain]++) print domain}' \
                "${domain_name}-domains.txt" > "final-${domain_name}-domains.txt" || handle_error "Final filtering"
                rm -r "${domain_name}-domains.txt"
                mv "final-${domain_name}-domains.txt" "${domain_name}-domains.txt"
                sleep 5

                skip_order_check_for_option_4=true
                echo -e "${BOLD_BLUE}Automatically continuing with step 4: URL Crawling and Filtering...${NC}"
                run_step_4  # Automatically continue to step 4
            else
                echo -e "${BOLD_WHITE}Please edit your file ${domain_name}-domains.txt and remove any unwanted subdomains before continuing.${NC}"
                skip_order_check_for_option_4=true
            fi
            return
        else
            echo -e "${RED}Error: File ${domain_name}-domains.txt not found. Please ensure the file is in the current directory.${NC}"
            exit 1
        fi
    elif [[ "$user_choice" == "N" ]]; then
        # Step 1: Passive FUZZ domains with wordlist
        show_progress "Passive FUZZ domains with wordlist"
        python3 -m venv .venv
        source .venv/bin/activate 
        dnsbruter -d "$domain_name" -w subs-dnsbruter-small.txt -c 150 -wt 80 -rt 500 -wd -ws wild.txt -o output-dnsbruter.txt || handle_error "dnsbruter"
        sleep 5

        # Step 2: Active brute crawling domains
        show_progress "Active brute crawling domains"
        python3 -m venv .venv
        source .venv/bin/activate 
        subdominator -d "$domain_name" -o output-subdominator.txt || handle_error "subdominator"
        sleep 5

        # Step 3: Checking if output-dnsbruter.txt was created
        if [ ! -f "output-dnsbruter.txt" ]; then
            echo "Error: output-dnsbruter.txt not found. The dnsbruter command may have failed."
            if [ -f "output-subdominator.txt" ]; then
                echo "Moving output-subdominator.txt to ${domain_name}-domains.txt"
                mv output-subdominator.txt "${domain_name}-domains.txt"
            else
                echo "Error: output-subdominator.txt not found. The subdominator command may have also failed."
                exit 1
            fi
        else
            if [ -f "output-subdominator.txt" ]; then
                show_progress "Merging passive and active results into one file"
                cat output-dnsbruter.txt output-subdominator.txt > "${domain_name}-domains.txt" || handle_error "Merging domains"
            else
                echo "Error: output-subdominator.txt not found. Proceeding with output-dnsbruter.txt only."
                mv output-dnsbruter.txt "${domain_name}-domains.txt"
            fi
        fi
        # Step 4: Removing old temporary files
        show_progress "Removing old temporary files"
        [ -f "output-dnsbruter.txt" ] && rm output-dnsbruter.txt || handle_error "Removing output-dnsbruter.txt"
        [ -f "output-subdominator.txt" ] && rm output-subdominator.txt || handle_error "Removing output-subdominator.txt"
        sleep 3
    else
        echo -e "${RED}Invalid choice entered. Please run the script again and choose Y or N.${NC}"
        exit 1
    fi

    # Step 6: Removing duplicate domains
    show_progress "Removing duplicate domains"
    remove_duplicates "${domain_name}-domains.txt"
}

proceed_with_existing_file() {
    file_path=$1
    echo -e "${RED}Proceeding with file: $file_path${NC}"
    remove_duplicates "$file_path"
}

remove_duplicates() {
    file_path=$1
    initial_count=$(wc -l < "$file_path")
    awk '{sub(/^https?:\/\//, "", $0); sub(/^www\./, "", $0); if (!seen[$0]++) print}' "$file_path" > "unique-$file_path"
    final_count=$(wc -l < "unique-$file_path")
    removed_count=$((initial_count - final_count))
    echo -e "${RED}Removed $removed_count duplicate domains. Total subdomains after processing: $final_count${NC}"
    sleep 3

    # Step 6.1: Removing old domain list
    show_progress "Removing old domain list"
    rm -r "${domain_name}-domains.txt" || handle_error "Removing old domain list"
    sleep 3

  # Step 7: Filtering ALIVE domain names
show_progress "Filtering ALIVE domain names"
subprober -f "unique-${domain_name}-domains.txt" -sc -ar -o "subprober-${domain_name}-domains.txt" -nc -c 20 || handle_error "subprober"
sleep 5


# Step 2y1: Filtering valid domain names
show_progress "Filtering valid domain names"
grep -oP 'http[^\s]*' "subprober-${domain_name}-domains.txt" > output-domains.txt || handle_error "grep valid domains"
sleep 3

# Step 2y2: Replacing with valid domains
sudo mv output-domains.txt subs-subs.txt
echo "Replaced 'old' with valid domain names."
sleep 3


# Step 8: Renaming final output
show_progress "Renaming final output to new file"
mv subs-subs.txt "${domain_name}-domains.txt" || handle_error "Renaming output file"
sleep 3

    # Step 9: Final filtering of unique domain names
show_progress "Last step filtering domains"

# Normalize to `http://` and remove `www.`
awk '{sub(/^https?:\/\//, "http://", $0); sub(/^http:\/\/www\./, "http://", $0); domain = $0; if (!seen[domain]++) print domain}' \
"${domain_name}-domains.txt" > "final-${domain_name}-domains.txt" || handle_error "Final filtering"
sleep 5

# Step 10: Renaming final file to new file
show_progress "Renaming final file to new file"

# Deduplication to remove duplicates, ensuring `www.` is not included
awk '{sub(/^http:\/\/www\./, "http://", $0); print}' "final-${domain_name}-domains.txt" | \
awk '!seen[$0]++' > "${domain_name}-domains.txt" || handle_error "Removing duplicates and renaming output file"
# Delete the intermediate file
rm -r "final-${domain_name}-domains.txt" || handle_error "Deleting intermediate file"
sleep 3

# Display the completion message in red
echo -e "${BOLD_RED}Enumeration and filtering process completed successfully. Final output saved as ${domain_name}-domains.txt.${NC}"


# Step 10.1: Deleting all unwanted files
show_progress "Deleting all unwanted files"
sudo rm -r "unique-${domain_name}-domains.txt" || echo "Some files could not be deleted. Please check permissions."
sleep 3


    # New message for the user with Y/N option
read -p "$(echo -e "${BOLD_WHITE}Your domain file has been created. Would you like to continue scanning your target domain, including all its subdomains? If so, please enter 'Y'. If you prefer to modify the domain file first, so you can delete these and add your domains, enter 'N', and you can manually proceed with step 4 afterwards. Do you want to continue scanning with all subdomains (Y/N)?: ${NC}")" continue_scan
if [[ "$continue_scan" =~ ^[Yy]$ ]]; then
    skip_order_check_for_option_4=true
    echo -e "${BOLD_BLUE}Automatically continuing with step 4: URL Crawling and Filtering...${NC}"
    run_step_4  # Automatically continue to step 4
else
    echo -e "${BOLD_WHITE}Please edit your file ${domain_name}-domains.txt and remove any unwanted subdomains before continuing.${NC}"
    skip_order_check_for_option_4=true
fi
}


# Function to run step 4 (URL Crawling and Filtering)
run_step_4() {
    echo -e "${BOLD_WHITE}You selected: URL Crawling and Filtering for $domain_name${NC}"

    # Ask user if they want to use their own crawled links file
    echo -e "${BOLD_WHITE}Do you want to use your own crawled links file? (Y/N)${NC}"
    read -r use_own_links_file

    if [[ "$use_own_links_file" =~ ^[Yy]$ ]]; then
        echo -e "${BOLD_GREEN}Skipping default crawling steps. Proceeding with your own links file...${NC}"
        echo -e "${BOLD_GREEN}Please save your list of URLS in format "${domain_name}-links-final.txt"${NC}"

        # Ensure the user's file is in the correct format
        if [[ ! -f "${domain_name}-links-final.txt" ]]; then
            echo -e "${BOLD_RED}Error: File ${domain_name}-links-final.txt not found!${NC}"
            exit 1
        fi

        # Create new folder 'urls' and assign permissions
        show_progress "Creating 'urls' directory and setting permissions"
        sudo mkdir -p urls
        sudo chmod 777 urls

        # Copy the user's file to the 'urls' folder
        show_progress "Copying ${domain_name}-links-final.txt to 'urls' directory"
        sudo cp "${domain_name}-links-final.txt" urls/

        # Display professional message about the URLs
        echo -e "${BOLD_WHITE}All identified URLs have been successfully saved in the newly created 'urls' directory.${NC}"
        echo -e "${CYAN}These URLs represent potential targets that were not filtered out during the previous steps.${NC}"
        echo -e "${CYAN}You can use the file 'urls/${domain_name}-links-final.txt' for further vulnerability testing with tools like Nuclei or any other inspection frameworks to identify additional vulnerabilities.${NC}"
        echo -e "${CYAN}We are now continuing with our main purpose of XSS filtration and vulnerability identification.${NC}"

        # Display the number of URLs in the final merged file
        total_merged_urls=$(wc -l < "${domain_name}-links-final.txt")
        echo -e "${BOLD_WHITE}Total URLs merged: ${RED}${total_merged_urls}${NC}"
        sleep 3

        # Automatically start step 5 after completing step 4
        run_step_5
    fi

    echo -e "${BOLD_WHITE}You selected: URL Crawling and Filtering for $domain_name${NC}"

    # Step 1: Crawling with GoSpider
    show_progress "Crawling links with GoSpider"
    gospider -S "${domain_name}-domains.txt" -c 10 -d 5 | tee -a "${domain_name}-gospider.txt" || handle_error "GoSpider crawl"
    sleep 3

    # Step 2: Crawling with Hakrawler
    show_progress "Crawling links with Hakrawler"
    cat "${domain_name}-domains.txt" | hakrawler -d 3 | tee -a "${domain_name}-hakrawler.txt" || handle_error "Hakrawler crawl"
    sleep 3

    # Step 2.1: Crawling with URLFinder
    show_progress "Crawling links with URLFinder"
    urlfinder -all -d "${domain_name}-domains.txt" -o "${domain_name}-urlfinder.txt" || handle_error "URLFinder crawl"
    sleep 3


    # Step 3: Crawling with Katana
    show_progress "Crawling links with Katana"
    cat "${domain_name}-domains.txt" | katana -jc | tee -a "${domain_name}-katana.txt" || handle_error "Katana crawl"
    sleep 3

    # Step 4: Crawling with Waybackurls
    show_progress "Crawling links with Waybackurls"
    cat "${domain_name}-domains.txt" | waybackurls | tee -a "${domain_name}-waybackurls.txt" || handle_error "Waybackurls crawl"
    sleep 3

    # Step 5: Crawling with Gau
show_progress "Crawling links with Gau"
rm -r /root/.gau.toml
rm -r /home/$(whoami)/.gau.toml
# Perform crawling with Gau and save results
cat "${domain_name}-domains.txt" | gau | tee -a "${domain_name}-gau.txt" || handle_error "Gau crawl"

sleep 3

echo -e "${BOLD_BLUE}Crawling and filtering URLs completed successfully. Output files created for each tool.${NC}"
    
    # Step 6: Filter invalid links on Gospider and Hakrawler
    show_progress "Filtering invalid links on Gospider & Hakrawler & UrlFinder"
    grep -oP 'http[^\s]*' "${domain_name}-gospider.txt" > "${domain_name}-gospider1.txt"
    grep -oP 'http[^\s]*' "${domain_name}-hakrawler.txt" > "${domain_name}-hakrawler1.txt"
    grep -oP 'http[^\s]*' "${domain_name}-urlfinder.txt" > "${domain_name}-urlfinder1.txt"
    sleep 3

    # Step 7: Remove old Gospider & Hakrawler & UrlFinder files
    show_progress "Removing old Gospider & Hakrawler & UrlFinder files"
    rm -r "${domain_name}-gospider.txt" "${domain_name}-hakrawler.txt" "${domain_name}-urlfinder.txt"
    sleep 3

    # Step 8: Filter similar URLs with URO tool
    show_progress "Filtering similar URLs with URO tool"
    uro -i "${domain_name}-gospider1.txt" -o urogospider.txt &
    uro_pid_gospider=$!

    uro -i "${domain_name}-hakrawler1.txt" -o urohakrawler.txt &
    uro_pid_hakrawler=$!

    uro -i "${domain_name}-urlfinder1.txt" -o urourlfinder.txt &
    uro_pid_urlfinder=$!

    uro -i "${domain_name}-katana.txt" -o urokatana.txt &
    uro_pid_katana=$!

    uro -i "${domain_name}-waybackurls.txt" -o urowaybackurls.txt &
    uro_pid_waybackurls=$!

    uro -i "${domain_name}-gau.txt" -o urogau.txt &
    uro_pid_gau=$!

    # Monitor the processes
    while kill -0 $uro_pid_gospider 2> /dev/null || kill -0 $uro_pid_hakrawler 2> /dev/null || \
          kill -0 $uro_pid_katana 2> /dev/null || kill -0 $uro_pid_waybackurls 2> /dev/null || \
          kill -0 $uro_pid_urlfinder 2> /dev/null || kill -0 $uro_pid_urlfinder 2> /dev/null || \
          kill -0 $uro_pid_gau 2> /dev/null; do
        echo -e "${BOLD_BLUE}URO tool is still running...⌛️${NC}"
        sleep 30  # Check every 30 seconds
    done

echo -e "${BOLD_BLUE}URO processing completed. Files created successfully.${NC}"
sleep 3

    # Step 9: Remove all previous files
show_progress "Removing all previous files"
sudo rm -r "${domain_name}-gospider1.txt" "${domain_name}-hakrawler1.txt" "${domain_name}-katana.txt" "${domain_name}-waybackurls.txt" "${domain_name}-gau.txt" "${domain_name}-urlfinder1.txt"
sleep 3

# Step 10: Merge all URO files into one final file
show_progress "Merging all URO files into one final file"
cat urogospider.txt urohakrawler.txt urokatana.txt urowaybackurls.txt urogau.txt urourlfinder.txt > "${domain_name}-links-final.txt"
    
# Create new folder 'urls' and assign permissions
show_progress "Creating 'urls' directory and setting permissions"
sudo mkdir -p urls
sudo chmod 777 urls

# Copy the final file to the 'urls' folder
show_progress "Copying ${domain_name}-links-final.txt to 'urls' directory"
sudo cp "${domain_name}-links-final.txt" urls/

# Display professional message about the URLs
echo -e "${BOLD_WHITE}All identified URLs have been successfully saved in the newly created 'urls' directory.${NC}"
echo -e "${CYAN}These URLs represent potential targets that were not filtered out during the previous steps.${NC}"
echo -e "${CYAN}You can use the file 'urls/${domain_name}-links-final.txt' for further vulnerability testing with tools like Nuclei or any other inspection frameworks to identify additional vulnerabilities.${NC}"
echo -e "${CYAN}We are now continuing with our main purpose of XSS filtration and vulnerability identification.${NC}"

# Display the number of URLs in the final merged file
total_merged_urls=$(wc -l < "${domain_name}-links-final.txt")
echo -e "${BOLD_WHITE}Total URLs merged: ${RED}${total_merged_urls}${NC}"
sleep 3

# Step 11: Remove all 5 previous files
show_progress "Removing all 6 previous files"
sudo rm -r urokatana.txt urohakrawler.txt urowaybackurls.txt urogau.txt urogospider.txt urourlfinder.txt
sleep 3

# Automatically start step 5 after completing step 4
run_step_5
}

# Function to run step 5 (In-depth URL Filtering)
run_step_5() {
    echo -e "${BOLD_WHITE}You selected: Filtering extensions from the URLs for $domain_name${NC}"

    # Step 14: Filtering extensions from the URLs
    show_progress "Filtering extensions from the URLs"
    cat ${domain_name}-links-final.txt | grep -E -v '\.css($|\s|\?|&|#|/|\.)|\.js($|\s|\?|&|#|/|\.)|\.jpg($|\s|\?|&|#|/|\.)|\.JPG($|\s|\?|&|#|/|\.)|\.PNG($|\s|\?|&|#|/|\.)|\.GIF($|\s|\?|&|#|/|\.)|\.avi($|\s|\?|&|#|/|\.)|\.dll($|\s|\?|&|#|/|\.)|\.pl($|\s|\?|&|#|/|\.)|\.webm($|\s|\?|&|#|/|\.)|\.c($|\s|\?|&|#|/|\.)|\.py($|\s|\?|&|#|/|\.)|\.bat($|\s|\?|&|#|/|\.)|\.tar($|\s|\?|&|#|/|\.)|\.swp($|\s|\?|&|#|/|\.)|\.tmp($|\s|\?|&|#|/|\.)|\.sh($|\s|\?|&|#|/|\.)|\.deb($|\s|\?|&|#|/|\.)|\.exe($|\s|\?|&|#|/|\.)|\.zip($|\s|\?|&|#|/|\.)|\.mpeg($|\s|\?|&|#|/|\.)|\.mpg($|\s|\?|&|#|/|\.)|\.flv($|\s|\?|&|#|/|\.)|\.wmv($|\s|\?|&|#|/|\.)|\.wma($|\s|\?|&|#|/|\.)|\.aac($|\s|\?|&|#|/|\.)|\.m4a($|\s|\?|&|#|/|\.)|\.ogg($|\s|\?|&|#|/|\.)|\.mp4($|\s|\?|&|#|/|\.)|\.mp3($|\s|\?|&|#|/|\.)|\.bat($|\s|\?|&|#|/|\.)|\.dat($|\s|\?|&|#|/|\.)|\.cfg($|\s|\?|&|#|/|\.)|\.cfm($|\s|\?|&|#|/|\.)|\.bin($|\s|\?|&|#|/|\.)|\.jpeg($|\s|\?|&|#|/|\.)|\.JPEG($|\s|\?|&|#|/|\.)|\.ps.gz($|\s|\?|&|#|/|\.)|\.gz($|\s|\?|&|#|/|\.)|\.gif($|\s|\?|&|#|/|\.)|\.tif($|\s|\?|&|#|/|\.)|\.tiff($|\s|\?|&|#|/|\.)|\.csv($|\s|\?|&|#|/|\.)|\.png($|\s|\?|&|#|/|\.)|\.ttf($|\s|\?|&|#|/|\.)|\.ppt($|\s|\?|&|#|/|\.)|\.pptx($|\s|\?|&|#|/|\.)|\.ppsx($|\s|\?|&|#|/|\.)|\.doc($|\s|\?|&|#|/|\.)|\.woff($|\s|\?|&|#|/|\.)|\.xlsx($|\s|\?|&|#|/|\.)|\.xls($|\s|\?|&|#|/|\.)|\.mpp($|\s|\?|&|#|/|\.)|\.mdb($|\s|\?|&|#|/|\.)|\.json($|\s|\?|&|#|/|\.)|\.woff2($|\s|\?|&|#|/|\.)|\.icon($|\s|\?|&|#|/|\.)|\.pdf($|\s|\?|&|#|/|\.)|\.docx($|\s|\?|&|#|/|\.)|\.svg($|\s|\?|&|#|/|\.)|\.txt($|\s|\?|&|#|/|\.)|\.jar($|\s|\?|&|#|/|\.)|\.0($|\s|\?|&|#|/|\.)|\.1($|\s|\?|&|#|/|\.)|\.2($|\s|\?|&|#|/|\.)|\.3($|\s|\?|&|#|/|\.)|\.4($|\s|\?|&|#|/|\.)|\.m4r($|\s|\?|&|#|/|\.)|\.kml($|\s|\?|&|#|/|\.)|\.pro($|\s|\?|&|#|/|\.)|\.yao($|\s|\?|&|#|/|\.)|\.gcn3($|\s|\?|&|#|/|\.)|\.PDF($|\s|\?|&|#|/|\.)|\.egy($|\s|\?|&|#|/|\.)|\.par($|\s|\?|&|#|/|\.)|\.lin($|\s|\?|&|#|/|\.)|\.yht($|\s|\?|&|#|/|\.)' > filtered-extensions-links.txt
    sleep 5

    # Step 15: Renaming filtered extensions file
    show_progress "Renaming filtered extensions file"
    mv filtered-extensions-links.txt "${domain_name}-links-clean.txt"
    sleep 3

    # Step 16: Filtering unwanted domains from the URLs
    show_progress "Filtering unwanted domains from the URLs"
    grep -E "^(https?://)?([a-zA-Z0-9.-]+\.)?${domain_name}" "${domain_name}-links-clean.txt" > "${domain_name}-links-clean1.txt"
    sleep 3

    # Step 17: Removing old filtered file
    show_progress "Removing old filtered file"
    rm -r ${domain_name}-links-clean.txt ${domain_name}-links-final.txt
    sleep 3

    # Step 18: Renaming new filtered file
    show_progress "Renaming new filtered file"
    mv ${domain_name}-links-clean1.txt ${domain_name}-links-clean.txt
    sleep 3

    # Step 19: Running URO tool again to filter duplicate and similar URLs
    show_progress "Running URO tool again to filter duplicate and similar URLs"
    uro -i "${domain_name}-links-clean.txt" -o "${domain_name}-uro.txt" &
    uro_pid_clean=$!

    # Monitor the URO process
    while kill -0 $uro_pid_clean 2> /dev/null; do
        echo -e "${BOLD_BLUE}URO tool is still running for clean URLs...⌛️${NC}"
        sleep 30  # Check every 30 seconds
    done

    echo -e "${BOLD_BLUE}URO processing completed. Files created successfully.${NC}"
    sleep 3

    # Display the number of URLs in the URO output file
    echo -e "${BOLD_WHITE}Total URLs in final output: ${RED}$(wc -l < "${domain_name}-uro.txt")${NC}"
    sleep 3

    # Step 20: Removing old file
    show_progress "Removing old file"
    rm -r "${domain_name}-links-clean.txt"
    sleep 3

    # Step 21: Removing 99% similar parameters with bash command
    show_progress "Removing 99% similar parameters with bash command"
    filtered_output="filtered_output.txt"
    if [[ ! -f "${domain_name}-uro.txt" ]]; then 
        echo "File not found! Please check the path and try again."
        exit 1
    fi
    awk -F'[?&]' '{gsub(/:80/, "", $1); base_url=$1; params=""; for (i=2; i<=NF; i++) {split($i, kv, "="); if (kv[1] != "id") {params = params kv[1]; if (i < NF) {params = params "&";}}} full_url=base_url"?"params; if (!seen[full_url]++) {print $0 > "'"$filtered_output"'";}}' "${domain_name}-uro.txt"
    sleep 5

    # Display the number of URLs in the filtered output file
    echo -e "${BOLD_WHITE}Total filtered URLs: ${RED}$(wc -l < "$filtered_output")${NC}"
    sleep 3

    # Step 22: Removing old file
    show_progress "Removing old file"
    rm -r "${domain_name}-uro.txt"
    sleep 3

    # Step 23: Rename to new file
    show_progress "Rename to new file"
    mv filtered_output.txt "${domain_name}-links.txt"
    sleep 3

    # Step 24: Filtering ALIVE URLS
    show_progress "Filtering ALIVE URLS"
    python3 -m venv .venv
    source .venv/bin/activate 
    subprober -f "${domain_name}-links.txt" -sc -ar -o "${domain_name}-links-alive.txt" -nc -mc 200,201,202,204,301,302,304,307,308,403,500,504,401,407 -c 20 || handle_error "subprober"
    sleep 5

    # Step 25: Removing old file
    show_progress "Removing old file"
    rm -r ${domain_name}-links.txt
    sleep 3

    # Step 26: Filtering valid URLS
    show_progress "Filtering valid URLS"
    grep -oP 'http[^\s]*' "${domain_name}-links-alive.txt" > ${domain_name}-links-valid.txt || handle_error "grep valid urls"
    sleep 5

    # Step 27: Removing intermediate file and renaming final output
    show_progress "Final cleanup and renaming"
    rm -r ${domain_name}-links-alive.txt
    mv ${domain_name}-links-valid.txt ${domain_name}-links.txt
    sleep 3

    echo -e "${BOLD_BLUE}Filtering process completed successfully. Final output saved as ${domain_name}-links.txt.${NC}"

    # Automatically start step 6 after completing step 5
    run_step_6
}

# Function to run step 6 (HiddenParamFinder)
run_step_6() {
    echo -e "${BOLD_WHITE}You selected: HiddenParamFinder for $domain_name${NC}"

# Step 1: Preparing URLs with clean extensions
show_progress "Preparing URLs with clean extensions, created 2 files: arjun-urls.txt and output-php-links.txt"

# Extract all URLs with specific extensions into arjun-urls.txt and output-php-links.txt
cat "${domain_name}-links.txt" | grep -E "\.php($|\s|\?|&|#|/|\.)|\.asp($|\s|\?|&|#|/|\.)|\.aspx($|\s|\?|&|#|/|\.)|\.cfm($|\s|\?|&|#|/|\.)|\.jsp($|\s|\?|&|#|/|\.)" | \
awk '{print > "arjun-urls.txt"; print > "output-php-links.txt"}'
sleep 3

# Step 2: Clean parameters from URLs in arjun-urls.txt
show_progress "Filtering and cleaning arjun-urls.txt to remove parameters and duplicates"

# Clean parameters from URLs and save the cleaned version back to arjun-urls.txt
awk -F'?' '{print $1}' arjun-urls.txt | awk '!seen[$0]++' > temp_arjun_urls.txt

# Replace arjun-urls.txt with the cleaned file
mv temp_arjun_urls.txt arjun-urls.txt

show_progress "Completed cleaning arjun-urls.txt. All URLs are now clean, unique, and saved."


    # Check if Arjun generated any files
    if [ ! -s arjun-urls.txt ] && [ ! -s output-php-links.txt ]; then
        echo -e "${RED}Arjun did not find any new links or did not create any files.${NC}"
        echo -e "${BOLD_BLUE}Renaming ${domain_name}-links.txt to urls-ready.txt and continuing...${NC}"
        mv "${domain_name}-links.txt" urls-ready.txt || handle_error "Renaming ${domain_name}-links.txt"
        sleep 3
        run_step_7  # Automatically proceed to step 7
        return
    fi

    echo -e "${BOLD_BLUE}URLs prepared successfully and files created.${NC}"
    echo -e "${BOLD_BLUE}arjun-urls.txt and output-php-links.txt have been created.${NC}"

    # Step 2: Running Arjun on clean URLs if arjun-urls.txt is present
if [ -s arjun-urls.txt ]; then
    show_progress "Running Arjun on clean URLs"
    arjun -i arjun-urls.txt -oT arjun_output.txt -t 10 -w parametri.txt || handle_error "Arjun command"

    # Merge files and process .php links
if [ -f arjun-urls.txt ] || [ -f output-php-links.txt ] || [ -f arjun_output.txt ]; then
    # Merge and extract only the base .php URLs, then remove duplicates
    cat arjun-urls.txt output-php-links.txt arjun_output.txt 2>/dev/null | awk -F'?' '/\.php/ {print $1}' | sort -u > arjun-final.txt

    echo -e "${BOLD_BLUE}arjun-final.txt created successfully with merged and deduplicated links.${NC}"
else
    echo -e "${YELLOW}No input files for merging. Skipping merge step.${NC}"
fi

sleep 5

        # Count the number of new links discovered by Arjun
        if [ -f arjun_output.txt ]; then
            new_links_count=$(wc -l < arjun_output.txt)
            echo -e "${BOLD_BLUE}Arjun has completed running on the clean URLs.${NC}"
            echo -e "${BOLD_RED}Arjun discovered ${new_links_count} new links.${NC}"
            echo -e "${CYAN}The new links discovered by Arjun are:${NC}"
            cat arjun_output.txt
        else
            echo -e "${YELLOW}No output file was created by Arjun.${NC}"
        fi
    else
        echo -e "${RED}No input file (arjun-urls.txt) found for Arjun.${NC}"
    fi

    # Continue with other steps or clean up
    show_progress "Cleaning up temporary files"
    if [[ -f arjun-urls.txt || -f arjun_output.txt || -f output-php-links.txt ]]; then
        [[ -f arjun-urls.txt ]] && rm -r arjun-urls.txt
        [[ -f output-php-links.txt ]] && rm -r output-php-links.txt
        sleep 3
    else
        echo -e "${RED}No Arjun files to remove.${NC}"
    fi

    echo -e "${BOLD_BLUE}Files merged and cleanup completed. Final output saved as arjun-final.txt.${NC}"

# Step 5: Creating a new file for XSS testing
if [ -f arjun-final.txt ]; then
    show_progress "Creating a new file for XSS testing"

    # Ensure arjun-final.txt is added to urls-ready.txt
    cat "${domain_name}-links.txt" arjun-final.txt > urls-ready1337.txt || handle_error "Creating XSS testing file"
    rm -r "${domain_name}-links.txt"
    mv urls-ready1337.txt "${domain_name}-links.txt"
    sleep 3
    mv "${domain_name}-links.txt" urls-ready.txt || handle_error "Renaming ${domain_name}-links.txt"
fi

# Automatically start step 7 after completing step 6
run_step_7
}

# Function to run step 7 (Getting ready for XSS & URLs with query strings)
run_step_7() {
    echo -e "${BOLD_WHITE}You selected: Preparing for XSS Detection and Query String URL Analysis for $domain_name${NC}"

    # Step 1: Filtering URLs with query strings
    show_progress "Filtering URLs with query strings"
    grep '=' urls-ready.txt > "$domain_name-query.txt"
    sleep 5
    echo -e "${BOLD_BLUE}Filtering completed. Query URLs saved as ${domain_name}-query.txt.${NC}"

    # Step 2: Renaming the remaining URLs
    show_progress "Renaming remaining URLs"
    mv urls-ready.txt "$domain_name-ALL-links.txt"
    sleep 3
    echo -e "${BOLD_BLUE}All-links URLs saved as ${domain_name}-ALL-links.txt.${NC}"

    # Step 3: Analyzing and reducing the query URLs based on repeated parameters
show_progress "Analyzing query strings for repeated parameters"

# Start the analysis in the background and get the process ID (PID)
(> ibro-xss.txt; > temp_param_names.txt; > temp_param_combinations.txt; while read -r url; do base_url=$(echo "$url" | cut -d'?' -f1); extension=$(echo "$base_url" | grep -oiE '\.php|\.asp|\.aspx|\.cfm|\.jsp'); if [[ -n "$extension" ]]; then echo "$url" >> ibro-xss.txt; else params=$(echo "$url" | grep -oE '\?.*' | tr '?' ' ' | tr '&' '\n'); param_names=$(echo "$params" | cut -d'=' -f1); full_param_string=$(echo "$url" | cut -d'?' -f2); if grep -qx "$full_param_string" temp_param_combinations.txt; then continue; else new_param_names=false; for param_name in $param_names; do if ! grep -qx "$param_name" temp_param_names.txt; then new_param_names=true; break; fi; done; if $new_param_names; then echo "$url" >> ibro-xss.txt; echo "$full_param_string" >> temp_param_combinations.txt; for param_name in $param_names; do echo "$param_name" >> temp_param_names.txt; done; fi; fi; fi; done < "${domain_name}-query.txt"; echo "Processed URLs with unique parameters: $(wc -l < ibro-xss.txt)") &

# Save the process ID (PID) of the background task
analysis_pid=$!

# Monitor the process in the background
while kill -0 $analysis_pid 2> /dev/null; do
    echo -e "${BOLD_BLUE}Analysis tool is still running...⌛️${NC}"
    sleep 30  # Check every 30 seconds
done

# When finished
echo -e "${BOLD_GREEN}Analysis completed. $(wc -l < ibro-xss.txt) URLs with repeated parameters have been saved.${NC}"
rm temp_param_names.txt temp_param_combinations.txt
sleep 3

    # Step 4: Cleanup and rename the output file
    show_progress "Cleaning up intermediate files and setting final output"
    rm -r "${domain_name}-query.txt"
    mv ibro-xss.txt "${domain_name}-query.txt"
    echo -e "${BOLD_BLUE}Cleaned up and renamed output to ${domain_name}-query.txt.${NC}"
    sleep 3

# Step 4: Cleanup and rename the output file
show_progress "Cleaning up intermediate files and setting final output"

# Filter the file ${domain_name}-query.txt using the specified awk command
show_progress "Filtering ${domain_name}-query.txt for unique and normalized URLs"
awk '{ gsub(/^https:/, "http:"); gsub(/^http:\/\/www\./, "http://"); if (!seen[$0]++) print }' "${domain_name}-query.txt" | tr -d '\r' > "${domain_name}-query1.txt"

# Remove the old query file
rm -r "${domain_name}-query.txt"

# Rename the filtered file to the original name
mv "${domain_name}-query1.txt" "${domain_name}-query.txt"

# Count the number of URLs in the renamed file
url_count=$(wc -l < "${domain_name}-query.txt")

## Final message with progress count
echo -e "${BOLD_BLUE}Cleaned up and renamed output to ${domain_name}-query.txt.${NC}"
echo -e "${BOLD_BLUE}Total URLs to be tested for Page Reflection: ${url_count}${NC}"
sleep 3

# Add links from arjun_output.txt into ${domain_name}-query.txt
if [ -f "arjun_output.txt" ]; then
    echo -e "${BOLD_WHITE}Adding links from arjun_output.txt into ${domain_name}-query.txt.${NC}"
    cat arjun_output.txt >> "${domain_name}-query.txt"
    echo -e "${BOLD_BLUE}Links from arjun_output.txt added to ${domain_name}-query.txt.${NC}"
else
    echo -e "${YELLOW}No Arjun output links to add. Proceeding without additional links.${NC}"
fi

# Extract unique subdomains and append search queries
echo -e "${BOLD_WHITE}Processing unique subdomains to append search queries...${NC}"

# Define the list of search queries to append
search_queries=(
    "search?q=aaa"
    "?query=aaa"
    "en-us/Search#/?search=aaa"
    "Search/Results?q=aaa"
    "q=aaa"
    "search.php?query=aaa"
    "en-us/search?q=aaa"
    "s=aaa"
    "find?q=aaa"
    "result?q=aaa"
    "query?q=aaa"
    "search?term=aaa"
    "search?query=aaa"
    "search?keywords=aaa"
    "search?text=aaa"
    "search?word=aaa"
    "find?query=aaa"
    "result?query=aaa"
    "search?input=aaa"
    "search/results?query=aaa"
    "search-results?q=aaa"
    "search?keyword=aaa"
    "results?query=aaa"
    "search?search=aaa"
    "search?searchTerm=aaa"
    "search?searchQuery=aaa"
    "search?searchKeyword=aaa"
    "search.php?q=aaa"
    "search/?query=aaa"
    "search/?q=aaa"
    "search/?search=aaa"
    "search.aspx?q=aaa"
    "search.aspx?query=aaa"
    "search.asp?q=aaa"
    "index.asp?id=aaa"
    "dashboard.asp?user=aaa"
    "blog/search/?query=aaa"
    "pages/searchpage.aspx?id=aaa"
    "search.action?q=aaa"
    "search.json?q=aaa"
    "search/index?q=aaa"
    "lookup?q=aaa"
    "browse?q=aaa"
    "search-products?q=aaa"
    "products/search?q=aaa"
    "news?q=aaa"
    "articles?q=aaa"
    "content?q=aaa"
    "explore?q=aaa"
    "search/advanced?q=aaa"
    "search-fulltext?q=aaa"
    "products?query=aaa"
    "search?product=aaa"
    "catalog/search?q=aaa"
    "store/search?q=aaa"
    "shop?q=aaa"
    "items?query=aaa"
    "search?q=aaa&category=aaa"
    "store/search?term=aaa"
    "marketplace?q=aaa"
    "blog/search?q=aaa"
    "news?query=aaa"
    "articles?search=aaa"
    "topics?q=aaa"
    "stories?q=aaa"
    "newsfeed?q="
    "search-posts?q=aaa"
    "blog/posts?q=aaa"
    "search/article?q=aaa"
    "api/search?q=aaa"
    "en/search/explore?q=aaa"
    "bs-latn-ba/Search/Results?q=aaa"
    "en-us/marketplace/apps?search=aaa"
    "search/node?keys=aaaa"
    "v1/search?q=aaa"
    "api/v1/search?q=aaa"
)

# Extract unique subdomains (normalize to remove protocol and www)
normalized_subdomains=$(awk -F/ '{print $1 "//" $3}' "${domain_name}-query.txt" | sed -E 's~(https?://)?(www\.)?~~' | sort -u)

# Create a mapping of preferred protocols for unique subdomains
declare -A preferred_protocols
while read -r url; do
    # Extract protocol, normalize subdomain
    protocol=$(echo "$url" | grep -oE '^https?://')
    subdomain=$(echo "$url" | sed -E 's~(https?://)?(www\.)?~~' | awk -F/ '{print $1}')

    # Set protocol preference: prioritize http over https
    if [[ "$protocol" == "http://" ]]; then
        preferred_protocols["$subdomain"]="http://"
    elif [[ -z "${preferred_protocols["$subdomain"]}" ]]; then
        preferred_protocols["$subdomain"]="https://"
    fi
done < "${domain_name}-query.txt"

# Create a new file for the appended URLs
append_file="${domain_name}-query-append.txt"
> "$append_file"

# Append each search query to the preferred subdomains
for subdomain in $normalized_subdomains; do
    protocol="${preferred_protocols[$subdomain]}"
    for query in "${search_queries[@]}"; do
        echo "${protocol}${subdomain}/${query}" >> "$append_file"
    done
done

# Combine the original file with the appended file
cat "${domain_name}-query.txt" "$append_file" > "${domain_name}-query-final.txt"

# Replace the original file with the combined result
mv "${domain_name}-query-final.txt" "${domain_name}-query.txt"

echo -e "${BOLD_BLUE}Appended URLs saved and combined into ${domain_name}-query.txt.${NC}"

# Step 3: Checking page reflection on the URLs
if [ -f "reflection.py" ]; then
    echo -e "${BOLD_WHITE}Checking page reflection on the URLs with command: python3 reflection.py ${domain_name}-query.txt --threads 2${NC}"
    sudo python3 reflection.py "${domain_name}-query.txt" --threads 2 || handle_error "reflection.py execution"
    sleep 5

    # Check if xss.txt is created after reflection.py
    if [ -f "xss.txt" ]; then
        # Check if xss.txt has any URLs (non-empty file)
        total_urls=$(wc -l < xss.txt)
        if [ "$total_urls" -eq 0 ]; then
            # If no URLs were found, stop the tool
            echo -e "\033[1;36mNo reflective URLs were identified. The process will terminate, and no further XSS testing will be conducted.\033[0m"
            exit 0
        else
            echo -e "${BOLD_WHITE}Page reflection done! New file created: xss.txt${NC}"

            # Display the number of URLs affected by reflection
            echo -e "${BOLD_WHITE}Total URLs reflected: ${RED}${total_urls}${NC}"

            # Filtering duplicate URLs
            echo -e "${BOLD_BLUE}Filtering duplicate URLs...${NC}"
            awk '{ gsub(/^https:/, "http:"); gsub(/^http:\/\/www\./, "http://"); if (!seen[$0]++) print }' "xss.txt" | tr -d '\r' > "xss1.txt"
            sleep 3

            # Remove the original xss.txt file
            echo -e "${BOLD_BLUE}Removing the old xss.txt file...${NC}"
            sudo rm -r xss.txt arjun_output.txt arjun-final.txt "${domain_name}-query-append.txt"
            sleep 3

            # Removing 99% similar parameters with bash command
            echo -e "${BOLD_BLUE}Removing 99% similar parameters...${NC}"
            awk -F'[?&]' '{gsub(/:80/, "", $1); base_url=$1; domain=base_url; params=""; for (i=2; i<=NF; i++) {split($i, kv, "="); if (!seen[domain kv[1]]++) {params=params kv[1]; if (i<NF) params=params "&";}} full_url=base_url"?"params; if (!param_seen[full_url]++) print $0 > "xss-urls.txt";}' xss1.txt
            sleep 5

            # Remove the intermediate xss1.txt file
            echo -e "${BOLD_BLUE}Removing the intermediate xss1.txt file...${NC}"
            sudo rm -r xss1.txt
            sleep 3

            # Running URO for xss-urls.txt file
            echo -e "${BOLD_BLUE}Running URO for xss-urls.txt file...${NC}"
            uro -i xss-urls.txt -o xss-urls1337.txt
            rm -r xss-urls.txt
            mv xss-urls1337.txt xss-urls.txt
            sleep 5

            # Final message with the total number of URLs in xss-urls.txt
            total_urls=$(wc -l < xss-urls.txt)
            echo -e "${BOLD_WHITE}New file is ready for XSS testing: xss-urls.txt with TOTAL URLs: ${total_urls}${NC}"
            echo -e "${BOLD_WHITE}Initial Total Merged URLs in the beginning : ${RED}${total_merged_urls}${NC}"
            echo -e "${BOLD_WHITE}Filtered Final URLs for XSS Testing: ${RED}${total_urls}${NC}"

            #Sorting URLs for xss0r:
            echo -e "${BOLD_BLUE}Sorting valid format URLs for xss0r...${NC}"
            awk '{sub("http://", "http://www."); sub("https://", "https://www."); print}' xss-urls.txt | sort -u > sorted-xss-urls.txt
            rm -r xss-urls.txt
            mv sorted-xss-urls.txt xss-urls.txt
            sleep 5


            # Automatically run the xss0r command after reflection step
            ./xss0r --get --urls xss-urls.txt --payloads payloads.txt --shuffle --threads 10 --path || handle_error "Launching xss0r Tool"
        fi
    else
        echo -e "${RED}xss.txt not found. No reflective URLs identified.${NC}"
        echo -e "\033[1;36mNo reflective URLs were identified. The process will terminate, and no further XSS testing will be conducted.\033[0m"
        exit 0
    fi
else
    echo -e "${RED}reflection.py not found in the current directory. Skipping page reflection step.${NC}"
fi
}

# Function to run step 8 (Launching xss0r Tool)
run_step_8() {
    echo -e "${BOLD_WHITE}You selected: Launching xss0r Tool for $domain_name${NC}"

    # Check if xss0r and xss-urls.txt files exist
    if [ -f "xss0r" ] && [ -f "xss-urls.txt" ]; then
        show_progress "Running xss0r for XSS vulnerabilities"
        ./xss0r --get --urls xss-urls.txt --payloads payloads.txt --shuffle --threads 10 --path
        if [[ $? -ne 0 ]]; then  # Check if xss0r command failed
            echo -e "${RED}The xss0r Tool encountered an error during execution.${NC}"
            exit 1
        fi
        sleep 5
        echo -e "${BOLD_BLUE}xss0r completed. Check the output files for results.${NC}"
    else
        # Custom error message when xss0r is missing
        if [ ! -f "xss0r" ]; then
            echo -e "${RED}The xss0r Tool is not present in the current directory.${NC}"
            echo -e "${CYAN}Please ensure the xss0r tool is placed in the directory and run the script again.${NC}"
            echo -e "${BOLD_WHITE}Alternatively, you can download or purchase the tool from store.xss0r.com. ${NC}"
            echo -e "${BOLD_WHITE}After obtaining the tool, execute the xss0r to enter your API key, and then proceed with the xss0rRecon tool.${NC}"
        fi
        
        # Check if xss-urls.txt file is missing
        if [ ! -f "xss-urls.txt" ]; then
            echo -e "${RED}The xss-urls.txt file is not present in the current directory. Please make sure the file is generated or placed in the directory and try again. Alternatively, you can download or purchase the tool from store.xss0r.com. After obtaining the tool, execute the xss0r to enter your API key, and then proceed with the xss0rRecon tool.${NC}"
        fi
    fi
}

# Function for Path-based XSS
run_path_based_xss() {
    echo -e "${BOLD_WHITE}You selected: Path-based XSS${NC}"

    # Check if any *-ALL-links.txt files are available
    available_files=$(ls *-ALL-links.txt 2>/dev/null)

    # If no files are found, display a message and return
    if [ -z "$available_files" ]; then
        echo -e "${RED}No *-ALL-links.txt files found.${NC}"
        echo -e "${BOLD_WHITE}Please start scanning your domain from step 2.${NC}"
        echo -e "${BOLD_WHITE}After completing the crawling and filtering processes, a file for Path-based XSS (${domain_name}-ALL-links.txt) will be generated.${NC}"
        return
    fi

    # List available domain files if found
    echo -e "${BOLD_WHITE}Available domain files:${NC}"
    echo "$available_files"
    
    # Prompt the user to enter the domain name (without the -ALL-links.txt part)
    read -p "Please enter the domain name (just the base, without '-ALL-links.txt'): " domain_name

    # Debugging output to check if domain_name is correctly set
    echo "Debug: The domain name is set to '${domain_name}'"

    # Check if the required file exists
    if [ ! -f "${domain_name}-ALL-links.txt" ]; then
        echo -e "${CYAN}Error: There is no file available for scanning path-based XSS.${NC}"
        echo -e "${CYAN}It appears that the necessary file, ${domain_name}-ALL-links.txt, has not been generated.${NC}"
        echo -e "${BOLD_WHITE}This file is created after completing the crawling and filtering processes.${NC}"
        echo -e "${BOLD_WHITE}Please return to Option 2 and follow the full process, including crawling and URL filtering.${NC}"
        return
    fi

    # Function to count and display the number of URLs after filtering
    count_urls() {
        local file=$1
        local message=$2
        local count=$(sudo wc -l < "$file")
        echo -e "${CYAN}${message} After filtering, the number of URLs is: ${RED}${count}${NC}"
    }

    # Step 0: Initial count of URLs in the main target file
    show_progress "Analyzing the initial number of URLs in ${domain_name}-ALL-links.txt..."
    count_urls "${domain_name}-ALL-links.txt" "Initial URL count before filtration."

    # Step 1: Filtering duplicate URLs
    show_progress "Filtering duplicate URLs..."
    sudo awk '{ gsub(/^https:/, "http:"); gsub(/^http:\/\/www\./, "http://"); if (!seen[$0]++) print }' "${domain_name}-ALL-links.txt" | sudo tr -d '\r' > "path1.txt"
    sleep 3
    count_urls "path1.txt" "Duplicate URLs filtered successfully."

    # Step 1.1: Filtering similar URLs with the same base path
    show_progress "Filtering similar URLs with similar base paths..."
    awk -F'/' '{base_path=$1"/"$2"/"$3"/"$4"/"$5"/"$6; if (!seen_base[base_path]++) print $0}' path1.txt > path1-filtered.txt
    sleep 3
    count_urls "path1-filtered.txt" "Similar URLs with the same base path filtered."

    # Step 2: Removing 99% similar parameters
    show_progress "Removing 99% similar parameters..."
    awk -F'[?&]' '{gsub(/:80/, "", $1); base_url=$1; domain=base_url; params=""; for (i=2; i<=NF; i++) {split($i, kv, "="); if (!seen[domain kv[1]]++) {params=params kv[1]; if (i<NF) params=params "&";}} full_url=base_url"?"params; if (!param_seen[full_url]++) print $0 > "path3.txt";}' path1-filtered.txt
    sleep 5
    count_urls "path3.txt" "Parameters processed and URLs filtered."

    # Step 3: Including all domains from the URLs without filtering
    show_progress "Including all domains from the URLs..."
    cat "path3.txt" > "path4.txt"
    sleep 3
    count_urls "path4.txt" "All domains included successfully."

    # Step 4: Filtering extensions from the URLs
    show_progress "Filtering extensions from the URLs..."
    cat path4.txt | sudo grep -E -v '\.css($|\s|\?|&|#|/|\.)|\.jpg($|\s|\?|&|#|/|\.)|\.JPG($|\s|\?|&|#|/|\.)|\.PNG($|\s|\?|&|#|/|\.)|\.GIF($|\s|\?|&|#|/|\.)|\.avi($|\s|\?|&|#|/|\.)|\.dll($|\s|\?|&|#|/|\.)|\.pl($|\s|\?|&|#|/|\.)|\.webm($|\s|\?|&|#|/|\.)|\.c($|\s|\?|&|#|/|\.)|\.py($|\s|\?|&|#|/|\.)|\.bat($|\s|\?|&|#|/|\.)|\.tar($|\s|\?|&|#|/|\.)|\.swp($|\s|\?|&|#|/|\.)|\.tmp($|\s|\?|&|#|/|\.)|\.sh($|\s|\?|&|#|/|\.)|\.deb($|\s|\?|&|#|/|\.)|\.exe($|\s|\?|&|#|/|\.)|\.zip($|\s|\?|&|#|/|\.)|\.mpeg($|\s|\?|&|#|/|\.)|\.mpg($|\s|\?|&|#|/|\.)|\.flv($|\s|\?|&|#|/|\.)|\.wmv($|\s|\?|&|#|/|\.)|\.wma($|\s|\?|&|#|/|\.)|\.aac($|\s|\?|&|#|/|\.)|\.m4a($|\s|\?|&|#|/|\.)|\.ogg($|\s|\?|&|#|/|\.)|\.mp4($|\s|\?|&|#|/|\.)|\.mp3($|\s|\?|&|#|/|\.)|\.bat($|\s|\?|&|#|/|\.)|\.dat($|\s|\?|&|#|/|\.)|\.cfg($|\s|\?|&|#|/|\.)|\.cfm($|\s|\?|&|#|/|\.)|\.bin($|\s|\?|&|#|/|\.)|\.jpeg($|\s|\?|&|#|/|\.)|\.JPEG($|\s|\?|&|#|/|\.)|\.ps.gz($|\s|\?|&|#|/|\.)|\.gz($|\s|\?|&|#|/|\.)|\.gif($|\s|\?|&|#|/|\.)|\.tif($|\s|\?|&|#|/|\.)|\.tiff($|\s|\?|&|#|/|\.)|\.csv($|\s|\?|&|#|/|\.)|\.png($|\s|\?|&|#|/|\.)|\.ttf($|\s|\?|&|#|/|\.)|\.ppt($|\s|\?|&|#|/|\.)|\.pptx($|\s|\?|&|#|/|\.)|\.ppsx($|\s|\?|&|#|/|\.)|\.doc($|\s|\?|&|#|/|\.)|\.woff($|\s|\?|&|#|/|\.)|\.xlsx($|\s|\?|&|#|/|\.)|\.xls($|\s|\?|&|#|/|\.)|\.mpp($|\s|\?|&|#|/|\.)|\.mdb($|\s|\?|&|#|/|\.)|\.json($|\s|\?|&|#|/|\.)|\.woff2($|\s|\?|&|#|/|\.)|\.icon($|\s|\?|&|#|/|\.)|\.pdf($|\s|\?|&|#|/|\.)|\.docx($|\s|\?|&|#|/|\.)|\.svg($|\s|\?|&|#|/|\.)|\.txt($|\s|\?|&|#|/|\.)|\.jar($|\s|\?|&|#|/|\.)|\.0($|\s|\?|&|#|/|\.)|\.1($|\s|\?|&|#|/|\.)|\.2($|\s|\?|&|#|/|\.)|\.3($|\s|\?|&|#|/|\.)|\.4($|\s|\?|&|#|/|\.)|\.m4r($|\s|\?|&|#|/|\.)|\.kml($|\s|\?|&|#|/|\.)|\.pro($|\s|\?|&|#|/|\.)|\.yao($|\s|\?|&|#|/|\.)|\.gcn3($|\s|\?|&|#|/|\.)|\.PDF($|\s|\?|&|#|/|\.)|\.egy($|\s|\?|&|#|/|\.)|\.par($|\s|\?|&|#|/|\.)|\.lin($|\s|\?|&|#|/|\.)|\.yht($|\s|\?|&|#|/|\.)' > path5.txt
    sleep 5
    count_urls "path5.txt" "Extensions filtered and URLs cleaned."

    # Step 5: Running URO tool again to filter duplicate and similar URLs
    show_progress "Running URO tool again to filter duplicate and similar URLs..."
    uro -i path5.txt -o path6.txt &
    uro_pid_clean=$!

    # Monitor the URO process
    while kill -0 $uro_pid_clean 2> /dev/null; do
        show_progress "URO tool is still running for clean URLs...⌛"
        sleep 30  # Check every 30 seconds
    done

    # Final message after URO processing completes
    show_progress "URO processing completed. Files created successfully."
    count_urls "path6.txt" "Final cleaned URLs after URO filtering."

    # Step 6: Deleting all previous files except the last one (path6.txt)
    show_progress "Deleting all intermediate files..."
    rm -f path1.txt path1-filtered.txt path3.txt path4.txt path5.txt ${domain_name}-unique-links.txt

    # Step 7: Renaming path6.txt to path-ready.txt
    show_progress "Renaming path6.txt to path-ready.txt..."
    mv path6.txt path-ready.txt

    # Step 8: Final message with the new file
    echo -e "${CYAN}New file created: path-ready.txt for path-based XSS.${NC}"

    # Step 9: Running Python script for reflection checks
    show_progress "Running Python script for reflection checks on filtered URLs..."
    sudo python3 path-reflection.py path-ready.txt --threads 2

    # Step 9.1: Checking if the new file is generated
    if [ -f path-xss-urls.txt ]; then
        echo -e "${CYAN}New file generated: path-xss-urls.txt.${NC}"
        count_urls "path-xss-urls.txt" "Final URL count in path-xss-urls.txt after Python processing."
    else
        echo -e "${RED}Error: path-xss-urls.txt was not generated! Please check the Python script.${NC}"
    fi

    # Run the URL processing function
    process_urls

    # Remove duplicate entries and normalize slashes in the output file,
    # ensuring the protocol part (https:// or http://) is not affected
    sort "$output_file" | sudo uniq | sudo sed -E 's|(https?://)|\1|; s|//|/|g' | sudo sed 's|:/|://|g' > "$output_file.tmp" && sudo mv "$output_file.tmp" "$output_file"

    # Final message for processed URLs
    echo -e "${CYAN}Processed URLs have been saved to $output_file.${NC}"

    # Step 11: Deleting intermediate files
    show_progress "Deleting intermediate files path-ready.txt and path-xss.txt..."
    rm -f path-ready.txt path-xss.txt

    echo -e "${CYAN}Intermediate files deleted. Final output is $output_file.${NC}"

    # Step 12: Launch the xss0r tool for path-based XSS testing
    echo -e "${BOLD_BLUE}Launching the xss0r tool on path-xss-urls.txt...${NC}"
    ./xss0r --get --urls path-xss-urls.txt --payloads payloads.txt --shuffle --threads 10 --path
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}The xss0r tool encountered an error during execution.${NC}"
        exit 1
    else
        echo -e "${BOLD_GREEN}xss0r tool executed successfully! Check the output for results.${NC}"
    fi
}

# Function to handle script interruption
trap_interrupt() {
    echo -e "\n${RED}Script interrupted. Exiting.${NC}"
    exit 1
}

# Trap SIGINT (Ctrl+C)
trap trap_interrupt SIGINT

# Function for Domains Search Input with Query Appending
run_domains_search_input() {
    echo -e "${BOLD_WHITE}You selected: Domains Search Input with Query Appending${NC}"

    # Define search queries
    domains_queries=(
        "search?q=aaa"
        "?query=aaa"
        "en-us/Search#/?search=aaa"
        "Search/Results?q=aaa"
        "q=aaa"
        "search.php?query=aaa"
        "en-us/search?q=aaa"
        "s=aaa"
        "find?q=aaa"
        "result?q=aaa"
        "query?q=aaa"
        "search?term=aaa"
        "search?query=aaa"
        "search?keywords=aaa"
        "search?text=aaa"
        "search?word=aaa"
        "find?query=aaa"
        "result?query=aaa"
        "search?input=aaa"
        "search/results?query=aaa"
        "search-results?q=aaa"
        "search?keyword=aaa"
        "results?query=aaa"
        "search?search=aaa"
        "search?searchTerm=aaa"
        "search?searchQuery=aaa"
        "search?searchKeyword=aaa"
        "search.php?q=aaa"
        "search/?query=aaa"
        "search/?q=aaa"
        "search/?search=aaa"
        "search.aspx?q=aaa"
        "search.aspx?query=aaa"
        "search.asp?q=aaa"
        "index.asp?id=aaa"
        "dashboard.asp?user=aaa"
        "blog/search/?query=aaa"
        "pages/searchpage.aspx?id=aaa"
        "search.action?q=aaa"
        "search.json?q=aaa"
        "search/index?q=aaa"
        "lookup?q=aaa"
        "browse?q=aaa"
        "search-products?q=aaa"
        "products/search?q=aaa"
        "news?q=aaa"
        "articles?q=aaa"
        "content?q=aaa"
        "explore?q=aaa"
        "search/advanced?q=aaa"
        "search-fulltext?q=aaa"
        "products?query=aaa"
        "search?product=aaa"
        "catalog/search?q=aaa"
        "store/search?q=aaa"
        "shop?q=aaa"
        "items?query=aaa"
        "search?q=aaa&category=aaa"
        "store/search?term=aaa"
        "marketplace?q=aaa"
        "blog/search?q=aaa"
        "news?query=aaa"
        "articles?search=aaa"
        "topics?q=aaa"
        "stories?q=aaa"
        "newsfeed?q="
        "search-posts?q=aaa"
        "blog/posts?q=aaa"
        "search/article?q=aaa"
        "/api/search?q=aaa"
        "en/search/explore?q=aaa"
        "bs-latn-ba/Search/Results?q=aaa"
        "en-us/marketplace/apps?search=aaa"
        "v1/search?q=aaa"
        "search/node?keys=aaaa"
        "api/v1/search?q=aaa"
    )

    normalize_domain() {
        local domain="$1"
        domain=$(echo "$domain" | tr '[:upper:]' '[:lower:]' | sed 's/^http:\/\///' | sed 's/^https:\/\///' | sed 's/^www\.//')
        echo "http://$domain"
    }

    append_and_save() {
        local domain="$1"
        local output_file="$2"
        normalized_domain=$(normalize_domain "$domain")
        for query in "${domains_queries[@]}"; do
            if [[ $query == /* ]]; then
                echo "$normalized_domain$query" >> "$output_file"
            else
                echo "$normalized_domain/$query" >> "$output_file"
            fi
        done
    }

    # Prompt for domains file
    read -p "Enter the path to your domains .txt file: " domains_file
    if [[ ! -f $domains_file ]]; then
        echo -e "${RED}The file does not exist - Please use your domains file from step 3.${NC}"
        return
    fi

    # Prepare output file
    output_file="appended-domains.txt"
    > "$output_file"

    echo -e "${BOLD_BLUE}Processing domains from $domains_file and appending queries...${NC}"

    # Process each domain and append queries
    while IFS= read -r domain || [[ -n "$domain" ]]; do
        append_and_save "$domain" "$output_file"
    done < "$domains_file"

    echo -e "${BOLD_GREEN}All domains appended with queries and saved to $output_file.${NC}"

    # Run the reflection.py script
    reflection_script="reflection.py"
if [[ -f $reflection_script ]]; then
    echo -e "${BOLD_BLUE}Formatting URLs in $output_file to http://www format...${NC}"
    
    # Preprocess $output_file to ensure all URLs are in the http://www format
    temp_file="formatted_$output_file"
    awk -F'://' '{print "http://www." $2}' "$output_file" > "$temp_file"
    
    # Replace the original file with the formatted version
    mv "$temp_file" "$output_file"
    
    echo -e "${BOLD_GREEN}URLs formatted successfully.${NC}"
    echo -e "${BOLD_BLUE}Running reflection.py on $output_file...${NC}"
    sudo python3 "$reflection_script" "$output_file" --threads 3
    echo -e "${BOLD_GREEN}Reflection done, new domains saved in the file xss.txt.${NC}"

        # Run the xss0r command
        if [[ -x ./xss0r ]]; then
            echo -e "${BOLD_BLUE}Running xss0r Tool:${NC}"
            ./xss0r --get --urls xss.txt --payloads payloads.txt --shuffle --threads 10
        else
            echo -e "${RED}xss0r executable not found in the current directory.${NC}"
        fi
    else
        echo -e "${RED}Reflection script $reflection_script not found.${NC}"
    fi
}

while true; do
    # Display options
    display_options
    read -p "Enter your choice [1-12]: " choice

    # Check if the selected option is in the correct order
    if [[ $choice -ge 2 && $choice -le 8 && $choice -ne 4 ]]; then
        if [[ $choice -gt $((last_completed_option + 1)) ]]; then
            echo -e "${RED}Please respect order one by one from 1-8, you can't skip previous Options${NC}"
            continue
        fi
    fi

    case $choice in
        1)
            install_tools
            last_completed_option=1
            ;;
        2)
            read -p "Please enter a domain name (example.com): " domain_name
            echo -e "${BOLD_WHITE}You selected: Domain name set to $domain_name${NC}"
            last_completed_option=2
            
            # Automatically proceed to Step 3 after setting the domain name
            read -p "$(echo -e "${BOLD_WHITE}Do you want to proceed with domain enumeration and filtering for $domain_name (Y/N)?: ${NC}")" proceed_to_step_3
            if [[ "$proceed_to_step_3" =~ ^[Yy]$ ]]; then
                echo -e "${BOLD_BLUE}Automatically continuing with step 3: Domain Enumeration and Filtering for $domain_name...${NC}"
                run_step_3
                last_completed_option=3
            else
                echo -e "${BOLD_WHITE}You can manually start Step 3 whenever you are ready.${NC}"
            fi
            ;;
        3)
            if [ -z "$domain_name" ]; then
                echo "Domain name is not set. Please select option 2 to set the domain name."
            else
                run_step_3
                last_completed_option=3
            fi
            ;;
        4)
            if [ -z "$domain_name" ]; then
                echo "Domain name is not set. Please select option 2 to set the domain name."
            else
                run_step_4
                last_completed_option=4
            fi
            ;;
        5)
            if [ -z "$domain_name" ]; then
                echo "Domain name is not set. Please select option 2 to set the domain name."
            else
                run_step_5
                last_completed_option=5
            fi
            ;;
        6)
            if [ -z "$domain_name" ]; then
                echo "Domain name is not set. Please select option 2 to set the domain name."
            else
                run_step_6
                last_completed_option=6
            fi
            ;;
        7)
            if [ -z "$domain_name" ]; then
                echo "Domain name is not set. Please select option 2 to set the domain name."
            else
                run_step_7
                last_completed_option=7
            fi
            ;;
        8)
            if [ -z "$domain_name" ]; then
                echo "Domain name is not set. Please select option 2 to set the domain name."
            else
                run_step_8
                last_completed_option=8
            fi
            ;;
        9)
            echo "Exiting script."
            exit 0
            ;;
        10)
            echo -e "${BOLD_WHITE}You selected: Guide to Deploying xss0r on VPS Servers${NC}"
            show_vps_info
            ;;
       11) # Execute Path-based XSS
            run_path_based_xss
            last_completed_option=11
            ;;
        12) # Domains Search Input
            run_domains_search_input
            last_completed_option=12
            ;;
        *)
            echo "Invalid option. Please select a number between 1 and 11."
            ;;
    esac
done
