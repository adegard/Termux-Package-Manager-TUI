mkdir -p ~/bin

cat > ~/bin/tpm << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Termux Package Manager TUI

action=$(printf "Search\nInstalled\nUpgrade\nUpgrade all\nExit" | fzf --prompt="TPM > ")

case "$action" in
    "Search")
        pkg search "" | fzf --prompt="Search > " --preview="echo {}" \
        | awk '{print $1}' \
        | while read -r pkgname; do
            [ -z "$pkgname" ] && exit
            confirm=$(printf "Install\nCancel" | fzf --prompt="Install $pkgname > ")
            [ "$confirm" = "Install" ] && pkg install "$pkgname"
        done
        ;;
    "Installed")
        dpkg -l | awk '/^ii/ {print $2}' \
        | fzf --prompt="Installed > " --preview="apt show {} 2>/dev/null" \
        | while read -r pkgname; do
            confirm=$(printf "Remove\nCancel" | fzf --prompt="Remove $pkgname > ")
            [ "$confirm" = "Remove" ] && pkg uninstall "$pkgname"
        done
        ;;
    "Upgrade")
        pkg list-upgradable | awk '{print $1}' \
        | fzf --prompt="Upgrade > " --preview="apt show {} 2>/dev/null" \
        | while read -r pkgname; do
            confirm=$(printf "Upgrade\nCancel" | fzf --prompt="Upgrade $pkgname > ")
            [ "$confirm" = "Upgrade" ] && pkg upgrade "$pkgname"
        done
        ;;
    "Upgrade all")
        pkg upgrade
        ;;
    "Exit")
        exit
        ;;
esac
EOF

chmod +x ~/bin/tpm
