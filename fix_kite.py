#!/usr/bin/env python3
"""Fix the duplicate fi/commit block in run_new"""
with open("/home/karnon/Dev-FullStack/dev-env/.devcontainer/bin/kite", "r") as f:
    content = f.read()

# Remove the duplicated block: extra fi + old commit code
old_block = """  if [[ $git_init_commit -eq 1 ]]; then
    git -C "$project_dir" add .
    git -C "$project_dir" -c user.name='kite' -c user.email='kite@dev-env' commit -m 'chore: scaffold project with dev-env' --allow-empty >/dev/null
  fi
  fi

  # Create initial commit
  git -C "$project_dir" add .
  git -C "$project_dir" -c user.name='kite' -c user.email='kite@dev-env' commit -m 'chore: scaffold project with dev-env' --allow-empty >/dev/null"""

new_block = """  # Create initial commit only when explicitly requested
  if [[ $git_init_commit -eq 1 ]]; then
    git -C "$project_dir" add .
    git -C "$project_dir" -c user.name='kite' -c user.email='kite@dev-env' commit -m 'chore: scaffold project with dev-env' --allow-empty >/dev/null
  fi"""

if old_block in content:
    content = content.replace(old_block, new_block)
    with open("/home/karnon/Dev-FullStack/dev-env/.devcontainer/bin/kite", "w") as f:
        f.write(content)
    print("Fixed duplicate fi/commit block")
else:
    print("ERROR: Could not find the duplicate block")
    # Try to show what's around it
    import re
    m = re.search(r'git_init_commit', content)
    if m:
        start = max(0, m.start() - 200)
        end = min(len(content), m.end() + 400)
        print("Context around git_init_commit:")
        print(repr(content[start:end]))
