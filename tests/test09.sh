#! /usr/bin/env dash

# ==============================================================================
# Test on slippy append, insert and change commands
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
91
92
93
i wanna sleep
94
95
96
97
98
99
EOF
seq 91 99 | slippy '3a i wanna sleep' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
i wanna sleep
91
92
93
94
95
96
97
98
99
EOF
seq 91 99 | slippy '1i i wanna sleep'  > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
5
6
1 2 3 4 5
8
9
EOF
seq 5 9 | slippy '3c 1 2 3 4 5' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
210
211
212
213
214
215
216
217
218
219
220
221
1 2 3 4 5 test iadf cdsa
223
224
225
226
227
228
229
230
EOF
seq 210 230 | slippy '13c 1 2 3 4 5 test iadf cdsa' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
