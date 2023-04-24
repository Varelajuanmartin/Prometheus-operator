kubectl create secret generic 06-additional-scrape-configs --from-file=prometheus-additional-job.yaml --dry-run=client -oyaml > 06-additional-scrape-configs.yaml
