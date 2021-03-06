#!/usr/bin/perl

$gAppname = 'moocchat-load';
$gServer = $gAppname . ".herokuapp.com";
$gHttperf = 'httperf';


sub run_test {
    my($num_tasks, $rate, $timeout) = @_;
    $cmd = "$gHttperf --server=$gServer --method=POST --uri=/tasks/Learner+1/1/1 --num-conns=$num_tasks --rate=$rate --timeout=$timeout 2>/dev/null";
    warn "Running '$cmd'\n" if $gDebug;
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
    if ($total != $req || $total != $rep+$timeout) {
        my $missing = $req - ($rep+$timeout);
        push(@errors, "$total requests, but $req outgoing/$rep replies/$timeout T/O: $missing missing?");
    }
    if (@errors) {
        my($fh,$name) = mkstemp("bmXXXXX");
        warn "Errors written to $name";
        print $fh @errors;
        print $fh $_;
        close $fh;
    }
    return ($min/1000.0,$max/1000.0,$median/1000.0,$stdev/1000.0,
            100.0*$timeout/$total,$dur);
}

sub main {
    die "Usage: $0 min_rate max_rate step num_runs_per_rate\n" unless $#ARGV == 3;
    my($min_rate, $max_rate, $rate_step, $runs) = @ARGV;
    $tasks_to_create = 1000;
    $clear = "NEWRELIC_AGENT_ENABLED=false heroku run --app $gAppname rails runner -e production Task.delete_all >/dev/null 2>&1";
    $timeout = 10;
    $out = STDOUT;
    printf $out "| run | rate| min | max | med |stdv |fail%| dur |\n";
    for ($rate = $min_rate; $rate <= $max_rate; $rate += $rate_step) {
        for ($run = 1; $run <= $runs; $run++) {
            @result = &run_test($tasks_to_create, $rate, $timeout);
            printf $out ("| %3d | %3d | %2.1f | %2.1f | %2.1f | %2.1f | %2.0f  |%4.0f |\n", $run, $rate, @result);
        }
        warn "running '$clear'\n" if $gDebug;
        system $clear;
    }
}

&main;
