# README

*conjuguer* - french verb conjugation website (<https://raf.org/conjuguer>)

# INTRODUCTION

*Conjuguer* is a French verb conjugation program which can be used from the
command line to output some or all tenses of some or all french verbs. It
can also generate a website containing all conjugations of all french verbs,
and it is also the CGI program that drives the website.

See `make help` for more details, but note that the *Makefile* will have to
be edited to suit your needs.

# SYNOPSIS

    usage: conjuguer [options] [verbe...]
    options:
      -h       - Print this message then exit
      -f #     - Force a particular conjugation index
      -t tense - Print only these tenses (comma separated)
      -r       - Given any verb form, show its infinitive's conjugation
      -c fname - Override the conjugation file (conjugaisons)
      -v fname - Override the verb file (verbes)
      -x fname - Override the reverse lookup index file (reverse.idx)
      -R       - Build the reverse lookup index file (needed before -r)
      -W       - Generate a website rather than plain text output
      -D dir   - Override the output directory for the website (.)
      -I       - Only generate the index pages for the website
      -U uri   - Override the CGI URI (/cgi-bin/conjuguer)
      -C       - Generate CGI output (used internally)
      -1       - Print a verb histogram to stderr (for curiosity)
      -2       - Print a conjugation histogram to stderr (for curiosity)
      -3       - Print a preposition histogram to stderr (for curiosity)
      -4       - Print stems from the conjugation file to stderr (for curiosity)
    
    By default, prints conjugations of all verbs in the verb file.
    If any verbs are supplied on the command line, only their
    conjugations are printed. See the conjugations file for the list
    of valid conjugation indexes.
    
    The -t argument can be: infpres infpas partpres partpas indpres
    indpascmp indimp indpqp indpas indpasant indfut indfutant indfutp
    indpasp indpassurcmp subjpres subjpas subjimp subjpqp imppres imppas
    cndpres cndpas1 cndpas2.
    
    This program can also be used to identify the infinitive(s) that
    give rise to a given verb form using the -r option. For example,
    "conjuguer -r suis" will print the conjugations of the verbs
    être and suivre.
    
    This program can also be used as a CGI script to guess a verb's
    conjugation. The CGI parameters are:
    
      verb     - The verb to conjugate (normal or reflexive)
      index    - Force a particular conjugation index to be used
      reverse  - Reverse lookup of any verb form

# DOWNLOAD

*Conjuguer*'s source distribution can be downloaded from these locations:

- <https://raf.org/conjuguer/conjuguer.tar.gz>
- <https://github.com/raforg/conjuguer/releases/download/v20230408/conjuguer.tar.gz>

This is free software released under the terms of the GNU General Public
Licence version 3 or later (*GPLv3+*).

# INSTALL

To install *conjuguer* as a command line utility:

		make install

Then run `conjuguer -h` for more information.

To install *conjuguer* as a website:

        make web

Then visit:

        http://localhost/conjuguer

Of course, this is highly site-dependent. See the *Makefile*.

# REQUIREMENTS

*Conjuguer* requires any version of *Perl* since 5.16. The *CGI* module is
required. It is no longer a core module since *Perl* 5.22 and can be
installed from *CPAN* or from a system package. The website requires a web
server such as *apache* or *nginx*.

--------------------------------------------------------------------------------

    URL: https://raf.org/conjuguer
    GIT: https://github.com/raforg/conjuguer
    GIT: https://codeberg.org/raforg/conjuguer
    Date: 20230408
    Author: raf <raf@raf.org>

