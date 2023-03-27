upload()
{
	changelog="$*"
	if [[ -z $* ]] then
		changelog="Commit $(git rev-parse HEAD)"
	fi

	echo -e "Changelog message: $changelog\nContinue? (ctrl+C to abort)"
	read

	gmad create -folder . -out $gma_file
	[[ $? == 0 ]] || exit 1

	[[ ! -f ./$gma_file ]] && echo "File $gma_file does not exist! Aborting." && exit 2

	gmpublish update -id $addon_id -addon $gma_file -changes "$changelog"
	[[ $? == 0 ]] && rm $gma_file
}