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

load(":local_cc_library.bzl", "local_cc_library")
load(
    ":system_select.bzl",
    "system_select",
    "DEFAULT_SYSTEM_SELECT_TRANSLATORS",
)
load(
    ":repository_rule_select.bzl",
    "repository_rule_select",
    "DEFAULT_REPOSITORY_RULE_SELECT_MATCHERS",
)
load(
    ":path_join.bzl",
    "host_path_separator",
    "host_folder_separator",
    "path_join",
)
