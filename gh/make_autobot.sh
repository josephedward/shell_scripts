rm ./autobot.yml
mkdir .github
cd .github
mkdir workflows
cd workflows
autobot.yml
echo 'name: Dependabot auto-merge-dependabot-pr
on:
  pull_request_target
jobs:
  dependabot:
    runs-on: ubuntu-latest
    if: github.actor == '\''dependabot[bot]'\''
    steps:
    - name: 'Auto approve PR by Dependabot'
      uses: hmarr/auto-approve-action@v2.0.0
      with:
        github-token: ${{ secrets.PERSONAL_GITHUB_BOT_SECRET }}
    - name: 'Comment merge command'
      uses: actions/github-script@v3
      with:
        github-token: ${{secrets.PERSONAL_GITHUB_BOT_SECRET }}
        script: |
          await github.issues.createComment({
            owner: context.repo.owner,
            repo: context.repo.repo,
            issue_number: context.issue.number,
            body: '@dependabot squash and merge'
          }) ' > autobot.yml

