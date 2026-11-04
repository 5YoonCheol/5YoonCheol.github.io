# frozen_string_literal: true

source "https://rubygems.org"

gem "jekyll-theme-chirpy", "~> 7.6"

# 글을 합치거나 slug를 바꿀 때 옛 URL을 새 글로 리다이렉트한다 (front matter의 redirect_from)
gem "jekyll-redirect-from", "~> 0.16"

gem "html-proofer", "~> 5.0", group: :test

platforms :windows, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.2.0", :platforms => [:windows]
