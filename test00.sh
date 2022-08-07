#! /usr/bin/env dash

# ==============================================================================
# Test on slippy quit command
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

# 3q
cat > "$expected_output" <<EOF
1
2
3
EOF
seq 1 5 | slippy 3q > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

# '/.1/q'
cat > "$expected_output" <<EOF
7
8
9
10
11
EOF
seq 7 14 | slippy '/.1/q' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

# '/2{2}/q'
cat > "$expected_output" <<EOF
10
11
12
13
14
15
16
17
18
19
20
21
22
EOF
seq 10 30 | slippy '/2{2}/q' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

# '/^.+7$/q'
cat > "$expected_output" <<EOF
10
11
12
13
14
15
16
17
EOF
seq 10 30 | slippy '/^.+7$/q' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
