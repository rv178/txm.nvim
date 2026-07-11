# txm.nvim

Simple terminal latex preview plugin using txm. Select text using visual mode and preview it in a scratchpad buffer.
Requires installing [txm](https://github.com/thatmagicalcat/txm).

## Installation

### Packer

```
use "rv178/txm.nvim"
```

### Set a keybind

```lua
vim.keymap.set({'n', 'v'}, '<leader>tx', '<Plug>(TxmPreview)')
```

