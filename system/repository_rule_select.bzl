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

# CPU values taken from:
# https://github.com/bazelbuild/bazel/blob/master/tools/cpp/lib_cc_configure.bzl

def freebsd_matcher(repository_ctx):
    """Matches FreeBSD."""
    if repository_ctx.os.name.lower().find("freebsd") != -1:
        return True
    return False

def linux_matcher(repository_ctx):
    """Matches Linux."""
    if repository_ctx.os.name.lower().find("linux") != -1:
        return True
    return False

def macos_matcher(repository_ctx):
    """Matches Mac OS."""
    if repository_ctx.os.name.lower().startswith("mac os"):
        return True
    return False

def windows_matcher(repository_ctx):
    """Matches Windows."""
    if repository_ctx.os.name.lower().find("windows") != -1:
        return True
    return False

# Matchers used by default in repository_rule_select.
DEFAULT_REPOSITORY_RULE_SELECT_MATCHERS = {
    "freebsd": freebsd_matcher,
    "linux": linux_matcher,
    "macos": macos_matcher,
    "windows": windows_matcher,
}

def repository_rule_select(repository_ctx, targets,
                     matchers=DEFAULT_REPOSITORY_RULE_SELECT_MATCHERS):
    """Simulates select() in repository rules.

    It queries the operating system to detect the correct OS.

    Available targets currently are:
      - freebsd
      - linux
      - macos
      - windows
      - default

    The function will only accept recognized targets. Use it like select. For
    example:

    path_separator = repository_rule_select(repository_ctx, {
        "windows": ["\\"],
        "default": ["/"],
    })

    This is implemented by iterating on all targets, in order, and calling the
    correspondent matcher until a matcher signals a match. If no targets are
    matched, or more than one target is matched, the function fails.

    You can use the "default" target to match in case any other targets do not
    match. If you do not specify this target, one of the targets *must* match.

    You can customize repository_rule_select() to add your own target matchers
    by replacing the default "matchers" parameter with one of your own. You can
    even wrap that in another function to automatically call your own matchers.
    The matchers used by default in this function are defined in
    DEFAULT_REPOSITORY_RULE_SELECT_MATCHERS, so that you can easily reuse them
    in your own function.

    Remember that "default" is a special case and is *always* handled by this
    function.

    Args:
        repository_ctx: repository context used to query for information on the
            system.
        targets: dictionary from target to selection value if the target is
            chosen.
        matchers: dictionary from target to matcher function. Each matcher
            function receives one parameter -- the repository_ctx -- and returns
            True if the target was matched or False if it was not.
    """
    matches = []
    for target, value in targets.items():
        if target == "default":
            continue  # Default is matched at the end

        if target not in matchers:
            fail("repository_rule_select: ({}, {}) ".format(target, value) +
                 "not matched by any matcher")

        matcher = matchers[target]
        if matcher(repository_ctx):
            matches.append((target, value))

    if not matches:
        if "default" in targets:
            return targets["default"]

        fail("repository_rule_select: no matches\n" +
             "Targets: {}".format(targets))
    if len(matches) != 1:
        fail("repository_rule_select: multiple matches - {}\n".format(matches) +
             "Targets: {}".format(targets))

    _, value = matches[0]
    return value
