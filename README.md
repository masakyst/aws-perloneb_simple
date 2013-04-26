aws-perloneb_simple
===================

Perl on AWS Elastic Beanstalk

use git

use AWS Elastic Beanstalk Command Line Tool


# DESCRIPTION

mkdir perloneb

cd perloneb

git init

AWSDevTools-RepositorySetup.sh

eb init

Select a solution stack.
Available solution stacks are:
2) 64bit Amazon Linux running PHP 5.4

eb start

git add hello.pl

git add .ebextensions

git add .gitignore

git commit -m "hello perl"

git aws.push


# AUTHOR

Masaaki Saito <masakyst.public@gmail.com>

# LICENSE

Copyright (C) Masaaki Saito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
