kubectl get pods -o json | jq -r `.items[] | select(.metadata.name | test("${$1}-")).metadata.name`
