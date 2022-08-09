#! /usr/bin/env dash

# ==============================================================================
# Test on slippy addresses
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
100
EOF
seq 1 3 100 | slippy -n '$p' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
1
4
7
25
28
31
34
37
40
43
46
49
52
55
58
61
64
67
70
73
76
79
82
85
88
91
94
97
100
103
106
109
112
115
118
121
124
127
130
133
136
139
142
145
148
151
154
157
160
163
166
169
172
175
178
181
184
187
190
193
196
199
202
205
208
211
214
217
220
223
226
229
232
235
238
241
244
247
250
253
256
259
262
265
268
271
274
277
280
283
286
289
292
295
298
EOF
seq 1 3 300 | slippy '4,/2/d' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
10
12
94
96
18
20
22
94
96
28
30
32
34
36
38
40
49
44
46
48
50
59
54
56
58
60
62
64
66
68
70
72
74
76
78
80
82
84
86
88
90
EOF
seq 10 2 90 | slippy '/4/,/6/s/[12]/9/'> "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

cat > "$expected_output" <<EOF
210
211
214
215
216
217
218
219
220
221
224
225
226
227
228
229
230
EOF
seq 210 230 | slippy '/2$/,/^2/d' > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
