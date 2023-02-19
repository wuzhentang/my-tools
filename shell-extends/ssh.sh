function setup_ssh_agent() {
    if [ ! -x $(command -v ssh-add) ] ; then
        printErrorMsg "ssh-add is not available; ssh agent initialize failed!"
        return 1
    fi

    if [ -S "$SSH_AUTH_SOCK" ] &&
        [[ "$SSH_AUTH_SOCK" != */Listeners ]]; then
        printInfoMsg "SSH_AUTH_SOCK is already set:$SSH_AUTH_SOCK"
        return 0
    fi

    local is_found=false
    local ssh_sock_dir=""
    if [ $OS = Mac ]; then
        for pid in `pidof ssh-agent`
        do
            if [ -n "$ssh_sock_dir" ];then
                break;
            fi

            if [ -z $pid ];then
                continue;
            fi

            while read -r each_unix;
            do
                if [ -z "$each_unix" ];then
                    continue;
                fi
                ssh_agent_path=`echo $each_unix | awk '{ print $8}'`
                # echo "ssh_agent_path:$ssh_agent_path"
                if [ -z "$ssh_agent_path" ];then
                    continue;
                fi
                ssh_agent_dir=`dirname "$ssh_agent_path"`
                # echo "ssh_agent_dir:$ssh_agent_dir"
                if [ -n "$ssh_agent_dir" ] && [ -d "$ssh_agent_dir" ];then
                    ssh_sock_dir=$(cd "$ssh_agent_dir"; cd .. ; pwd)
                    echo "found the ssh socket directory:$ssh_sock_dir"
                    break;
                else
                    printWarnMsg "invalid ssh_agent_dir:$ssh_agent_dir"
                fi
            done <<< "`lsof -p $pid | grep -i "unix" | grep -v "Listeners"`"

        done
    elif [ "$(uname)" = "Linux" ]; then
        ssh_sock_dir="/tmp/"
    else
        printErrorMsg "`uanme` platform is not support!"
        return 1
    fi

    for agent_sock in `find "$ssh_sock_dir" -uid $(id -u) -type s -name agent.\* 2>/dev/null`;
    do
        # printDebugMsg "Begin to test:$agent_sock"
        if [ -S "$agent_sock" ];then
            SSH_AUTH_SOCK="$agent_sock" ssh-add -l &>/dev/null
            if [ "$?" = 0 ]; then
                # agent is found and have key installed
                is_found=true
                export SSH_AUTH_SOCK="$agent_sock"
                break;
            elif [ "$?" = 1 ]; then
                # agent is found but have not installed key
                is_found=true
                export SSH_AUTH_SOCK="$agent_sock"
            fi
        fi
    done

    if [ "$is_found" = "false" ];then
        printWarnMsg "Not ssh auth socket is found in: $ssh_sock_dir, start a new one"
        eval "$(ssh-agent -s)"
    fi

    # ssh-add -l
}

function add_ssh_key() {
    ssh-add -l &>/dev/null
    if [ "$?" = 0 ]; then
        printInfoMsg "already have ssh-key add to agent!"
        ssh-add -l
        return 0
    elif [ "$?" = 2 ];then
        printErrorMsg "ssh-add connect to ssh agent failed! Please make sure agent is running"
        return 1
    fi

    # ssh-add return 1, going here to add key
    if [ ! -z "$@" ];then
        # echo "@:$@"
        key_files=("$@")
    else # [ -z "$key_files" ];then
        key_files=()
        while IFS=  read -r -d $'\0' f;
        do
            # echo "f:$f"
            key_files+=("$f")
        done < <(find ~/.ssh/ -type f ! -name known_hosts ! -name "*.pub" ! -name authorized_keys ! -name config -print0)
    fi

    # echo "ssh key files:$key_files"
    for key in ${key_files[@]}
    do
        # echo "key:$key"
        if [ -r "$key" ];then
            ssh-add "$key"
        else
            echo "Invalid ssh key file:$key"
        fi
    done

    printInfoMsg "ssh keys have installed:"
    ssh-add -l
}

setup_ssh_agent
add_ssh_key "$@"

