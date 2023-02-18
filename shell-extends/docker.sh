
dockera() {
    containers=()
    while read -r each;
    do
        container_name=`echo "$each" | awk '{print $NF}'`
        containers+=($container_name)
    done <  <(docker ps | tail -n +2)

    if [ "${#containers[@]}"x = "0"x ];then
        printWarnMsg "Not container is running!"
        return
    fi

    i=0
    printInfoMsg "Please select the container you want to attach:"
    for c in ${containers[@]}
    do
        echo "${i}. $c"
        let i+=1
    done
    read select
    if [ $select -ge ${#containers[@]} ] ||
        [ $select -lt 0 ];then
        printErrorMsg "The enter number:\'$select\' is Invalid!"
        return
    fi
    printInfoMsg "select:${containers[$select]}"
    docker attach "${containers[$select]}"
}

