<p align="center">
  <img width="120px" src="./harbr/assets/icon/icon.png" alt="Harbr">
</p>

<h1 align="center">Harbr</h1>

<p align="center">
  A modern, open-source mobile client for managing your self-hosted media stack.
</p>

<p align="center">
  <a href="https://github.com/islamdiaa/harbr/blob/master/LICENSE.md"><img src="https://img.shields.io/badge/license-GPL--2.0-blue?style=flat-square" alt="License"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/built%20with-Flutter-02569B?style=flat-square&logo=flutter" alt="Flutter"></a>
</p>

---

## What is Harbr?

Harbr gives you a single, unified interface to control all your *arr services and media tools from your phone, tablet, or desktop. No more juggling browser tabs.

> Harbr is a remote control app — it requires services already running on your server.

## Supported Services

| Service | Type |
|---------|------|
| [Radarr](https://github.com/radarr/radarr) | Movies |
| [Sonarr](https://github.com/sonarr/sonarr) | TV Shows |
| [Lidarr](https://github.com/lidarr/lidarr) | Music |
| [Readarr](https://github.com/readarr/readarr) | Books |
| [Tautulli](https://github.com/Tautulli/Tautulli) | Plex Monitoring |
| [SABnzbd](https://github.com/sabnzbd/sabnzbd) | Usenet Downloads |
| [NZBGet](https://github.com/nzbget/nzbget) | Usenet Downloads |
| [NZBHydra2](https://github.com/theotherp/nzbhydra2) | Indexer Proxy |
| [Newznab](https://newznab.readthedocs.io/en/latest/misc/api/) | Indexer Search |
| [Wake on LAN](https://en.wikipedia.org/wiki/Wake-on-LAN) | Server Wake |

## Features

- **Multi-instance profiles** — manage multiple servers from one app
- **Push notifications** — webhook-based alerts for grabs, imports, and failures
- **Backup & restore** — export and import your full configuration
- **Dark & AMOLED themes** — easy on the eyes, easy on the battery
- **Cross-platform** — Android, iOS, macOS, Linux, Windows, Web

## Getting Started

```bash
cd harbr
flutter pub get
flutter run
```

See the [Flutter docs](https://docs.flutter.dev/get-started/install) if you need to set up your environment.

## License

Licensed under the [GNU General Public License v2.0](LICENSE.md).
