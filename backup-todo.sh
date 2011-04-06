#!/bin/sh

TODOTXT_CFG_FILE=${TODOTXT_CFG_FILE:-$HOME/bin/todo.cfg}

[ -r "$TODOTXT_CFG_FILE" ] || die "Fatal error: Cannot read configuration file $TODOTXT_CFG_FILE"

. "$TODOTXT_CFG_FILE"
[ -d "$TODO_DIR" ]  || die "Fatal Error: $TODO_DIR is not a directory"

TODOTXT_BACKUP_DIR=$TODO_DIR/backups
if [ ! -d "$TODOTXT_BACKUP_DIR" ]; then
    mkdir "$TODOTXT_BACKUP_DIR"
fi

cd "$TODOTXT_BACKUP_DIR"
tar -zcvf todo-`date '+%Y-%m-%d'`.tar.gz "$TODO_DIR"
tar -zcvf script-`date '+%Y-%m-%d'`.tar.gz "$HOME/bin"
# tar -zcvf script2-`date '+%Y-%m-%d'`.tar.gz "$TODO_ACTIONS_DIR"
