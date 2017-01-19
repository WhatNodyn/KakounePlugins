decl str	project

def		guess-project %{
    %sh{
    	# If the project name is already set, then we have nothing to do.
    	if [[ -z "$kak_opt_project" ]]; then
    		# If we're in an unsaved buffer, guess from current working directory.
    		# Otherwise, take the buffer's directory.
    		if [[ "$kak_buffile" == "$kak_bufname" ]]; then
    			directory=$PWD
    		else
    			directory=$(dirname "$kak_buffile")
    		fi

    		# If git is installed, we'll try to get something from that.
    		if (which git > /dev/null 2>&1); then
    			project=$(git -C "$directory" rev-parse --show-toplevel 2> /dev/null)
    			project=$(basename "$project")
    		fi

    		# If not, or if we're not in a git repository, take the folder name.
    		if [[ -z "$project" ]]; then
    			project=$(basename "$directory")
    		fi
    		echo "set buffer project '$project'" 
    	fi

    	echo "echo \"The project name was set to \\\"%opt{project}\\\"\""
    }
}

hook -group project global BufCreate .* %{ guess-project }
