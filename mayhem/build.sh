#!/bin/bash -eu
#
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# Build directly with bazel, bypassing bazel_build_fuzz_tests which passes
# --@rules_fuzzing//fuzzing:java_engine that does not exist in rules_fuzzing v0.1.1.
bazel build \
    "--@rules_fuzzing//fuzzing:cc_engine=@rules_fuzzing_oss_fuzz//:oss_fuzz_engine" \
    "--@rules_fuzzing//fuzzing:cc_engine_instrumentation=oss-fuzz" \
    "--@rules_fuzzing//fuzzing:cc_engine_sanitizer=none" \
    "--cxxopt=-stdlib=libc++" \
    "--linkopt=-lc++" \
    "--verbose_failures" \
    "--spawn_strategy=standalone" \
    "--action_env=CC=${CC}" \
    "--action_env=CXX=${CXX}" \
    //:http_template_fuzz_test_oss_fuzz

for oss_fuzz_archive in $(find bazel-bin/ -name "*_oss_fuzz.tar"); do
    tar --no-same-owner -xvf "${oss_fuzz_archive}" -C "${OUT}"
done
