#!/usr/bin/env zsh
# created by gilad ticher

# Set the names and URLs of the exercise repositories
exercise_repos=("ex1" "ex2" "ex3")
main_repo="OOP"
github_username="YourGitHubUsername"
github_token="YourGitHubToken"

# Create the OOP repository
mkdir $main_repo
cd $main_repo
git init

# Loop through exercise repositories
for repo in "${exercise_repos[@]}"; do
    # Add remote
    git remote add $repo <URL-of-$repo-repository>

    # Fetch the main branch
    git fetch $repo main

    # Merge the main branch into the main branch of OOP repository
    git merge "$repo/main" --allow-unrelated-histories --no-commit
    git commit -m "Merge $repo/main into main"
done

# Clean up: remove remote references
for repo in "${exercise_repos[@]}"; do
    git remote remove $repo
done

# Add GitHub remote
github_repo_url="git@github.com:$github_username/$main_repo.git"
git remote add github $github_repo_url

# Push to GitHub
git push -u github main

echo "Script executed successfully! The combined repository is published on GitHub: $github_repo_url"
