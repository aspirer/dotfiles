#!/bin/bash
while getopts "i:l:p:" opt
do
        case $opt in
                l)user=$OPTARG;;
                p)port=$OPTARG;;
        esac
done
argNum=$#
list=`echo $* | awk '{print $NF}'`

starttmux() {
    local j=0
    for host in `cat $list`
    do
        echo "$host"
        hosts[$j]=$host
        ((j++))
    done
    [ $argNum -eq 1 ] && SSHCMD="ssh " || SSHCMD="ssh  -l $user -p $port "
    tmux new-window -a -n "new_window"  "$SSHCMD${hosts[0]}"
    unset hosts[0];
    for i in "${hosts[@]}"; do
        tmux split-window -t :"new_window" -h  "$SSHCMD $i" >> /dev/null
        tmux select-layout -t :"new_window" tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option -t :"new_window"  synchronize-panes on > /dev/null
    tmux set synchronize-panes on
}

starttmux
