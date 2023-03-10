#!/bin/bash

repository="https://github.com/atoscerebro/fg-terraform"
docs="README.md"
root="modules"
branch="master"

get_sub_directories () {
    local directory=$1

    echo $(find $directory -mindepth 1 -maxdepth 1 -type d | sort)
}

get_module_links() {
    local modules_directory=$1
    local repository=$2
    local branch=$3

    links=""
    providers=($(get_sub_directories $modules_directory))
    provider_count=${#providers[@]}

    for pi in ${!providers[@]}; do
        provider=$(basename ${providers[pi]})
        modules=($(get_sub_directories ${providers[pi]}))
        module_count=${#modules[@]}

        if (($module_count > 0)); then
            links="${links}### ${provider}\n\n"
        fi

        for mi in ${!modules[@]}; do
            module=$(basename ${modules[mi]})
            link="$repository/tree/$branch/$modules_directory/$provider/$module"
            links="${links}- [$module]($link)"
            if [[ $mi != $(($module_count - 1)) ]]; then
                links="${links}\n"
            fi
        done

        if [[ $pi != $(($provider_count - 1)) ]]; then
            links="${links}\n\n"
        fi
    done
    
    echo "$links"
}

replace_module_links () {
    local file=$1
    local links=$2

    begin_links="<!-- BEGIN_MODULE_LINKS -->"
    end_links="<!-- END_MODULE_LINKS -->"
    target="$begin_links((.|\n)*)$end_links"
    replacement="$begin_links\n$links\n$end_links"
    echo "$(cat $file | perl -0777 -pe "s'$target'$replacement'g")"
}

if [[ $1 == "" ]]; then
    echo 'No target file argument was provided.'
    exit 1
fi

echo -e "$(replace_module_links $docs "$(get_module_links $root $repository $branch)")" > $1