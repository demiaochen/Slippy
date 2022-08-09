#! /usr/bin/env dash

# ==============================================================================
# Test on slippy substitute command s
#       worthing note that 's/ //g' was not tested in autotest
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
seq 1 10 | slippy 's/[1357]/cccdm/' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
asdfdssdafdssdafds22323
EOF
echo "asdfds sdafds sdafds 223 23" | slippy 's/ //g' > "$actual_output" 2>&1
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
seq 10 30 | slippy '5s/1/ll/g'> "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
2+0
2++
2+2
2+3
2+4
2+5
2+6
2+7
2+8
2+9
220
22+
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
seq 210 230 | slippy '/2../s/1/+/g' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
