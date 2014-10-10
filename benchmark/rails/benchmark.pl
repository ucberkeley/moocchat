#!/usr/bin/perl

$gAppname = 'moocchat-load';
$gServer = $gAppname . ".herokuapp.com";
$gHttperf = 'httperf';


sub run_test {
    my($num_tasks, $rate, $timeout) = @_;
    $cmd = "$gHttperf --server=$gServer --method=POST --uri=/tasks/Learner+1/1/1 --num-conns=$num_tasks --rate=$rate --timeout=$timeout 2>/dev/null";
    warn "Running '$cmd'\n";
    $output = `$cmd`;
    @results = &parse_results($output);
    return @results;
}

sub parse_results {
    my $_ = shift;
    my @errors = ();
    my  $min,$avg,$max,$median,$stdev,$timeout;
    my $total,$req,$rep,$dur;
    if ( /Total: connections (\S+) requests (\S+) replies (\S+) test-duration (\S+)/m ) {
        ($total,$req,$rep,$dur) = ($1,$2,$3,$4);
    } else {
        push(@errors, "Can't parse total connections");
    }
    if ( /Connection time.*min (\S+) avg (\S+) max (\S+) median (\S+) stddev (\S+)/m ) {
        ($min,$avg,$max,$median,$stdev) = ($1,$2,$3,$4,$5);
    } else {
        push(@errors, "Can't parse min, max, etc");
    }
    if ( /Errors: total (\S+) client-timo (\S+) socket-timo (\S+) connrefused (\S+) connreset (\S+)/m ) {
        $timeout  = $2;
    } else {
        push(@errors, "Can't parse timeout");
    }
    if (@errors) {
        my($fh,$name) = mkstemp("bmXXXXX");
        warn "Errors written to $name";
        print $fh @errors;
        print $fh $_;
        close $fh;
    }
    return ($min/1000.0,$max/1000.0,$median/1000.0,$stdev/1000.0,
            int(100.0*$timeout/$total),$dur);
}

sub main {
    $min_rate = 10;
    $max_rate = 16;
    $rate_step = 1;
    $runs = 4;
    $tasks_to_create = 1000;
    $clear = "NEWRELIC_AGENT_ENABLED=false heroku run --app $gAppname rails runner -e production Task.delete_all >/dev/null 2>&1";
    $timeout = 10;
    open(OUTPUT, "> output.txt") or die;
    $out = OUTPUT;
    printf $out "| run | rate| min | max | med |stdv |fail%| dur |\n";
    for ($rate = $min_rate; $rate <= $max_rate; $rate += $rate_step) {
        for ($run = 1; $run <= $runs; $run++) {
            @result = &run_test($tasks_to_create, $rate, $timeout);
            printf $out ("| %3d | %3d | %2.1f | %2.1f | %2.1f | %2.1f | %2d  |%4.0f |\n", $run, $rate, @result);
        }
        warn "running '$clear'\n";
        system $clear;
    }
}

&main;
