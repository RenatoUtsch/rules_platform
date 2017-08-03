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

def default_translator(value):
    """Translates a "default" target to a //conditions:default selection."""
    return {"//conditions:default": value}

def freebsd_translator(value):
    """Translates a "freebsd" target to freebsd selections."""
    return {"//system:freebsd": value}

def linux_translator(value):
    """Translates a "linux" target to linux selections."""
    return {
        "//system:linux_arm": value,
        "//system:linux_ppc": value,
        "//system:linux_ppc64": value,
        "//system:linux_s390x": value,
        "//system:linux_piii": value,
        "//system:linux_k8": value,
    }

def macos_translator(value):
    """Translates a "macos" target to macos selections."""
    return {"//system:macos": value}

def windows_translator(value):
    """Translates a "windows" target to windows selections."""
    return {
        "//system:windows_x64": value,
        "//system:windows_x64_msvc": value,
        "//system:windows_x64_msys": value,
    }

# Translators used by default in system_select.
DEFAULT_SYSTEM_SELECT_TRANSLATORS = {
    "default": default_translator,
    "freebsd": freebsd_translator,
    "linux": linux_translator,
    "macos": macos_translator,
    "windows": windows_translator,
}

def system_select(targets,
                    translators=DEFAULT_SYSTEM_SELECT_TRANSLATORS):
    """Wrapper over select() to simplify selecting OSs.

    It uses special targets that are expanded into the correct select()
    selections for each OS.

    Available targets currently are:
      - freebsd
      - linux
      - macos
      - windows
      - default

    The function will only accept recognized targets. Use it like select. For
    example:

    FLAGS = system_select({
        "windows": ["-DWINDOWS"],
        "default": ["-DUNIX"],
    })

    This is implemented by iterating on all targets, in order, and calling the
    correspondent translator, and generating the selections. If a target is not
    matched, the function fails. At the end, the function returns a select()
    call with the generated selections.


    You can customize system_select() to add your own target translators by
    replacing the default "translators" parameter with one of your own. You can
    even wrap that in another function to automatically call your translators.
    The translators used by default in this function are defined in
    DEFAULT_SYSTEM_SELECT_TRANSLATORS, so that you can easily reuse them in
    your own function.

    Args:
        targets: dictionary from target to selection value if the selection is
            chosen.
        translators: dictionary from target to translator function. Each
            translator function receives one parameter -- the selection value --
            and returns the generated selection dictionary for the given
            selectionvalue.
    """
    selections = {}
    for target, value in targets.items():
        if target not in translators:
            fail("No translators matched the ({}, {}) target".format(target,
                                                                     value))
        translator = translators[target]
        selections += translator(value)

    return select(selections)
