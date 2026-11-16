# The justfile stores all the useful commands for the project
#
# Run `just` with no arguments to list every recipe

# default recipe
[private]
default:
    @just --list --unsorted --justfile {{ justfile() }}

# INFO: ----------------------------------
#         main project development
# ----------------------------------------

# format the whole project via treefmt (`nix fmt`)
[group("core")]
fmt:
    @just bprint "🪄 Formatting..."
    @nix fmt

# run all flake checks (formatting, etc)
[group("core")]
check:
    @just bprint "✅ Running flake checks..."
    @nix flake check

alias f := fmt
alias c := clean

# INFO: ---------------------
#         maintenance
# ---------------------------

# update flake inputs
[group("maintenance")]
update:
    @just print "🆙 Updating flake inputs..."
    @nix flake update

alias u := update

# INFO: --------------
#         util
# --------------------

# clean build artifacts (`just clean pristine` also removes direnv)
[group("util")]
clean level="":
    @just print "🧹 Cleaning project directories... {{ if level == "" { "" } else { "(" + level + ")" } }}"
    @rm -rf result result-* {{ if level == "pristine" { '.direnv' } else { '' } }}

# print a message
[private]
print message:
    @printf '%b\n' "{{ message }}"

# print a message in bold
[private]
bprint message:
    @just print "\x1b[1m{{ message }}\x1b[0m"
