#!/bin/bash
#
#========================================================================================
# Description:
#   Copy this script in the same folder of the main tex file.
#   Every time this script runs, it will download and install
#   only one missing package.
#   Therefore, you should run this script MANY TIMES until
#   all missing packages have been download and installed.
#
# Usage:
#   ./texup.sh
# or
#   ./texup.sh $1
# 
# where $1 is an optional placeholder for
# the main TeX file to compile.
# For example:
#   ./texup.sh thesis.tex
#
# You also can let the $1 be empty and
# just run:
#   ./texup.sh
#
#========================================================================================
#
# CONSTANTS
#
#========================================================================================
DEFAULT_CTAN_SERVER="https://mirrors.ctan.org/macros/latex/contrib/"
DEFAULT_DOWNLOAD_LOCATION="/home/$(echo $USER)/Downloads/"
DEFAULT_TEX_LOCATION="/usr/share/texlive/texmf-dist/tex/latex/"
DEFAULT_FEX=zip               # file extension (*.zip)
DEFAULT_TMP_LOG=tmp.log
DEFAULT_PKG_LOG=pkg.log       # logs downloaded package(s)
DEFAULT_TEX_FILE=thesis.tex   # main tex file
#========================================================================================
#
# VARIABLES
#
#========================================================================================
_va=                          # general-purpose variable
_pkg=                         # package name
#========================================================================================
#
# FUNCTION (pkg_install)
#
# Install a TeX package. The first argument $1 contains
# the package name.
#
# @param:
#   $1 : package (name) to be installed, e.g. "imakeidx".
#   $2 : source path (location) where the package is
#        currently in, e.g. "/home/<user>/Downloads/".
#   $3 : destination path (location) where the package
#        should be installed/copied to, e.g.
#        "/usr/share/texlive/texmf-dis/tex/latex/".
#
#========================================================================================
function pkg_install () {
  #
  # Local variables are declared by the keyword "local".
  # They are only visible inside the function scope.
  # When the function ends, the value of local variable(s)
  # will also "vanish".
  local __pkg="$1"              # obtain package name
  local __pkg_src="$2"          # download location
  local __pkg_dst="$3"          # install destination
  #
  # Navigate to the folder (location) containing the
  # (downloaded) package
  cd "${__pkg_src}"
  # 
  # Extract zipped package to current directory (".").
  # The option "-q" indicates quite unpacking, "-d <dir>"
  # specifies the location (directory) which the package
  # is extracted to, and <dir> = "." refers to the
  # 
  # "current directory".
  # ${__pkg} = "imakeidx"
  # ${DEFAULT_FEX} = "zip"
  # ${__pkg}.${DEFAULT_FEX} = "imakeidx.zip"
  # sudo unzip -q imakeidx.zip -d .
  sudo unzip -q ${__pkg}.${DEFAULT_FEX} -d .
  #
  # Nagivate to inside the package, i.e. <location>/<package>
  cd "${__pkg}/"
  #
  # Check if file "<package>.sty" does exist.
  # If no, then check further if file "<package>.ins"
  # or/and "<package>.dtx" does exist.
  # If yes, then create .sty file (i.e.
  # "<package>.sty") from either .ins- or
  # .dtx file.
  #
  # Option "-1" bedeutet, dass jede aufgelistete Zeile
  # nur den Dateinamen beinhaltet und keine weitere
  # Informationen (z.B. Berechtigung, Änderungsdatum etc.).
  # 
  _va="$(ls -1 | grep '.sty')"              # check .sty file
  if [ -z "${_va}" ]; then                  # if ${_va} is empty => .sty file not exist
    _va="$(ls -la | grep '.ins')"           # check .ins file
    if [ -z "${_va}" ]; then                # if ${_va} is empty => .ins file not exist
      _va="$(ls -1 | grep '.dtx')"          # check .dtx file
      if [ -z "${_va}" ]; then              # if ${_va} is empty => .dtx file not exist
        return 1                            # error code (1). Exit function.
      else                                  # .dtx file exists
        sudo tex "${__pkg}.dtx"             # create .sty file from .dtx
      fi
    else                                    # .ins file exists
      sudo tex "${__pkg}.ins"               # create .sty file from .ins
    fi
    echo "+ TeX Install Log: File '${__pkg}.sty' is created."
  else
    echo "+ TeX Install Log: File '${__pkg}.sty' is identified."
  fi
  #
  # Create new folder <package>/ in "${__pkg_dst}" or
  # "${DEFAULT_TEX_LOCATION}" or
  # "/usr/share/texlive/texmf-dis/tex/latex/"
  sudo mkdir "${__pkg_dst}${__pkg}/"
  echo "+ TeX Install Log: TeX folder '${__pkg_dst}${__pkg}/' is created."
  #
  # Copy file "<package>.sty" and all related files
  # "<package>.*" to the newly created folder
  # "${__pkg_dst}$<package>/" or
  # "${DEFAULT_TEX_LOCATION}<package>/" or
  # "/usr/share/texlive/texmf-dis/tex/latex/<package>/"
  #sudo cp ${__pkg}.* "${__pkg_dst}${__pkg}/"
  echo "+ TeX Install Log: Following files '${__pkg}.*' are copied to folder '${__pkg_dst}${__pkg}/'."
  for f in $(ls -1 | grep "${__pkg}"); do
    if [ "$f" != *"pdf"* ]; then
      sudo cp $f "${__pkg_dst}${__pkg}/"
      echo "+   $f"
    fi
  done
  #
  # Change mode (access rights) for all .sty file(s).
  # They should have the access rights "-rw-r--r--"
  # or "0644" (octal notation).
  #
  # The 1st command "chmod a=r *.sty" causes that
  # all ("a") users of all groups (i.e. a = {u, g, o}
  # where u = user, g = group, o = other(s)) can
  # access/read ("=r") the .sty files ("*.sty").
  #
  #   $ chmod a=r *.sty
  #   $ -r--r--r--
  #
  # The 2nd command "chmod u+w *.sty" causes that
  # only current user ("u") gets the writing access
  # ("+w") to the .sty files.
  #
  #   $ chmod u+w *.sty
  #   $ -rw-r--r--
  #
  # The 3rd command "chmod 0644" is just the
  # combination / abbreviation of the last two
  # commands above. Furthermore, it uses the 
  # octal notation "0644".
  # 
  #     S  U  G  O
  #     0  6  4  4
  # 
  # where "S = Sticky-Bit" should be zero (0),
  # "U = User" has read-write-access "rw-" or
  # "6" because 6 = 4 + 2,+ 0,
  # "G = Group" has read-only access "r--" or
  # "4" because 4 = 4 + 0,
  # "O = Group" has read-only access "r--" or
  # "4" because 4 = 4 + 0,
  # and:
  #       # | access          | rwx | rwx
  #      ===+=================+=====+=====
  #       7 | full            | 111 | rwx
  #       6 | read + write    | 110 | rw-
  #       5 | read + execute  | 101 | r-x
  #       4 | read-only       | 100 | r--
  #       3 | write + execute | 011 | -wx
  #       2 | write-only      | 010 | -w-
  #       1 | execute-only    | 001 | --x
  #       0 | none            | 000 | ---
  #
  cd "${__pkg_dst}${__pkg}/"
  #sudo chmod a=r *.sty
  #sudo chmod u+w *.sty
  #sudo chmod 0644 *.sty
  sudo chmod ${__pkg}.*
  #
  # Go back to download (source) location, and<ext>
  # remove all downloaded package files
  cd ${__pkg_src}
  sudo rm -rf ${__pkg} ${__pkg}.${DEFAULT_FEX}
  echo "+ TeX Install Log: Downloaded file(s) and folder(s) are removed."
  #
  # exit code (0) for successful operation
  return 0
}
#========================================================================================
#
# FUNCTION (pkg_handle_extra_libs)
#
# Download & handle extra (missing) TeX libraries
# as "biblatex" / "biber"
#
#========================================================================================
function pkg_handle_extra_libs () {
  # get package name
  local __pkg="$1"
  # case distinction
  if [ -z ${__pkg} ]; then      # if ${__pkg} is empty (zero)
    echo "+ TeX Download Log: Your TeX library is up to date. No package is missing."
    echo "+ TeX Update Log: Done. [OK]"
    exit 0
  else
    echo "+ TeX Download Log: Missing package '${_pkg}.${DEFAULT_FEX}' is identified."
    # install Biber and 'biblatex.sty'
    if [ "${__pkg}" = "biblatex" ]; then
      echo "+ TeX Download Log: sudo apt-get install texlive-bibtex-extra biber"
      sudo apt-get install texlive-bibtex-extra biber
      _fn_out_ "${__pkg}"
    # install package "pgf" for TikZ ("tikz.sty")
    elif [ "${__pkg}" = "tikz" ]; then
      # TODO
      echo "+ TeX Download Log: sudo apt-get install texlive-pictures"
      sudo apt-get install texlive-pictures
      _fn_out_ "pgf"             # "pgf" is the package containing TikZ
    fi
  fi
}
#
function _fn_out_ () {
  echo "$1" >> "${_pwd}/${DEFAULT_PKG_LOG}"
  echo "+ TeX Install Log: Package '$1.${DEFAULT_FEX}' has been successfully installed."
  # update TeX library
  pkg_update_lib
  exit 0
}
#========================================================================================
#
# FUNCTION (pkg_download)
#
# Download the (missing) package (.zip) from CTAN server.
#
# @param:
#   $1 : package (name) to be downloaded, e.g. "imakeidx"
#   $2 : path (location) where the package is downloaded
#        and stored in, e.g. "/home/<user>/Downloads/"
#        or "${DEFAULT_DOWNLOAD_LOCATION}"
#
# @return:
#   zero (0) : if package was downloaded successfully
#   non-zero : if package cannot be downloaded
#
#========================================================================================
function pkg_download () {
  #
  # Local variables are declared by the keyword "local".
  # They are only visible inside the function scope.
  # When the function ends, the value of local variable(s)
  # will also "vanish".
  local __pkg="$1"              # package name
  local __pkg_dl="$2"           # download folder
  #
  # Handle extra package libraries as "biblatex" (biber)
  pkg_handle_extra_libs "${__pkg}"
  #
  # Remove all (previously downloaded) old package files
  sudo rm -rf "${__pkg_dl}/${__pkg}" "${__pkg}.${DEFAULT_FEX}"
  #
  # Download (wget) the missing package.
  # Store all protocol output information to external
  # log file ${DEFAULT_TMP_LOG}.
  #
  # WGET-Options:
  # > option -O (--output-document=FILE) specifies the local
  #   name of the downloaded file, e.g. "-O FILE" or
  #   "-O file.zip",
  # > option -P (--directory-prefix=LOCATION) specifies
  #   the storing location (folder) for the downloaded file,
  #   e.g. "-P LOCATION/..",
  # > option -o (--output-file=FILE) specifies the log file
  #   which all protocol output information are written in,
  #   e.g. "-o tmp.log"
  #
  # Example: Download package "imakeidx.zip" from CTAN
  #   $ wget -O imakeidx.zip \
  #          -P "/home/$(echo $USER)/Downloads/" \
  #          -o "/home/$(echo $USER)/Downloads/tmp.log" \
  #           https://mirrors.ctan.org/macros/latex/contrib/imakeidx.zip
  #
  #wget -O ${__pkg}.${DEFAULT_FEX} \
  wget -P "${__pkg_dl}" \
       -o "${DEFAULT_TMP_LOG}" \
          "${DEFAULT_CTAN_SERVER}${__pkg}.${DEFAULT_FEX}"
  #
  # Get exit code (__ex) after wget execution.
  local __ex="$(echo $?)"          # exit code (8)
  #
  # Assign empty string to (global) variable "_va"
  _va=""
  #
  # Read & evaluate the log file ${DEFAULT_TMP_LOG}.
  # If the log file contains the text "404 Not Found" or
  # "404: Not Found.", then the desired package couldn't
  # be downloaded. This text passage "404 Not Found" is
  # then stored in variable "_va" to indicate that the
  # download process was not successful. Otherwise, if 
  # the log file doesn't contain the text "404 Not
  # Found" and "404: Not Found.", then "_va" remains
  # empty, i.e. the download process was successful.
  # 
  # The option "-E" of grep-command allows the use of
  # regular pattern(s) with OR (|) operator.
  _va=$(grep -E '404 Not Found|404: Not Found.' ${DEFAULT_TMP_LOG})
  rm -f ${DEFAULT_TMP_LOG}
  #
  # if ${_va} is not empty => unsuccess
  if [ ! -z "${_va}" ]; then      # _va contains "404"
    return "$(( ${__ex} | 8 ))"   # no success (<> 0)
  else
    return 0                      # success (0)
  fi
}
#========================================================================================
#
# FUNCTION (pkg_tex)
#
# Compile the TeX document and create output (ps, dvi, pdf).
#
# @param:
#   $1 : name of TeX file to be compiled
#
#========================================================================================
function pkg_tex () {
  #
  # Check if argument $1 is empty (-z) or not (!)
  if [ ! -z $1 ]; then          # if $1 is not empty..
    _va=$1
  else                          # if $1 is empty..
    _va=${DEFAULT_TEX_FILE}
  fi
  #
  # Compile main (tex) file, and store the return value
  # from grep-execution to variable.
  #
  # The pipe (|) and grep-command are needed for extracting
  # (finding) the following line
  #
  #   "! LaTeX Error: File `<package>.sty' not found."
  #
  # from log.
  #
  # Result: _va = "! LaTeX Error: File `<package>.sty' not found."
  #
  # The string '.sty'\'' not found.' below in code
  # can be understood as following concatenations:
  #
  #     '.sty'  +  \'  +  ' not found.'
  #       (1)     (2)         (3)
  # or
  #
  #     ".sty"  +  \'  +  " not found."
  #
  # That means, this string is divided in 3 parts:
  #   (1) '.sty'
  #   (2) \'
  #   (3) ' not found.'
  #
  # Part (1) contains the (sub)string '.sty' (without
  # surrounding quotes).
  # Part (2) \' provides a single-quote (') by using
  # the escapping backslash (\).
  # Part (3) contains the (sub)string ' not found.'
  # (without surrounding quotes).
  # The sequence '\'' (spoken: quote backslash quote
  # quote) within string '.sty'\'' not found.' has
  # the following meaning:
  #   - first quote (') closes first substring '.sty';
  #   - then, escape-sequence (\') for single-quote;
  #   - finally, thirst quote (') starts third string.
  #
  echo "+ TeX Compile Log: Creating file '${DEFAULT_TEX_FILE}'.."
  #_va=$(pdflatex -synctex=1 -interaction=nonstopmode ${_va} | grep '.sty'\'' not found.')
  _va=`pdflatex -synctex=1 -interaction=nonstopmode ${_va} | grep '.sty'\'' not found.'`
  #
  # Extract substring '<package>' from line:
  #    "! LaTeX Error: File `<package>.sty' not found."
  # The cut-command splits this line in 2 substrings
  # delimited by apostrophe (-d'`'), and yields the 2nd
  # substring/field (-f2), i.e. "<package>.sty not found.",
  #
  #   ["! LaTeX Error: File "]  ["<package>.sty' not found."]
  #            1.                           2.
  # 
  # Result: _va = "<package>.sty not found."
  #
  _va=$(echo ${_va} | cut -d'`' -f2)
  #
  # Extract the package name (<package>) from substring:
  #     "<package>.sty' not found."
  # The cut-command splits this substring in 2 parts
  # delimited by dot (-d'.'), and yields the 1st part/field
  # (-f1), i.e. "<package>",
  #
  #   ["<package>"]  ["sty' not found."]
  #         1.               2.
  #
  # Result: _va  = "<package>"
  #
  # where <package> is a place holder for package name
  # as "imakeidx", "csquotes" etc.
  #
  _va=$(echo ${_va} | cut -d'.' -f1)
  #
  # Assign varible "_pkg" string value (package name)
  # from general-purpose variable "_va".
  _pkg=${_va}
}
#========================================================================================
#
# FUNCTION (pkg_update_lib)
#
# Update TeX library (texhash).
#
#========================================================================================
function pkg_update_lib () {
  sudo texhash                  # update TeX library
}
#========================================================================================
#
# FUNCTION (main)
#
#========================================================================================
function main () {
  #
  # get current location (directory)
  _pwd="$(pwd)"
  #
  # update TeX library
  #pkg_update_lib
  #
  # compile main TeX file
  pkg_tex $1
  #
  # download missing TeX package
  pkg_download "${_pkg}" "${DEFAULT_DOWNLOAD_LOCATION}"
  #
  # get exit code ("$?") from previous command execution
  # (pkg_download) and evaluate/check if exit code is zero.
  # "$?" is used to determine the exit code from last operation.
  if [ "$?" -ne "0" ]; then       # "-ne 0" = not equal 0
    echo "! TeX Download Error: Package '${_pkg}.${DEFAULT_FEX}' cannot be downloaded. Abort!"
    exit 0                        # exit program
  else
    echo "+ TeX Download Log: Package '${_pkg}.${DEFAULT_FEX}' has been successfully downloaded" \
        "in ${DEFAULT_DOWNLOAD_LOCATION}."
  fi
  #
  # install downloaded TeX package
  pkg_install "${_pkg}" "${DEFAULT_DOWNLOAD_LOCATION}" "${DEFAULT_TEX_LOCATION}"
  #
  # get exit code ("$?") from previous command execution
  # (pkg_install) and evaluate/check if exit code is zero.
  # "$?" is used to determine the exit code from last operation.
  if [ "$?" -eq "0" ]; then
    echo "${_pkg}" >> "${_pwd}/${DEFAULT_PKG_LOG}"
    echo "+ TeX Install Log: Package '${_pkg}.${DEFAULT_FEX}' has been successfully installed."
  else
    echo "! TeX Install Error: Package '${_pkg}.${DEFAULT_FEX}' couldn't be installed. Abort!"
    exit 1
  fi
  #
  # go back to script's current directory
  cd ${_pwd}
  #
  # update TeX library
  pkg_update_lib
}
#========================================================================================
#
# START
#
#========================================================================================
main $1