# 123-READMEs

Maintain a single README.org file and use this script to generate a
plain text (README) and a markdown (README.md) version. The generated
markdown is github friendly.

To use this elisp script, add the following target to your Makefile,

    README README.md: README.org
            emacs -Q --batch --script readme.el

