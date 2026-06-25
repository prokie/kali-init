# 🚀 Cheatsheet

A quick reference guide for the tools installed in this environment. 

## 🛠 Modern CLI Replacements

These tools replace legacy Unix commands with faster, smarter, and colorized alternatives.

| Tool | Replaces | Command / Usage | Description |
| :--- | :--- | :--- | :--- |
| **eza** | `ls` | `ls`, `ll`, `la` | Modern `ls` with icons and Git integration. |
| **bat** | `cat` | `bat <file>` | A `cat` clone with syntax highlighting and Git diffs. |
| **ripgrep** | `grep` | `rg <pattern>` | Extremely fast line-oriented search tool. |
| **fd** | `find` | `fd <pattern>` | Simple, fast, and user-friendly alternative to `find`. |
| **tealdeer** | `man` | `tldr <command>` | Fast, simplified, community-driven man pages. |

## 🧭 Navigation & Shell

*   **zoxide (`z`)**: A smarter `cd` that remembers your frequent directories.
    *   `z lab` - Jump instantly to the highest-ranked directory matching "lab".
    *   `zi` - Open an interactive fuzzy-finder menu to select a directory.
*   **fzf**: Command-line fuzzy finder.
    *   `Ctrl + R` - Reverse search your command history interactively.
    *   `Ctrl + T` - Fuzzy find files in your current path to append to a command.

## ☠️ Security & Reconnaissance

| Tool | Usage | Description |
| :--- | :--- | :--- |
| **rustscan** | `rustscan -a <IP>` | Blazing fast port scanner. Finds open ports, then automatically pipes them into Nmap. |
| **feroxbuster** | `feroxbuster -u <URL>` | Fast, simple, recursive content discovery (directory brute-forcing). |
| **ffuf** | `ffuf -u <URL/FUZZ> -w <wordlist>` | Fast web fuzzer written in Go. Great for directory discovery, virtual host routing, and GET/POST parameter fuzzing. |

