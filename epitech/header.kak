# epitech.kak version 1.0.0
# By Nodyn

try %{ decl str realname %sh{ echo "'$(getent passwd "${SUDO_USER:-$LOGNAME}" | cut -d ":" -f 5 | cut -d "," -f 1)'" } }
try %{ decl str	epitech_login %sh{ echo "${SUDO_USER:-$LOGNAME}@epitech.eu" } }

def	insert-epitech-header -params 0..2 -docstring "insert-epitech-header [<project>]: put an Epitech header at the beginning of the current file for the given project." %{
	%sh{
		prepare_comment_string()
		{
			if [[ -z "$1" ]]; then
				result="  "
			elif (( $(printf %s "$1" | wc -c) > 1 )); then
				result="$1"
			else
				result="$1"
				while (( $(printf %s "$result" | wc -c) <= 1 )); do
					result="$result$(printf %s "$result" | tail -c 1)"
				done
			fi

			sed "s/</<lt>/g" <<< "$result"
		}
		
		# First, let's figure out if we have a project name.
		if [[ -z "$kak_opt_project" ]] && [[ -z "$1" ]]; then
			echo "echo -markup '{Error}The project name wasn\\'t set for this buffer. Please specify one.'"
			exit
		fi

		# Next, we set the variables related to our data.
		[[ -n "$1" ]] && project="$1" || project="$kak_opt_project"
		now=$(date "+%Y")
		description="$2"

		# Once that's done, we can prepare the comment fields.
		if [[ -n "$kak_opt_comment_line" ]] && [[ "$kak_opt_filetype" != "c" ]]; then
			comment_start="$kak_opt_comment_line"
			comment_middle="$kak_opt_comment_line"
			comment_end="$kak_opt_comment_line"
		else
			comment_start="${kak_opt_comment_block%:*}"
			comment_middle=$(printf %s "$comment_start" | tail -c 1)
			comment_end="${kak_opt_comment_block##*:}"
		fi
		comment_start=$(prepare_comment_string "$comment_start")
		comment_middle=$(prepare_comment_string "$comment_middle")
		comment_end=$(prepare_comment_string "$comment_end")

		header="$comment_start<ret>"
		header="$header$comment_middle EPITECH PROJECT, $now<ret>"
		header="$header$comment_middle $project<ret>"
		header="$header$comment_middle File description:<ret>"
		header="$header$comment_middle $description<ret>"
		header="$header$comment_end<ret><ret>"

		echo "exec -no-hooks -draft 'ggi$header<esc>'"
		echo "echo ''"
	}    
}

def	update-epitech-header -hidden %{
	try %{
		%sh{
			now=$(date "+%a %b %e %T %Y")
			echo "exec -no-hooks -draft '%sLast update .{3} .{3} {1,2}\d{1,2} \d{1,2}:\d{1,2}:\d{1,2} \d{4} .*?$<ret>cLast update $now $kak_opt_realname<esc>;'"
			echo "echo ''"
		}
	}
}

hook -group epitech global BufWritePre .* %{ update-epitech-header }
