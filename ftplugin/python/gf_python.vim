" Copyright 2011 Michael Komitee. All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" 1. Redistributions of source code must retain the above copyright notice,
" this list of conditions and the following disclaimer.
"
" 2. Redistributions in binary form must reproduce the above copyright
" notice, this list of conditions and the following disclaimer in the
" documentation and/or other materials provided with the distribution.
"
" THIS SOFTWARE IS PROVIDED BY MICHAEL KOMITEE ``AS IS'' AND ANY EXPRESS OR
" IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
" OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
" NO EVENT SHALL MICHAEl KOMITEE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
" INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
" LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
" OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
" DAMAGE.
"
" The views and conclusions contained in the software and documentation are
" those of the authors and should not be interpreted as representing official
" policies, either expressed or implied, of Michael Komitee.

if exists("g:loaded_gf_python")
    finish
else
    let g:loaded_gf_python = 1
endif

if !has('python')
    echoerr "Error: the gf_python.vim plugin requires Vim to be compiled with +python"
    finish
endif

python << EOF
import vim
import sys
import re
import glob
import os

def find_in_path(module, path_group):
    for path in path_group:
        d = os.path.join(path, module)
        if os.path.isdir(d):
            f = os.path.join(d, '__init__.py')
            if os.path.isfile(f):
                vim.command('split %s' % f)
                return True
        g = os.path.join(path, '%s.py*' % module )
        for f in glob.iglob(g):
            vim.command('split %s' % f)
            return True

    return False


def python_goto_file():
    cw = vim.eval('expand("<cfile>")')
    module = re.sub('\.', '/', cw)

    # look in vim's path first and if not found, look in sys.path
    path_groups = [
        vim.eval('&path').split(','),
        sys.path,
    ]

    for path_group in path_groups:
        found = find_in_path(module, path_group)
        if found == True:
            return

    print >> sys.stderr, 'E447: Can\'t find file "%s"' % cw

EOF

map gf :python python_goto_file()<cr>

