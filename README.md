Perl on AWS Elastic Beanstalk


Dependencies
------------

 * git
 * AWS Elastic Beanstalk Command Line Tool


How to use 
------------

    mkdir perloneb
    cd perloneb
    git init
    AWSDevTools-RepositorySetup.sh
    eb init
    (Select a solution stack.  Available solution stacks are: 2) 64bit Amazon Linux running PHP 5.4)
    eb start
    git add hello.pl
    git add .ebextensions
    git add .gitignore
    git commit -m "hello perl"
    git aws.push


AUTHOR
------------------
Masaaki Saito <masakyst.public@gmail.com>

