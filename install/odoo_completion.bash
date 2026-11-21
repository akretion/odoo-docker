# bash completion for odoo and click-odoo: commands, options, modules, databases

declare -gA _ODOO_OPTIONS

_odoo_modules() {
    if [ -z "${_ODOO_MODULES:-}" ]; then
        local dir manifest
        local -a dirs
        IFS="," read -ra dirs <<< "${ADDONS_PATH:-}"
        for dir in "${dirs[@]}"; do
            for manifest in "$dir"/*/__manifest__.py; do
                [ -f "$manifest" ] || continue
                manifest="${manifest%/__manifest__.py}"
                _ODOO_MODULES+="${manifest##*/} "
            done
        done
    fi
    printf "%s" "$_ODOO_MODULES"
}

_odoo_options() {
    # $1: executable, other args: subcommand
    local key="$*"
    if [ -z "${_ODOO_OPTIONS[$key]:-}" ]; then
        _ODOO_OPTIONS[$key]=$("$@" --help 2>/dev/null \
            | grep -E -- "^\s+-" \
            | grep -oE -- "(^|[ ,])--?[a-zA-Z0-9][a-zA-Z0-9_-]*" \
            | tr -d " ," | sort -u | tr "\n" " ")
    fi
    printf "%s" "${_ODOO_OPTIONS[$key]}"
}

_odoo_commands() {
    if [ -z "${_ODOO_COMMANDS:-}" ]; then
        _ODOO_COMMANDS=$(odoo help 2>/dev/null \
            | awk "/^    [a-z]/ {print \$1}" | tr "\n" " ")
    fi
    printf "%s" "$_ODOO_COMMANDS"
}

_odoo_databases() {
    psql -Atqc "SELECT datname FROM pg_database WHERE NOT datistemplate" 2>/dev/null
}

_odoo() {
    local cmd="$1"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMPREPLY=()

    case "$prev" in
        -i|--init|-u|--update|-m|--modules|--ignore-addons|--ignore-core-addons)
            # comma separated list: complete the last item only
            local prefix=""
            [[ "$cur" == *,* ]] && prefix="${cur%,*},"
            COMPREPLY=($(compgen -P "$prefix" -W "$(_odoo_modules)" -- "${cur##*,}"))
            return
            ;;
        -d|--database)
            COMPREPLY=($(compgen -W "$(_odoo_databases)" -- "$cur"))
            return
            ;;
        -c|--config|--logfile|--pidfile|--data-dir|-D|--test-file|--i18n-export|--i18n-import)
            compopt -o filenames 2>/dev/null
            COMPREPLY=($(compgen -f -- "$cur"))
            return
            ;;
    esac

    if [[ "$cur" == -* ]]; then
        case "$cmd" in
            odoo|odoo-bin)
                local sub="server"
                [ "$COMP_CWORD" -gt 1 ] && [[ "${COMP_WORDS[1]}" != -* ]] && sub="${COMP_WORDS[1]}"
                COMPREPLY=($(compgen -W "$(_odoo_options "$cmd" "$sub")" -- "$cur"))
                ;;
            *)
                COMPREPLY=($(compgen -W "$(_odoo_options "$cmd")" -- "$cur"))
                ;;
        esac
        return
    fi

    # positional arguments
    case "$cmd" in
        odoo|odoo-bin)
            [ "$COMP_CWORD" -eq 1 ] && COMPREPLY=($(compgen -W "$(_odoo_commands)" -- "$cur"))
            ;;
        click-odoo-dropdb|click-odoo-copydb)
            COMPREPLY=($(compgen -W "$(_odoo_databases)" -- "$cur"))
            ;;
        click-odoo-backupdb)
            compopt -o filenames 2>/dev/null
            COMPREPLY=($(compgen -W "$(_odoo_databases)" -- "$cur") $(compgen -f -- "$cur"))
            ;;
        click-odoo|click-odoo-restoredb)
            compopt -o filenames 2>/dev/null
            COMPREPLY=($(compgen -f -- "$cur"))
            ;;
    esac
}

complete -F _odoo odoo odoo-bin click-odoo click-odoo-update click-odoo-initdb \
    click-odoo-uninstall click-odoo-dropdb click-odoo-copydb click-odoo-backupdb \
    click-odoo-restoredb click-odoo-listdb click-odoo-makepot
