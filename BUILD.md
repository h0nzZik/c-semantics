# Install FlatPak

## Fedora

```
sudo dnf install flatpak flatpak-builder

```

## Ubuntu

TODO


# Configure FlatPak

```
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak install flathub org.freedesktop.Platform//18.08 org.freedesktop.Sdk//18.08
```

# Build

```
flatpak-builder --force-clean build-dir com.runtimeverification.rv-match.json
```
