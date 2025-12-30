# vRP NZ — Open Source FiveM Server

Welcome — this repository contains the vRP NZ FiveM server template and the start of an open, community-driven roleplay + racing project. The server is developed openly and aims to be modular, customizable, and friendly to contributors.

---

## Vision & Goals

- Build a player-first RP server with a car-racing/“boy‑racer” focus.
- Realistic economy, jobs, vehicle upgrades and progression systems.
- Highly-customizable, theme-consistent UI (loading screens, menus, HUD).
- Persistent, database-driven characters and player data.
- Modular systems: inventory, garages, crews, events, jobs, NPC interactions.
- Community contributions and transparent development — everyone welcome.

---

## Open Source & Licensing

- This project intends to be open and collaborative.
- Third‑party libraries maintain their own licenses. Example: `oxmysql` is LGPLv3 — you may include it but must comply with LGPL obligations (see `resources/[core]/oxmysql/LICENSE`). Do not publish secrets or credentials.
- Our custom code is published under MIT by default (unless otherwise noted). Add/change license files as needed.

---

## Quickstart (developer)

1. Clone repo:
   git clone <your-repo-url>

2. Prepare server configuration:
   - Copy `server.cfg.example` → `server.cfg`
   - Fill in database connection and license key locally (do NOT commit real values).

3. Start the server (Windows example):
   - Run your FXServer start script or use txAdmin.
   - From server console: `ensure [core]` and required resources.

4. Development workflow:
   - Make changes in a feature branch.
   - Commit small, focused changes and open PRs for review.
   - Keep secrets out of commits.

---

## Contributing

We welcome contributions of all sizes: bug fixes, UI improvements, features, docs, and tests.

- Follow these basics:
  - Fork the repo, create a branch per feature/bugfix.
  - Keep commits atomic and well‑described.
  - Open a Pull Request with a short description, testing steps, and screenshots if UI changes.
  - Be respectful and responsive to review feedback.

If you want to help but don’t know where to start, check issues labeled `good-first-issue` or drop a message in the project discussions.

---

## Development Notes & Best Practices

- Do NOT commit:
  - `server.cfg` with real credentials
  - database dumps, player DBs, cache, `.rpf` stream files, or large binaries
- Use `.gitignore` to exclude runtime artifacts and secrets.
- Prefer submodules or documented links for large third‑party resources.
- Keep config examples (e.g., `server.cfg.example`) with placeholders for local setup.
- Document any breaking changes and migration steps in the project wiki or changelog.

---

## Architecture & Key Resources

- resources/[core]/vCore — core shared functionality and config
- resources/[core]/vCore_ui — shared UI CSS, components
- resources/[core]/vMultichar — character selection & creation flow WIP
- resources/[core]/vLoadScreen — NUI loading screen resource WIP
- resources/[core]/oxmysql — third‑party DB adapter (LGPLv3)

See each subfolder for README and comments specific to that resource.

---

## Testing & QA

- Test changes locally with a development SQL instance.
- Use a disposable player DB for experiments.
- Verify camera/ped streaming and NUI flows in‑game (F8 console for JS errors).
- After UI changes, test on multiple resolutions to ensure layout stability.

---

## Communication

- Use GitHub Issues for bugs/feature requests.
- Use Pull Requests for code contributions.

---

## Acknowledgements

Thanks to the upstream open‑source FiveM community and the authors of third‑party libraries (oxmysql, etc.). Refer to each resource's LICENSE file for full attribution and license terms.

---

## Want to help?

Perfect — open an issue describing what you want to work on or submit a small PR. If you’re unsure where to start, suggest improvements to docs or UI polish — these are high‑value first contributions.

Thank you for being part of the vRP NZ open source journey. Let’s build something great together.