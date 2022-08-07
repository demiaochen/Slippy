#! /usr/bin/env dash

# ==============================================================================
# Test on slippy print with -n
# Date: 08-Aug-2022
# Written by: Demiao Chen
# ==============================================================================


# ==============================================================================
# Test structure written by: Dylan Brotherston <d.brotherston@unsw.edu.au>
#
# add the current directory to the PATH so scripts
# can still be executed from it after we cd
PATH="$PATH:$(pwd)"
# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1
# Create some files to hold output.
expected_output="$(mktemp)"
actual_output="$(mktemp)"
# Remove the temporary directory when the test is done.
trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT
# ==============================================================================

# helper functions
test_diff() {
    if ! diff "$1" "$2"; then
        echo "Failed test"
        exit 1
    fi
}

################################ Tests ################################ 

cat > "$expected_output" <<EOF
8
EOF
seq 1 10 | slippy -n '8p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
11
21
31
41
51
61
71
81
91
EOF
seq 2 100 | slippy -n '/1$/p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
330
331
332
333
334
335
336
337
338
339
EOF
seq 320 390 | slippy -n '/^33/p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
321
328
331
338
341
348
351
358
361
368
371
378
380
381
382
383
384
385
386
387
388
389
EOF
seq 320 390 | slippy -n '/[18]/p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
