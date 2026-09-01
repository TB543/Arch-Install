# Arch Install

A simple automated Arch Linux installation script.

## Installation

### 1. Flash Arch Linux

Flash the **Arch Linux minimal environment** to a USB drive and boot from it.

### 2. Install Git

Once booted into the Arch environment, install Git:

```bash
sudo pacman -S git
```

### 3. Clone the Repository

Clone this repository:

```bash
git clone https://github.com/TB543/Arch-Install.git
```

### 4. Navigate to the Repository

```bash
cd Arch-Install
```

### 5. Make the Install Script Executable

Give the installation script execute permissions:

```bash
chmod +x install.sh
```

### 6. Run the Installer

Run the installation script:

```bash
./install.sh
```

The script will handle the remaining installation steps.
