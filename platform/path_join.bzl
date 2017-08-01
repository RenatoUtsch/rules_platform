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

load(":repository_rule_select.bzl", "repository_rule_select")

# Default path environment variable separator for each OS.
_PATH_SEPARATOR = {
    "windows": ";",
    "default": ":",
}

# Default folder separator for each OS.
_FOLDER_SEPARATOR = {
    "windows": "\\",
    "default": "/",
}

def host_path_separator(repository_ctx):
    """Returns the path separator for the given OS for repository rules.

    For normal rules, you can use ctx.configuration.host_path_separator.
    """
    return repository_rule_select(repository_ctx, _PATH_SEPARATOR)

def host_folder_separator(repository_ctx):
    """Returns the folder separator for the given OS for repository rules."""
    return repository_rule_select(repository_ctx, _FOLDER_SEPARATOR)

def path_join(repository_ctx, path, *paths):
    """Joins folders, like os.path.join in Python, for repository rules.

    This uses the host folder separator to join folders. The only element that
    should have an absolute path is the first one.
    """
    sep = host_folder_separator(repository_ctx)
    join = [path[:-1] if path.endswith("\\") or path.endswith("/") else path]
    for p in paths:
        if not p:
            continue
        if p.startswith("\\") or p.startswith("/"):
            p = p[1:]
        if p.endswith("\\") or p.endswith("/"):
            p = p[:-1]
        join.append(p)
    return sep.join(join)
