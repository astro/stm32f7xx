#! /bin/sh
d="$(dirname "$0")"
for i in "$d/svd"/*; do
	case "$i" in
	*.svd)
		b="$(basename "$i" .svd)"
		l="$(printf "%s" "$b" | tr '[:upper:]' '[:lower:]')"
		if ! [ -e "$l" ] ; then
			cargo new "$d/$l"
			sed -i "$d/$l/Cargo.toml" \
				-e '/version/r crate.txt' \
				-e '/\[dependencies\]/r deps.txt'
			sed -i "$d/$l/Cargo.toml" \
				-e 's/@NAME@/'$b'/g'
		fi
		svd2rust -i "$i" | rustfmt >"$d/$l/src/lib.rs"
		;;
	*)	2>&1 echo "skipping $i"
	esac
done
