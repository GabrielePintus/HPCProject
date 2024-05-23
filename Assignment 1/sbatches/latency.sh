
for core in 0 1 2 3
do
    echo $core
    mpirun -np 2 --cpu-list 0,$core ./osu-benchmark-tools/osu_scatter --full --tail-lat --iterations 1000 --warmup 100 --message-size 1:1048576 -f csv >> output_data/latency/scat_{$core}.csv
done

