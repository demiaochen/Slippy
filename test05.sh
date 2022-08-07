#! /usr/bin/env dash

# ==============================================================================
# Test on slippy substitute command s with other delimiters
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
cccdm
2
cccdm
4
cccdm
6
cccdm
8
9
cccdm0
EOF
seq 1 10 | slippy 's?[1357]?cccdm?' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
asdfdssdafdssdafds22323
EOF
echo "asdfds sdafds sdafds 223 23" | slippy 's| ||g' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
10
11
12
13
ll4
15
16
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
28
29
30
EOF
seq 10 30 | slippy '5s_1_ll_g'> "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
2ll0
2llll
2ll2
2ll3
2ll4
2ll5
2ll6
2ll7
2ll8
2ll9
220
22ll
222
223
224
225
226
227
228
229
230
EOF
seq 210 230 | slippy 'sS1SllSg' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
