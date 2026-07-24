# Neovim shortcuts (leader = Space)

## General


| Key         | Action                     |
| ----------- | -------------------------- |
| `e`         | Toggle Neo-tree Explorer   |
| `<leader>e` | Neo-tree filesystem toggle |
| `<leader>w` | Cycle windows              |
| `ad`        | Open dashboard (Alpha)     |


## Cursor CLI (Cursor Agent)


| Key          | Action                                    |
| ------------ | ----------------------------------------- |
| `<leader>co` | Toggle Cursor Agent terminal              |
| `<leader>cf` | Focus Cursor Agent terminal               |
| `<leader>cp` | Prompt-and-send to agent                  |
| `<leader>cs` | Send buffer (normal) / selection (visual) |
| `<leader>c>` | Increase Cursor Agent panel width         |
| `<leader>c<` | Decrease Cursor Agent panel width         |


## Find / Telescope


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


## Files under cursor


| Key         | Action                                           |
| ----------- | ------------------------------------------------ |
| `<leader>d` | Open file under cursor (gf + Telescope fallback) |


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


## Telescope picker (inside)


| Key               | Action                          |
| ----------------- | ------------------------------- |
| `<C-j>` / `<C-k>` | Move selection                  |
| `<C-y>`           | Copy selected path to clipboard |
| `<C-p>`           | Paste yank into prompt          |


