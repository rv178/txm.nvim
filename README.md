# txm.nvim

LaTeX preview inside NeoVim using [txm](https://github.com/thatmagicalcat/txm).

## Features

Supports the following commands:

- `:TxmRender`: Takes the whole buffer and renders a LaTeX preview as virtual text.
- `:TxmClear`: Clears the LaTeX preview inside the buffer.
- `:TxmToggle`: Toggle the preview on/off.

- `<Plug>(TxmPreview)`: Select text using visual mode and preview it in a scratchpad buffer.

## Installation

### Packer

```
use "rv178/txm.nvim"
```

### Set keybinds

```lua
vim.keymap.set({'v'}, '<leader>tx', '<Plug>(TxmPreview)')
vim.keymap.set({'n', 'v'}, '<leader>tt', ':TxmToggle')
```

## Example

https://github.com/user-attachments/assets/51ded380-0f24-4953-8071-d75c94340381
