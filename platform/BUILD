# Copyright 2017 Renato Utsch
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package(default_visibility = ["//visibility:public"])

# Definitions taken from the default toolchains at:
# https://github.com/bazelbuild/bazel/blob/master/tools/cpp/CROSSTOOL

config_setting(
    name = "freebsd",
    values = {"cpu": "freebsd"},
)

config_setting(
    name = "linux_arm",
    values = {"cpu": "arm"},
)

# x86_64 (k8 means AMD K8, first x86_64 processor)
config_setting(
    name = "linux_k8",
    values = {"cpu": "k8"},
)

# x86 (piii means Intel Pentium III)
config_setting(
    name = "linux_piii",
    values = {"cpu": "piii"},
)

# PowerPC
config_setting(
    name = "linux_ppc",
    values = {"cpu": "ppc"},
)

# PowerPC 64-bit
config_setting(
    name = "linux_ppc64",
    values = {"cpu": "ppc64"},
)

# IBM z Systems (s390x means System/390)
config_setting(
    name = "linux_s390x",
    values = {"cpu": "s390x"},
)

config_setting(
    name = "macos",
    values = {"cpu": "darwin"},
)

config_setting(
    name = "windows_x64",
    values = {"cpu": "x64_windows"},
)

config_setting(
    name = "windows_x64_msvc",
    values = {"cpu": "x64_windows_msvc"},
)

config_setting(
    name = "windows_x64_msys",
    values = {"cpu": "x64_windows_msys"},
)
