## Generate pot file

   $ ninja com.bitstower.Markets-pot

## Generate po files

  $ ninja com.bitstower.Markets-update-po

## Test localization

  $ LC_ALL=pl_PL.utf8 bitstower-markets

## Import translations from Weblate

1. Go to Weblate Dashboard
1. Commit changes
1. Lock the repository
1. Go to Github
1. Merge newly created PR
1. Go to Weblate Dashboard
1. Unlock the repository
