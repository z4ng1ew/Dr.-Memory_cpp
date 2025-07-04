# **********************************************************
# Copyright (c) 2012 Google, Inc.  All rights reserved.
# **********************************************************

# Dr. Memory: the memory debugger
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation;
# version 2.1 of the License, and no later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

set(PACKAGE_VERSION 1.0.19621)

if ("${PACKAGE_FIND_VERSION_MAJOR}" EQUAL 0)
  # No version specified, or beta pre-1.0: assume compatible
  set(PACKAGE_VERSION_COMPATIBLE 1)
elseif ("${PACKAGE_FIND_VERSION_MAJOR}" LESS )
  set(PACKAGE_VERSION_COMPATIBLE 1)
elseif ("${PACKAGE_FIND_VERSION_MAJOR}" EQUAL )
  # Asking for lesser minor version == backward compatible
  if ("${PACKAGE_FIND_VERSION_MINOR}" EQUAL )
    if ("${PACKAGE_FIND_VERSION_COUNT}" GREATER 2)
      if ("${PACKAGE_FIND_VERSION_PATCH}" LESS 19621)
        set(PACKAGE_VERSION_COMPATIBLE 1)
      elseif ("${PACKAGE_FIND_VERSION_PATCH}" EQUAL 19621)
        set(PACKAGE_VERSION_EXACT 1)
      else ()
        # Asking for specific version so cannot give out older
      endif ()
    else ("${PACKAGE_FIND_VERSION_COUNT}" GREATER 2)
      set(PACKAGE_VERSION_EXACT 1)
    endif ("${PACKAGE_FIND_VERSION_COUNT}" GREATER 2)
  elseif ("${PACKAGE_FIND_VERSION_MINOR}" LESS )
    set(PACKAGE_VERSION_COMPATIBLE 1)
  else ()
    # We are relatively forward compatible except features we added
    # but better err on the side of caution
  endif ()
else ()
  # Not a match
endif ()

# Compatibility with particular versions
if (NOT "${PACKAGE_FIND_VERSION_MAJOR}" EQUAL 0)
  set(PACKAGE_FIND_VERSION "${PACKAGE_FIND_VERSION_MAJOR}.${PACKAGE_FIND_VERSION_MINOR}.${PACKAGE_FIND_VERSION_PATCH}")
endif ()
