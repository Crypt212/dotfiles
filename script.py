#!/usr/bin/env python3
import os
import sys
import json
import shutil
import argparse
from pathlib import Path
import subprocess
import logging
from datetime import datetime

class DotfilesManager:
    def __init__(self, config_path="dotfiles.json", dotfiles_root="."):
        self.dotfiles_root = Path(dotfiles_root).expanduser().resolve()
        self.config = self._load_config(config_path)
        self.backup_dir = Path("~/.dotfiles_backup").expanduser()
        self.backup_dir.mkdir(parents=True, exist_ok=True)
        self.logger = self._setup_logger()

    def _setup_logger(self):
        logger = logging.getLogger('dotfiles_manager')
        logger.setLevel(logging.INFO)
        ch = logging.StreamHandler()
        ch.setFormatter(logging.Formatter('%(levelname)s: %(message)s'))
        logger.addHandler(ch)
        return logger

    def _load_config(self, path):
        try:
            with open(path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            self.logger.error(f"Config file '{path}' not found!")
            sys.exit(1)
        except json.JSONDecodeError:
            self.logger.error(f"Invalid JSON in '{path}'!")
            sys.exit(1)

    def _expand_path(self, path):
        return Path(os.path.expandvars(str(path))).expanduser().resolve()

    def _backup_file(self, dest_path):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = self.backup_dir / f"{dest_path.name}_{timestamp}"
        shutil.move(str(dest_path), str(backup_path))
        self.logger.info(f"Backed up {dest_path} to {backup_path}")

    def _create_symlink(self, src, dest):
        src_path = self.dotfiles_root / src
        dest_path = self._expand_path(dest)
        
        if not src_path.exists():
            self.logger.warning(f"Source path {src_path} does not exist!")
            return
        
        if dest_path.exists():
            if self.config["metadata"].get("backup", True):
                self._backup_file(dest_path)
            elif dest_path.is_symlink():
                dest_path.unlink()
            else:
                self.logger.warning(f"Skipping {dest_path} - file exists and backup disabled")
                return
        
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        os.symlink(src_path, dest_path)
        self.logger.info(f"Created symlink: {src_path} -> {dest_path}")

    def _install_package(self, package):
        package_name = package["package_name"]
        install_method = package.get("install_method", 
                                    self.config["metadata"]["default_install_method"])
        
        self.logger.info(f"Installing {package_name} via {install_method}")
        
        try:
            if install_method == "pacman":
                subprocess.run(["sudo", "pacman", "-S", "--noconfirm", package_name], check=True)
            elif install_method == "flatpak":
                flatpak_id = package.get("flatpak_id", package_name)
                subprocess.run(["flatpak", "install", "-y", flatpak_id], check=True)
            elif install_method == "aur":
                subprocess.run(["yay", "-S", "--noconfirm", package_name], check=True)
            else:
                self.logger.error(f"Unknown install method: {install_method}")
                return False
        except subprocess.CalledProcessError as e:
            self.logger.error(f"Failed to install {package_name}: {e}")
            return False
        
        return True

    def _run_install_scripts(self, package):
        scripts = package.get("install_scripts", [])
        config_file_name = package.get("config_file_name", "")
        
        for script in scripts:
            # Replace variables in script
            script = script.replace("${this.config_file_name}", config_file_name)
            script = os.path.expandvars(script)
            
            self.logger.info(f"Running install script: {script}")
            
            try:
                if " | " in script:
                    subprocess.run(script, shell=True, check=True)
                else:
                    subprocess.run(script.split(), check=True)
            except subprocess.CalledProcessError as e:
                self.logger.error(f"Install script failed: {e}")

    def _handle_package(self, package):
        # Install package
        if not self._install_package(package):
            return False
        
        # Run install scripts
        self._run_install_scripts(package)
        
        # Create symlinks
        for symlink in package.get("symlinks", []):
            self._create_symlink(symlink["src"], symlink["dest"])
        
        return True

    def package_add(self, group_name, package_data):
        """Add a new package to a group"""
        if group_name not in self.config["packages"]:
            self.logger.error(f"Group '{group_name}' does not exist!")
            return False
        
        # Add to existing group
        self.config["packages"][group_name].append(package_data)
        self.logger.info(f"Added package '{package_data['package_name']}' to group '{group_name}'")
        return True

    def package_remove(self, group_name, package_name):
        """Remove a package from a group"""
        if group_name not in self.config["packages"]:
            self.logger.error(f"Group '{group_name}' does not exist!")
            return False
        
        for i, package in enumerate(self.config["packages"][group_name]):
            if package["package_name"] == package_name:
                del self.config["packages"][group_name][i]
                self.logger.info(f"Removed package '{package_name}' from group '{group_name}'")
                return True
        
        self.logger.error(f"Package '{package_name}' not found in group '{group_name}'")
        return False

    def package_edit(self, group_name, package_name, new_data):
        """Edit an existing package"""
        if group_name not in self.config["packages"]:
            self.logger.error(f"Group '{group_name}' does not exist!")
            return False
        
        for i, package in enumerate(self.config["packages"][group_name]):
            if package["package_name"] == package_name:
                self.config["packages"][group_name][i] = new_data
                self.logger.info(f"Updated package '{package_name}' in group '{group_name}'")
                return True
        
        self.logger.error(f"Package '{package_name}' not found in group '{group_name}'")
        return False

    def group_add(self, group_name, group_data=None):
        """Add a new group"""
        if group_name in self.config["packages"]:
            self.logger.error(f"Group '{group_name}' already exists!")
            return False
        
        self.config["packages"][group_name] = group_data or []
        self.logger.info(f"Added new group: '{group_name}'")
        return True

    def group_remove(self, group_name):
        """Remove a group and all its packages"""
        if group_name not in self.config["packages"]:
            self.logger.error(f"Group '{group_name}' does not exist!")
            return False
        
        del self.config["packages"][group_name]
        self.logger.info(f"Removed group: '{group_name}'")
        return True

    def group_install(self, group_name):
        """Install all packages in a group"""
        if group_name not in self.config["packages"]:
            self.logger.error(f"Group '{group_name}' does not exist!")
            return False
        
        self.logger.info(f"Installing group: {group_name}")
        
        for package in self.config["packages"][group_name]:
            self.logger.info(f"Processing package: {package['package_name']}")
            self._handle_package(package)
        
        return True

    def package_install(self, package_name, group_name=None):
        """Install a specific package by name"""
        found = False
        
        for group, packages in self.config["packages"].items():
            if group_name and group != group_name:
                continue
                
            for package in packages:
                if package["package_name"] == package_name:
                    found = True
                    self.logger.info(f"Installing package: {package_name} from group {group}")
                    self._handle_package(package)
        
        if not found:
            self.logger.error(f"Package '{package_name}' not found in {'any group' if not group_name else group_name}!")
            return False
        
        return True

    def save_config(self, output_path="dotfiles.json"):
        """Save the modified configuration back to file"""
        with open(output_path, 'w') as f:
            json.dump(self.config, f, indent=2)
        self.logger.info(f"Configuration saved to {output_path}")

def main():
    parser = argparse.ArgumentParser(description="Dotfiles and Package Manager")
    parser.add_argument("command", choices=[
        "group-install", "package-install", "package-add", 
        "package-remove", "package-edit", "group-add", 
        "group-remove", "list", "save"
    ])
    parser.add_argument("--group", help="Group name")
    parser.add_argument("--package", help="Package name")
    parser.add_argument("--data", help="JSON data for package or group")
    parser.add_argument("--config", default="dotfiles.json", help="Configuration file path")
    parser.add_argument("--dotfiles-root", default=".", help="Root directory for dotfiles")
    
    args = parser.parse_args()
    manager = DotfilesManager(args.config, args.dotfiles_root)
    
    if args.command == "group-install":
        if not args.group:
            parser.error("--group required for group-install")
        manager.group_install(args.group)
    
    elif args.command == "package-install":
        if not args.package:
            parser.error("--package required for package-install")
        manager.package_install(args.package, args.group)
    
    elif args.command == "package-add":
        if not args.group or not args.data:
            parser.error("--group and --data required for package-add")
        try:
            package_data = json.loads(args.data)
            manager.package_add(args.group, package_data)
        except json.JSONDecodeError:
            print("Invalid JSON data!")
    
    elif args.command == "package-remove":
        if not args.group or not args.package:
            parser.error("--group and --package required for package-remove")
        manager.package_remove(args.group, args.package)
    
    elif args.command == "package-edit":
        if not args.group or not args.package or not args.data:
            parser.error("--group, --package, and --data required for package-edit")
        try:
            new_data = json.loads(args.data)
            manager.package_edit(args.group, args.package, new_data)
        except json.JSONDecodeError:
            print("Invalid JSON data!")
    
    elif args.command == "group-add":
        if not args.group:
            parser.error("--group required for group-add")
        group_data = json.loads(args.data) if args.data else None
        manager.group_add(args.group, group_data)
    
    elif args.command == "group-remove":
        if not args.group:
            parser.error("--group required for group-remove")
        manager.group_remove(args.group)
    
    elif args.command == "list":
        print("Available groups:")
        for group in manager.config["packages"]:
            print(f"\n{group}:")
            for pkg in manager.config["packages"][group]:
                print(f"  - {pkg['package_name']}")
    
    elif args.command == "save":
        manager.save_config()
    
    # Save changes after modification commands
    if args.command in ["package-add", "package-remove", "package-edit", "group-add", "group-remove"]:
        manager.save_config()

if __name__ == "__main__":
    main()
