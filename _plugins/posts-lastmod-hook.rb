#!/usr/bin/env ruby
#
# 글의 수정일(last_modified_at)을 git 이력에서 계산한다.
#
# - front matter에 last_modified_at이 있으면 그 값을 그대로 쓴다.
# - 글이 두 번 이상 커밋됐을 때만 수정일을 넣는다.
# - 날짜 통일, 일괄 포맷 정리처럼 한 커밋에서 글을 대량으로 건드린 경우는
#   실제 내용 수정으로 보지 않는다. 그렇지 않으면 모든 글의 수정일이 같은 시각이 되어
#   sitemap·구조화 데이터의 dateModified가 의미를 잃는다.

BULK_COMMIT_THRESHOLD = 20

Jekyll::Hooks.register :posts, :post_init do |post|
  next if post.data['last_modified_at']

  commits = `git log --format="%H %ad" --date=iso -- "#{post.path}"`.lines.map(&:strip).reject(&:empty?)
  next if commits.size <= 1

  first_sha = commits.last.split(' ', 2).first

  commits.each do |line|
    sha, date = line.split(' ', 2)
    next if sha == first_sha

    changed = `git diff-tree --no-commit-id --name-only -r #{sha}`.lines.size
    next if changed > BULK_COMMIT_THRESHOLD

    post.data['last_modified_at'] = date
    break
  end
end
