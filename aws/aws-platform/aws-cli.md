***
AWS Configure set default.s3_max_concurrent_requests 500

aws s3 sync s3://prod-hcdr-output-blue/nch/dmer_header/ s3://prod-hcdr-output-blue/preprod-hcdr-output/nch/dmer_header/ --recursive

aws s3 sync s3://prod-hcdr-output-blue/nch/dmer_line/ s3://prod-hcdr-output-blue/preprod-hcdr-output/nch/dmer_line/ --recursive
