# Zachiah's Configuration Files

Got this idea from [here](https://www.atlassian.com/git/tutorials/dotfiles).

To add a new machine simply:
- `git clone --bare git@github.com:Zachiah/config.git $HOME/.cfg`
- restart the shell
- `config checkout` if there are issues checking out then remove the offending files and then run it again.
- `config config --local status.showUntrackedFiles no`
- Install homebrew
- `brew bundle --file=Brewfile`
- Install volta

