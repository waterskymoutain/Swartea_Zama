import pathlib
import shutil
import subprocess
import re

def test_create_backdated_commits(tmp_path):
    repo = tmp_path
    script_src = pathlib.Path(__file__).resolve().parent.parent / "create_backdated_commits.sh"
    script_dst = repo / "create_backdated_commits.sh"
    shutil.copy(script_src, script_dst)
    readme = repo / "README.md"
    readme.write_text("# Test\n")
    subprocess.run(["git", "init"], cwd=repo, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    subprocess.run(["git", "config", "user.name", "Tester"], cwd=repo, check=True)
    subprocess.run(["git", "config", "user.email", "tester@example.com"], cwd=repo, check=True)
    subprocess.run(["git", "add", "README.md", "create_backdated_commits.sh"], cwd=repo, check=True)
    subprocess.run(["git", "commit", "-m", "init"], cwd=repo, check=True)
    subprocess.run(["bash", str(script_dst)], cwd=repo, check=True)
    lines = readme.read_text().splitlines()
    appended = lines[-12:]
    assert len(appended) == 12
    pattern = re.compile(r"^Backdated commit \d+ at 2025-06-10T06:(\d{2}):00$")
    for line in appended:
        m = pattern.match(line)
        assert m, f"Line format incorrect: {line}"
        minute = int(m.group(1))
        assert 0 <= minute < 60, f"Minute out of range: {minute}"
