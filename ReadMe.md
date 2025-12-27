# 🔐 Enigma Encryption Playground

Welcome to my personal practice space for recreating the classic Enigma-style encryption/decryption tool. This repo is intentionally small right now so I can grow it feature by feature while practicing clean Ruby design that a future employer can inspect. 🚀

## 📖 Project Snapshot
- Inspired by the [Enigma project requirements](https://backend.turing.edu/module1/projects/enigma/requirements) but built for **my own professional development**, not as a school submission.
- Goal: model a simple CLI-friendly service that can encrypt and decrypt messages using rotating offsets derived from a key and date.
- Current codebase is intentionally minimal: the `Enigma` class is scaffolded and the first spec ensures the object can be instantiated and will soon encrypt text.

## ✅ What Exists Today (and Why)
- `Enigma` class scaffold (`lib/enigma.rb`): created to establish the primary API surface before adding algorithms. This keeps early specs focused on interface design instead of implementation details.
- RSpec setup (`spec/enigma_spec.rb`): includes an instantiation check and a pending encryption expectation. Starting with tests clarifies the expected inputs/outputs and keeps future changes guided by behavior.

## 🧭 Ideal Builder
This project is crafted for a developer who:
- Wants to showcase **test-driven Ruby skills** to prospective employers.
- Enjoys translating algorithmic specs into readable, well-documented code.
- Values incremental delivery with clear “why” notes for each feature addition.
- Prefers approachable, CLI-centric tooling over heavy frameworks.

## 🛠️ Roadmap
As I expand the repo, each feature will include a short note on **why** it was added and how it improves the developer or user experience. Near-term steps:
1. Implement `encrypt` to satisfy the existing spec and document how the key/date generate shifts.
2. Add matching `decrypt` behavior with validation for keys and dates.
3. Provide a lightweight command-line interface for encrypt/decrypt flows.
4. Document sample runs and edge cases to aid reviewer understanding.

## 🤝 Contributing (Future-Friendly)
While this is a personal practice project, the structure is kept professional—clean commits, descriptive PRs, and thoughtful documentation—so employers can follow the evolution. Suggestions are welcome via issues or pull requests.

## 🧾 Reference Links
- Requirements: https://backend.turing.edu/module1/projects/enigma/requirements
- Encryption details: https://backend.turing.edu/module1/projects/enigma/encryption
- Evaluation rubric: https://backend.turing.edu/module1/projects/enigma/rubric
