#! /usr/bin/env dash

# ==============================================================================
# Test on slippy print command
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
1
2
3
3
4
5
EOF
seq 1 5 | slippy 3p > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

# '/.1/q'
cat > "$expected_output" <<EOF
7
8
9
10
11
11
12
13
14
EOF
seq 7 14 | slippy '/.1/p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

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
22
23
24
25
26
27
28
29
30
EOF
seq 10 30 | slippy '/2{2}/p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
10
11
12
13
14
15
16
17
17
18
19
20
21
22
23
24
25
26
27
27
28
29
30
EOF
seq 10 30 | slippy '/^.+7$/p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
