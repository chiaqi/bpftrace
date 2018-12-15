#/usr/bin/env bash

# copy this file to the bpftrace's executable folder and run 'source auto.sh' to activate

_words_complete()
{
    local cur prev result opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-l -e -p -v -d -dd"
    probes="kprobe kretprobe uprobe uretprobe tracepoint ustd profile interval software hardware"

    local no_quote_cur=$(echo "${cur}" | sed 's/\x27//g')

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    elif [[ ${cur} =~ kprobe* ]] ; then
        local result=$(sudo bpftrace -l | grep "${no_quote_cur}")
        COMPREPLY=( $(compgen -W "${result}" -- ${cur}) )
        return 0
    elif [[ ${cur} =~ tracepoint* ]] ; then
        local result=$(sudo bpftrace -l "tracepoint:*" | grep "${no_quote_cur}")
        COMPREPLY=( $(compgen -W "${result}" -- ${cur}) )
        return 0
    else
        COMPREPLY=( $(compgen -W "${probes}" -- ${cur}) )
        return 0
    fi
}
complete -o nospace -o noquote -F _words_complete bpftrace
