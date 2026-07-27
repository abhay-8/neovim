# Neovim shortcuts (leader = Space)

## General

| Key         | Action                     |
| ----------- | -------------------------- |
| `<leader>e` | Open Oil (File Explorer)   |
| `<leader>w` | Cycle windows              |
| `ad`        | Open dashboard (Alpha)     |

## 🛢️ Oil File Explorer (when open)

Oil treats your filesystem like a regular text buffer: rename lines to rename files, delete lines to delete files, and type `:w` to save!

| Key         | Action                                         |
| ----------- | ---------------------------------------------- |
| `<CR>`      | Open file / Enter directory                    |
| `-`         | Go up to parent directory                      |
| `<C-p>`     | Toggle file preview window                     |
| `<C-s>`     | Open file in vertical split                    |
| `<C-h>`     | Open file in horizontal split                  |
| `<C-t>`     | Open file in new tab                           |
| `g.`        | Toggle hidden files and directories (`.*`)     |
| `gs`        | Change sort order (name, type, etc.)           |
| `gx`        | Open file in external system app (e.g. browser)|
| `g?`        | Show full popup help menu of all Oil commands  |
| `:w`        | Save buffer to execute file renames/deletes    |
| `<C-c>`     | Close Oil float window                         |

## ⚡ Harpoon 2 (Microservice Teleportation)

| Key         | Action                          |
| ----------- | ------------------------------- |
| `<leader>a`  | Bookmark current file           |
| `<leader>h`  | Toggle Harpoon quick menu       |
| `<leader>hc` | Clear all Harpoon bookmarks     |
| `<leader>1`  | Instant teleport to File 1      |
| `<leader>2` | Instant teleport to File 2      |
| `<leader>3` | Instant teleport to File 3      |
| `<leader>4` | Instant teleport to File 4      |

## 🧠 Pomodoro Rest Timer & Art

The 20-minute Pomodoro timer **automatically starts on your very first keystroke** in Neovim! Every 20 minutes, a centered floating window appears with abstract digital art to remind you to rest your eyes and reset.

| Key          | Action                                         |
| ------------ | ---------------------------------------------- |
| `<leader>ps` | Start / Reset Pomodoro timer (20 minutes)      |
| `<leader>pt` | Check time remaining until next rest break     |
| `<leader>po` | Test / Open rest notification & abstract art   |
| `<leader>pc` | Stop / Cancel Pomodoro timer                   |

## 🛠️ Automated Refactoring (Fowler-Style)

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `<leader>re` | Extract Function (Visual Mode)             |
| `<leader>rv` | Extract Variable (Visual Mode)             |
| `<leader>ri` | Inline Variable (Normal & Visual)          |
| `<leader>rB` | Extract Block (Normal Mode)                |

## 🏃 Overseer (Task Runner & Builds)

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `<leader>ow` | Toggle Task Runner window                  |
| `<leader>or` | Run a Build / Task                         |
| `<leader>ol` | Rerun last command                         |
| `<leader>oc` | Close Overseer                             |

## 📝 Neogen (Documentation Generator)

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `<leader>nf` | Auto-generate Function Javadoc / Doxygen   |
| `<leader>nc` | Auto-generate Class Javadoc / Doxygen      |

## 📌 Sticky Headers & UI

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `<leader>tc` | Toggle Sticky Method/Class Header          |

## 🪄 Mini.surround & Mini.ai Cheatsheet

| Key          | Action                                     |
| ------------ | ------------------------------------------ |
| `cs"'`       | Change surrounding double quote to single  |
| `cs]{`       | Change square brackets to curly brackets   |
| `saiw)`      | Surround inner word with parenthesis       |
| `daf`        | Delete around entire function block        |
| `ciq`        | Change inside quote                        |

## Find / Fzf-lua

| Key          | Action                      |
| ------------ | --------------------------- |
| `<leader>ff` | Find files                  |
| `<leader>fg` | Live grep                   |
| `<leader>fw` | Keyword search (live grep)  |
| `<leader>fb` | Find buffers                |
| `<leader>fh` | Find help                   |
| `<leader>fk` | Find keymaps                |
| `<leader>fd` | LSP: find definitions       |
| `<leader>fr` | LSP: find references        |
| `<leader>fi` | LSP: find implementations   |
| `<leader>fs` | LSP: document symbols       |
| `<leader>fp` | Find projects (normal mode) |

## Search / Yank

| Key          | Action                       |
| ------------ | ---------------------------- |
| `<leader>sg` | Live grep using yanked text  |
| `<leader>/`  | Search (/) using yanked text |

## LSP (when attached)

| Key          | Action                                         |
| ------------ | ---------------------------------------------- |
| `gd`         | Go to definition                               |
| `K`          | Hover                                          |
| `rn`         | Rename                                         |
| `ca`         | Code action                                    |
| `gr`         | References                                     |
| `<leader>gd` | Go to definition (fallback without LSP)        |
| `<leader>gf` | Go to file under cursor (fallback without LSP) |

## Debugging (DAP) - Java & C++

| Key          | Action                                         |
| ------------ | ---------------------------------------------- |
| `<leader>db` | Toggle Breakpoint                              |
| `<leader>dc` | Start Debugging / Continue (Resume)            |
| `<leader>do` | Step Over                                      |
| `<leader>di` | Step Into                                      |
| `<leader>du` | Toggle Debug UI (Variables, Watches, Stack)    |
| `<leader>de` | Evaluate expression under cursor               |

## Testing (Neotest)

| Key          | Action                                         |
| ------------ | ---------------------------------------------- |
| `<leader>tr` | Run nearest test                               |
| `<leader>tf` | Run all tests in current file                  |
| `<leader>td` | Debug nearest test (Starts DAP)                |
| `<leader>ts` | Toggle Test Summary Panel                      |

## Formatting

| Key          | Action                                       |
| ------------ | -------------------------------------------- |
| `<leader>fP` | Format entire file with Prettier             |
| `<leader>fp` | Format selection with Prettier (visual mode) |

## Git

| Key          | Action        |
| ------------ | ------------- |
| `<leader>gg` | Open LazyGit  |
| `<leader>gr` | Reset hunk    |
| `<leader>gp` | Preview hunk  |
| `<leader>gs` | Stage hunk    |
| `<C-h>`      | Next git hunk |

## Sessions

| Key          | Action          |
| ------------ | --------------- |
| `<leader>ss` | Save session    |
| `<leader>sl` | Restore session |
| `<leader>sd` | Delete session  |

## Folds (UFO)

| Key  | Action          |
| ---- | --------------- |
| `zR` | Open all folds  |
| `zM` | Close all folds |

## Fzf-lua picker (inside)

| Key               | Action                          |
| ----------------- | ------------------------------- |
| `<C-j>` / `<C-k>`   | Move selection                  |
| `<C-y>`             | Copy selected path to clipboard |
| `F7` (or `Ctrl+s`)  | Open in horizontal split        |
| `F8` (or `Ctrl+v`)  | Open in vertical split          |
| `F9` (or `Ctrl+t`)  | Open in new tab                 |
| `F2`                | Toggle Fullscreen Fzf-lua panel |
| `F4`                | Toggle File Preview panel       |
