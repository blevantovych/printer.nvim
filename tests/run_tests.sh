for test_file in *.lua
do
    filename="${test_file%.*}"
    input_file="$filename.js"
    nvim "$input_file" --headless -c "PlenaryBustedFile $test_file"
done
