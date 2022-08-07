#! /usr/bin/env dash

# ==============================================================================
# Test on slippy command line option -f files
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

echo 4q   >  commands.slippy
echo /2/d >> commands.slippy
echo 4d >> commands.slippy
echo /1.1/d >> commands.slippy

cat > "$expected_output" <<EOF
1
3
4
EOF
seq 1 99 | slippy -f commands.slippy > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"


echo /2/d >  commands.slippy
echo 4q   >> commands.slippy
echo /1/q   >> commands.slippy
echo 4q   >> commands.slippy
echo 8q   >> commands.slippy

cat > "$expected_output" <<EOF
3
4
5
6
EOF
seq 3 199 | slippy -f commands.slippy > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"


echo /2/d >  commands.slippy
echo 4q   >> commands.slippy
echo /1/q   >> commands.slippy
echo 4q   >> commands.slippy
echo 8q   >> commands.slippy

cat > "$expected_output" <<EOF
100
EOF
seq 100 11020 | slippy -f commands.slippy > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo /2/d >  commands.slippy
echo 100q   >> commands.slippy
echo /222/q   >> commands.slippy
echo 4p   >> commands.slippy
echo 8p   >> commands.slippy

cat > "$expected_output" <<EOF
100
101
103
103
104
105
106
107
107
108
109
110
111
113
114
115
116
117
118
119
130
131
133
134
135
136
137
138
139
140
141
143
144
145
146
147
148
149
150
151
153
154
155
156
157
158
159
160
161
163
164
165
166
167
168
169
170
171
173
174
175
176
177
178
179
180
181
183
184
185
186
187
188
189
190
191
193
194
195
196
197
198
199
EOF
seq 100 11020 | slippy -f commands.slippy > "$actual_output" 2>&1
test_diff "$expected_output" "$actual_output"

echo "Passed test"
exit 0
