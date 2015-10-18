# -*- encoding: utf-8 -*-
# stub: amazon-ecs 2.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "amazon-ecs"
  s.version = "2.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Herryanto Siatono"]
  s.date = "2015-03-31"
  s.description = "Generic Amazon Product Advertising Ruby API."
  s.email = "herryanto@gmail.com"
  s.homepage = "https://github.com/jugend/amazon-ecs"
  s.rubygems_version = "2.4.3"
  s.summary = "Generic Amazon Product Advertising Ruby API."

  s.installed_by_version = "2.4.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_runtime_dependency(%q<ruby-hmac>, ["~> 0.3"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<ruby-hmac>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<ruby-hmac>, ["~> 0.3"])
  end
end
