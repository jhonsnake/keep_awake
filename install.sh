#!/usr/bin/env bash
# Install (or upgrade) the Keep Awake Plasma 6 widget.
set -euo pipefail

DOMAIN="plasma_applet_org.kde.keep_awake"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Recompile translation catalogs if msgfmt is available.
if command -v msgfmt >/dev/null 2>&1; then
    for po in po/*.po; do
        lang="$(basename "${po%.po}")"
        out="contents/locale/${lang}/LC_MESSAGES"
        mkdir -p "$out"
        msgfmt "$po" -o "${out}/${DOMAIN}.mo"
        echo "compiled ${lang}"
    done
fi

if kpackagetool6 --type Plasma/Applet --list 2>/dev/null | grep -q "^org.kde.keep_awake$"; then
    kpackagetool6 --type Plasma/Applet --upgrade .
else
    kpackagetool6 --type Plasma/Applet --install .
fi

echo
echo "Installed. Restart Plasma Shell to see the widget:"
echo "  kquitapp6 plasmashell && kstart plasmashell"
