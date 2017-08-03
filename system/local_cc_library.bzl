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
load(":path_join.bzl", "path_join")

# Default include paths for each OS.
_DEFAULT_INCLUDE_PATHS = {
    "default": [
        "/usr/include",
        "/usr/local/include",
    ],
}

# Default library paths for each OS.
_DEFAULT_LIBRARY_PATHS = {
    "default": [
        "/usr/lib",
        "/usr/local/lib",
        "/lib",
    ],
}

def _format_list(elems):
    """Formats the given list to use as a BUILD rule attribute."""
    elems = ["\"{}\"".format(elem) for elem in elems]
    if not elems:
        return "[]"
    if len(elems) == 1:
        return "[{}]".format(elems[0])
    return "[\n        {},\n    ]".format(",\n        ".join(elems))

def _list_to_matcher(matcher_list):
    """Converts a matcher as a list to a dict matcher."""
    return {"default": matcher_list}

def _join_matchers(matcher, *matchers):
    """Joins matchers of lists correctly."""
    output = {k: [e for e in v] for k, v in matcher.items()}

    for matcher_to_join in matchers:
        has_default = False
        for key, value in matcher_to_join.items():
            if key == "default":  # Default has a special case.
                has_default = True

            if key in output:
                output[key].extend(value)
            else:
                # Important to add the "default" value, if it exists, as the new
                # key was a "default", but is not anymore.
                output[key] = value
                if "default" in output and key != "default":
                    value.extend(output["default"])
        if has_default:
            for key in output.keys():
                # All keys from output that are not in matcher_to_join were part
                # of "default" in matcher_to_join, so they need to be added the
                # default.
                if key not in matcher_to_join:
                    output[key].extend(matcher_to_join["default"])
    return output

def _symlink_files(repository_ctx, files, paths):
    """Symlinks the given files found in the given paths. Fails if not found."""
    for f in files:
        found = False
        for path in paths:
            file_path = path_join(repository_ctx, path, f)
            if repository_ctx.path(file_path).exists:
                repository_ctx.symlink(file_path, f)
                found = True
                break
        if not found:
            fail("Could not find file to symlink in system: {}".format(f))

def _local_cc_library_impl(repository_ctx):
    hdrs = repository_rule_select(repository_ctx, repository_ctx.attr.hdrs)
    libs = repository_rule_select(repository_ctx, repository_ctx.attr.libs)
    include_paths = repository_rule_select(repository_ctx,
                                           repository_ctx.attr.include_paths)
    library_paths = repository_rule_select(repository_ctx,
                                           repository_ctx.attr.library_paths)

    # TODO(renatoutsch): save transitive headers hdrs depends on.
    # TODO(renatoutsch): add transitive libraries libs depends on.
    _symlink_files(repository_ctx, hdrs, include_paths)
    _symlink_files(repository_ctx, libs, library_paths)

    build_fragments = []
    build_fragments.append("package(default_visibility = " +
                           "[\"//visibility:public\"])")
    build_fragments.append("")
    build_fragments.append("cc_library(")
    build_fragments.append("    name = \"{}\",".format(repository_ctx.name))
    if hdrs:
        build_fragments.append("    hdrs = {},".format(_format_list(hdrs)))
        build_fragments.append("    includes = [\".\"],")
    if libs:
        build_fragments.append("    srcs = {},".format(_format_list(libs)))
    build_fragments.append(")")

    build_file_content = "\n".join(build_fragments)
    repository_ctx.file("BUILD", build_file_content, executable=False)

_local_cc_library = repository_rule(
    attrs = {
        "hdrs": attr.string_list_dict(),
        "libs": attr.string_list_dict(),
        "include_paths": attr.string_list_dict(),
        "library_paths": attr.string_list_dict(),
    },
    local = True,
    implementation = _local_cc_library_impl,
)

def local_cc_library(name, hdrs=[], libs=[], include_paths=[],
                     library_paths=[]):
    """
    Finds a C/C++ library on the system and makes it available for use with Bazel.

    To use this, specify the include files and the shared libraries in the WORKSPACE
    file using this rule and Bazel will take care of searching for it once it is
    used.

    The hdrs, libs, include_paths and library_paths parameters can be either a
    string list or a dict of string lists. If it is a dict of string lists, the
    dict will be passed directly to repository_rule_select(), so that the user
    can specify OS-dependent headers and library file names. If the input is a
    string list, this string list will be used in all operating systems (it is
    in fact just a shorthand for {"default": string_list}). Read the
    documentation for repository_rule_select for more information.



    Args:
        name: the name of the library. To reference the library on your rules,
            use "@name" in the deps of cc_library or cc_binary.
        hdrs: required header files. The headers must be specified in the
            relative path used to include them.
        libs: required library files. The file names must be exact.
        include_paths: extra paths to use when finding the hdrs.
        library_paths: extra paths to use when finding the libs.

    TODO(renatoutsch): change the libs behavior to find only one of the
        specified libraries, and keep the first one found, instead of searching
        for all of them. With this, implement generate_lib_names().
    TODO(renatoutsch): look at these environment variables:
        https://cmake.org/cmake/help/v3.0/command/find_library.html
        (PATH, LIB)
    TODO(renatoutsch): look at these environment variables:
        https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html#Environment-Variables
        (CPATH, C_INCLUDE_PATH, CPLUS_INCLUDE_PATH)
    TODO(renatoutsch): use `gcc -MM <header>` to find transitive headers and symlink
        them if possible.
    TODO(renatoutsch): add support for environment variables in the paths. Find a
        way to add them to repository_rule()'s environ variable.
    """
    if type(hdrs) == type([]):
        hdrs = _list_to_matcher(hdrs)
    if type(libs) == type([]):
        libs = _list_to_matcher(libs)
    if type(include_paths) == type([]):
        include_paths = _list_to_matcher(include_paths)
    if type(library_paths) == type([]):
        library_paths = _list_to_matcher(library_paths)

    _local_cc_library(
        name = name,
        hdrs = hdrs,
        libs = libs,
        include_paths = _join_matchers(include_paths, _DEFAULT_INCLUDE_PATHS),
        library_paths = _join_matchers(library_paths, _DEFAULT_LIBRARY_PATHS),
    )
