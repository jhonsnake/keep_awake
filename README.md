# Keep Awake

A tiny native **KDE Plasma 6** panel widget that keeps your computer awake — it
inhibits automatic suspend and the screensaver while active. Click the tray icon
to toggle it on or off.

Built on KDE's own inhibition mechanism (`kde-inhibit`, via D-Bus), so it works
correctly on both **Wayland** and **X11**.

## Features

- One-click toggle that lives in your panel / system tray.
- Inhibits **automatic suspend** and the **screensaver / screen locking** while active.
- Visual state: bright icon = active, dimmed icon = inactive.
- Releases the inhibition automatically when toggled off or when the widget is removed.
- No external dependencies beyond what ships with Plasma.
- Localized into English, Spanish, German, French, Portuguese (Brazil), Italian,
  Russian, Simplified Chinese and Japanese — follows your system language.

## Requirements

- KDE Plasma 6
- `kde-inhibit` (part of `plasma-workspace`, already present on a standard Plasma install)

## Installation

### From the repository

```bash
git clone https://github.com/jhonsnake/keep_awake.git
cd keep_awake
./install.sh
```

`install.sh` (re)compiles the translation catalogs and installs the widget with
`kpackagetool6`.

### Manual

```bash
kpackagetool6 --type Plasma/Applet --install .
# to update an existing install, use --upgrade instead of --install
```

After installing, restart Plasma Shell so the widget appears in the list:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

## Usage

1. Right-click on your **panel** → **Add Widgets…**
2. Search for **Keep Awake** and drag it onto the panel.
3. Click the icon to toggle:
   - **Bright icon** → active: the computer will not sleep and the screensaver is inhibited.
   - **Dimmed icon** → inactive: normal power behavior.

To confirm it is working while active:

```bash
systemd-inhibit --list
```

You should see an inhibitor held by `kde-inhibit`.

## How it works

The widget runs `kde-inhibit --power --screenSaver sleep infinity` through Plasma's
executable data source while active. `kde-inhibit` holds the power-management and
screensaver inhibitions for as long as its child process is alive; toggling the
widget off terminates that process and releases the locks.

## Translations

Source strings live in `po/`. To add or update a language:

```bash
# edit or create po/<lang>.po, then recompile:
msgfmt po/<lang>.po -o contents/locale/<lang>/LC_MESSAGES/plasma_applet_org.kde.keep_awake.mo
```

## Uninstall

```bash
kpackagetool6 --type Plasma/Applet --remove org.kde.keep_awake
```

## License

MIT — see [LICENSE](LICENSE).
