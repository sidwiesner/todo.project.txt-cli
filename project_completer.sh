# PROJECT.sh completion Sid Wiesner. This is copied heavily from
# the todo.sh completion by Pedro Melo <melo@simplicidade.org>
# 

PROJECTS_DIR=~/.todo/projects

seq_replacement()
{ 
    local lower upper output;
    lower=$1 upper=$2;
    while [ $lower -le $upper ];
    do
        output="$output $lower";
        lower=$[ $lower + 1 ];
    done;
    echo $output
}

_project_sh()
{
  local cur prev commands options command expand_options

  long_commands='add append clean cleanup del done edit help list listall next overview \
        prepend replace rm update'
  short_commands='a app ls la n over prep up'
  options="-a -c -f -h -p -q -v -V"

  if [ -n "$PROJECTSH_DONT_COMPLETE_SHORT_COMMANDS" ] ; then
    commands=$long_commands
  else
    commands="$long_commands $short_commands"
  fi

  if [ -n "$PROJECTSH_OTHER_COMMANDS" ] ; then
    commands="$commands $PROJECTSH_OTHER_COMMANDS"
  fi

  TODOSHRC=$HOME/bin/todo.cfg
  # PROJECTSHRC=${PROJECTSHRC:-$HOME/bin/PROJECT.cfg}
  if [[ -r $TODOSHRC ]] ; then
    . $TODOSHRC
  fi

  if [[ ! -r $TODO_FILE ]] ; then
    echo "ERROR: cannot read todo.txt file."
    echo "Make sure TODOSHRC is set with the correct .todo config file";
    return 0
  fi

  expand_options=1
  command=""
  up_to=$(($COMP_CWORD-1))
  for i in `seq_replacement 1 $up_to` ; do
    cur=${COMP_WORDS[i]}
    if [[ "${cur}" != -* ]] ; then
      expand_options=0
      if [[ -z "${command}" ]] ; then
        command=${cur}
      fi
    fi
  done

  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  if [[ ${expand_options} == 1 && ${cur} == -* ]] ; then
      COMPREPLY=( $( compgen -W "$options" -- $cur ) )
  elif [[ -z "${command}" ]] ; then
      COMPREPLY=( $( compgen -W "$commands" -- $cur ) )
  else
    case "${command}" in
      add|a|append|app|clean|cleanup|del|edit|rm|done|list|ls|next|n|prepend|prep|replace|repl|update|up)
        local projects=$(ls -la $PROJECTS_DIR/*.txt | sed 's/.*\///' | sed 's/\.txt//')
        COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
        return 0
        ;;

      *)
        ;;
    esac
  fi

  return 0
}

complete -F _project_sh -o default project.sh 
