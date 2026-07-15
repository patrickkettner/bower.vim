## About

[Bower.vim] is a way to install browser components in [Vim] using [Bower].

```
:Bower install jquery --save
```

Every bower command works, subcommands tab-complete, and everything runs from
your project's root, no matter how deeply nested the file you are editing is.

## Quick start

Bower itself needs to be installed

```sh
npm install -g bower
```

then install the plugin with your plugin manager of choice

#### vim packages (vim 8+)

```sh
git clone https://github.com/patrickkettner/bower.vim ~/.vim/pack/plugins/start/bower.vim
```

#### [pathogen]

```sh
git clone https://github.com/patrickkettner/bower.vim ~/.vim/bundle/bower.vim
```

(for the native packages and pathogen installs, run `:helptags ALL` once so `:help bower` works)

#### [vim-plug]

```vim
Plug 'patrickkettner/bower.vim'
```

#### [vundle]

```vim
Plugin 'patrickkettner/bower.vim'
```

## Usage

```
:Bower install <package>   install a component (--save et al work as expected)
:Bower search <term>       search the registry
:Bower update              update your components
:Bower <anything>          anything bower's CLI accepts
```

`:Bower` runs from the project root, found by walking up from the current
file for a `bower.json`, `.bowerrc`, `bower_components/` directory, or a VCS
root. The executable and the root detection are both configurable, see the
full docs

```
:help bower
```

## Inspiration and ideas from

* [vundle]
* [vim-rooter]
* [Steve Losh](http://github.com/sjl)

[Bower.vim]:http://github.com/patrickkettner/bower.vim
[Bower]:https://bower.io
[Vim]:http://www.vim.org
[pathogen]:https://github.com/tpope/vim-pathogen
[vim-plug]:https://github.com/junegunn/vim-plug
[vim-rooter]:https://github.com/airblade/vim-rooter
[vundle]:https://github.com/VundleVim/Vundle.vim
