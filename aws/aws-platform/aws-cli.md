***
AWS Configure set default.s3_max_concurrent_requests 500

aws s3 sync s3://bucket_name/prefix/sub_prefix s3://bucket_name/prefix/sub_prefix --recursive
