# epitech.kak version 1.0.0
# By Nodyn

try %{ decl str realname %sh{ echo "'$(getent passwd "${SUDO_USER:-$LOGNAME}" | cut -d ":" -f 5 | cut -d "," -f 1)'" } }
try %{ decl str	epitech_login %sh{ echo "${SUDO_USER:-$LOGNAME}@epitech.eu" } }

def	insert-epitech-header -params 0..1 -docstring "insert-epitech-header [<project>]: put an Epitech header at the beginning of the current file for the given project." %{
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
			echo "echo -color Error 'The project name wasn\\'t set for this buffer. Please specify one.'"
			exit
		fi

		# Next, we set the variables related to our data.
		[[ -n "$1" ]] && project="$1" || project="$kak_opt_project"
		now=$(date "+%a %b %e %T %Y")
		file=$(basename "$kak_buffile")
		[[ "$kak_buffile" == "$kak_bufname" ]] && directory="nowhere" || directory=$(dirname "$kak_buffile")

		# Once that's done, we can prepare the comment fields.
		if [[ -n "$kak_opt_comment_line_chars" ]] && [[ "$kak_opt_filetype" != "c" ]]; then
			comment_start="$kak_opt_comment_line_chars"
			comment_middle="$kak_opt_comment_line_chars"
			comment_end="$kak_opt_comment_line_chars"
		else
			comment_start="${kak_opt_comment_selection_chars%:*}"
			comment_middle=$(printf %s "$comment_start" | tail -c 1)
			comment_end="${kak_opt_comment_selection_chars##*:}"
		fi
		comment_start=$(prepare_comment_string "$comment_start")
		comment_middle=$(prepare_comment_string "$comment_middle")
		comment_end=$(prepare_comment_string "$comment_end")

		header="$comment_start<ret>"
		header="$header$comment_middle $file for $project in $directory<ret>"
		header="$header$comment_middle <ret>"
		header="$header$comment_middle Made by $kak_opt_realname<ret>"
		header="$header$comment_middle Login   <lt>$kak_opt_epitech_login><ret>"
		header="$header$comment_middle <ret>"
		header="$header$comment_middle Started on  $now $kak_opt_realname<ret>"
		header="$header$comment_middle Last update $now $kak_opt_realname<ret>"
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
