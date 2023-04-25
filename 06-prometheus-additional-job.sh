kubectl create secret generic 07-additional-scrape-configs --from-file=prometheus-additional-job.yaml --dry-run=client -oyaml > 07-additional-scrape-configs.yaml
