brew list -1 | while read line; do brew unlink $line; brew link $line; done