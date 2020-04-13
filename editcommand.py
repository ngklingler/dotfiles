import os

term = vim.current.buffer
x = ''
for i in reversed(term):
    if '$' in i:
        x = i
        break
x = x[x.find('$') + 1:].lstrip()
list(map(
    vim.command,
    [
        ':new',
        ':setlocal buftype=nofile',
        ':setlocal bufhidden=unload',
        ':setlocal noswapfile',
        ':autocmd BufLeave <buffer> let g:nvim_term_command = join(getline(1, \'$\'), "\n") | autocmd! BufLeave <buffer>'
    ]
))
vim.feedkeys(vim.replace_termcodes('i' + x))
temp = vim.current.buffer

