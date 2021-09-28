## Generate pot file

    $ ninja com.bitstower.Markets-pot

## Generate po files

    $ ninja com.bitstower.Markets-update-po

## Test localization

    $ LC_ALL=pl_PL.utf8 bitstower-markets

## Import translations from Weblate

1. Create and activate the virutal enviorment for Python3.
1. Install the Weblate command.
   
       pip install wlc
1. Configure the Webplate command in `~/.config/weblate`
1. Commit all pending changes in Weblate and lock the translation component.

       wlc commit; wlc lock
1. Add Weblate exported repository as a remote.

       git remote add weblate https://hosted.weblate.org/git/markets/markets/ ; git remote update weblate
1. Merge Weblate changes and resolve any conflicts.

       git merge weblate/master
1. Update `./po/LINGUAS` if needed.
1. Push changes into upstream repository.

       git push origin master
1. Weblate should now be able to see updated repository and you can unlock it.

       wlc pull ; wlc unlock

