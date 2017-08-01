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

workspace(name = "rules_platform")

load("//platform:defs.bzl", "local_cc_library")

# Proposed local_cc_library with different libs examples:
# local_cc_library(
#     name = "glfw",
#     hdrs = [
#         "GLFW/glfw3.h",
#         "GLFW/glfw3native.h",
#     ],
#     libs = generate_lib_names(["glfw"]),
#     libs = generate_lib_names([
#         "glfw",
#         "glfw3",
#     ]),
#     libs = generate_lib_names({
#         "default": [
#             "glfw",
#             "glfw3",
#         ],
#     }),
#     libs = {
#         "windows": [
#             "glfw.dll",
#             "glfw3.dll",
#         ],
#         "macos": [
#             "libglfw.dylib",
#             "libglfw3.dylib",
#         ],
#         "default": [
#             "libglfw.so",
#             "libglfw3.so",
#         ],
#     },
# )

# Proposed local_cc_library with different libs examples:
# local_cc_library(
#     name = "vulkan",
#     # libs = generate_lib_names({
#     #     "windows": ["vulkan-1"],
#     #     "macos": ["MoltenVK"],
#     #     "default": ["vulkan"],
#     # }),
#     libs = {
#         "windows": ["vulkan-1.dll"],
#         "macos": ["libMoltenVK.dylib"],
#         "default": ["libvulkan.so"],
#     },
# )
