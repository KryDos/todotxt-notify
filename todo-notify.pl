#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use POSIX qw/strftime/;

# path to todo.sh file
my $todo_path = '<PATH_TO_todo.sh_FILE';

# extract date from string using regular expression
sub getDateFromString {
    # if we find something then return it
    if(shift =~ /.*(\d{4}-\d{1,2}-\d{1,2}).*/) {
        return $1;
    }
    # return empty string if date not found
    else {
        return '';
    }
}

# extract time from string using regular expression
sub getTimeFromString {
    # if we find something then return it
    if(shift =~ /.*(\d{2}:\d{2}:\d{2}).*/) {
        return $1;
    }
    # return empty string if time not found
    else {
        return '';
    }
}

sub getCurrentDate {
    return strftime("%Y-%m-%d", localtime);
}

sub getCurrentTime {
    return strftime("%H:%M", localtime);
}

sub showNotification {
    #remove bash colors from line 
    $_[0] =~ s/\e\[?.*?[\@-~]//g;

    #show the notification
    `notify-send "Task notification" "$_[0]"`;
}

sub dateIsSet {
    return getDateFromString(shift);
}

# get all tasks to the array line by line
foreach (split(/\n/,`bash $todo_path ls`)) {
    if(!dateIsSet($_)) {
        next;
    }

    my $current_date = getCurrentDate();
    my $todo_date    = getDateFromString($_);
    if(($current_date gt $todo_date) or ($current_date eq $todo_date)) {
        showNotification($_);
    }
}
