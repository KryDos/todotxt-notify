#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use POSIX qw/strftime/;

# path to todo.sh file
my $todo_path = '<PATH_TO_todo.sh_FILE';

# extract date from string using regular expression
sub getDateFromString {
    my $string_with_date = shift;
    # if we find something then return it
    if($string_with_date =~ /.*(\d{4}-\d{1,2}-\d{1,2}).*/) {
        return $1;
    }
    # return empty string if date not found
    else {
        return '';
    }
}

# extract time from string using regular expression
sub getTimeFromString {
    my $string_with_date = shift;
    # if we find something then return it
    if($string_with_date =~ /.*(\d{2}:\d{2}:\d{2}).*/) {
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
    my $line = shift;
    #remove bash colors from $line 
    $line =~ s/\e\[?.*?[\@-~]//g;

    #show the notification
    `notify-send "Task notification" "$line"`;

}

# get all tasks to the array line by line
my @todo_lines = split(/\n/,`bash $todo_path ls`);

foreach my $todo_line (@todo_lines) {
    my $current_date = getCurrentDate();
    my $todo_date    = getDateFromString($todo_line);
    if(!$current_date or !$todo_date){
        next;
    }

    if(($current_date gt $todo_date) or ($current_date eq $todo_date)) {
        showNotification($todo_line);
    }
}
