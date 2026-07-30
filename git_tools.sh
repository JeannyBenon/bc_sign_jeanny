#!/bin/bash

delete_commit() {
    local commit_hash="$1"

    if [ -z "$commit_hash" ]; then
        echo "Erreur : vous devez fournir le hash du commit a supprimer."
        echo "Usage : delete_commit <hash>"
        return 1
    fi

    if ! git cat-file -e "${commit_hash}^{commit}" 2>/dev/null; then
        echo "Erreur : le commit introuvable."
        return 1
    fi

    echo "Suppression du commit $commit_hash..."
    git rebase --onto "${commit_hash}^" "${commit_hash}"

    if [ $? -eq 0 ]; then
        echo "Le commit a ete supprime avec succes."
    else
        echo "Le rebase a echoue (probablement un conflit)."
        echo "Resolvez les conflits puis lancez : git rebase --continue"
        return 1
    fi
}

merge_commits() {
    local old_commit="$1"
    local recent_commit="$2"

    if [ -z "$old_commit" ] || [ -z "$recent_commit" ]; then
        echo "Erreur : vous devez fournir deux hash de commits."
        echo "Usage : merge_commits <hash_ancien> <hash_recent>"
        return 1
    fi

    for h in "$old_commit" "$recent_commit"; do
        if ! git cat-file -e "${h}^{commit}" 2>/dev/null; then
            echo "Erreur : le commit introuvable."
            return 1
        fi
    done

    local short_hash="${recent_commit:0:7}"
    local editor_script
    editor_script=$(mktemp)

    echo "#!/bin/bash" > "$editor_script"
    echo "sed -i \"s/^pick $short_hash/squash $short_hash/\" \"\$1\"" >> "$editor_script"
    chmod +x "$editor_script"

    echo "Fusion du commit $recent_commit dans $old_commit..."
    GIT_SEQUENCE_EDITOR="$editor_script" git rebase -i "${old_commit}^"
    local result=$?
    rm -f "$editor_script"

    if [ $result -eq 0 ]; then
        echo "Les commits ont ete fusionnes avec succes."
    else
        echo "Le rebase a echoue (probablement un conflit)."
        echo "Resolvez les conflits puis lancez : git rebase --continue"
        return 1
    fi
}
