# -*- encoding: utf-8 -*-
# stub: activemerchant 1.59.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activemerchant".freeze
  s.version = "1.59.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tobias Luetke".freeze]
  s.date = "2016-05-18"
  s.description = "Active Merchant is a simple payment abstraction library used in and sponsored by Shopify. It is written by Tobias Luetke, Cody Fauser, and contributors. The aim of the project is to feel natural to Ruby users and to abstract as many parts as possible away from the user to offer a consistent interface across all supported gateways.".freeze
  s.email = "tobi@leetsoft.com".freeze
  s.homepage = "http://activemerchant.org/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2".freeze)
  s.rubyforge_project = "activemerchant".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Framework and tools for dealing with credit card transactions.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, ["< 5.1", ">= 3.2.14"])
      s.add_runtime_dependency(%q<i18n>.freeze, [">= 0.6.9"])
      s.add_runtime_dependency(%q<builder>.freeze, ["< 4.0.0", ">= 2.1.2"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.4"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<test-unit>.freeze, ["~> 3"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 1"])
      s.add_development_dependency(%q<thor>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activesupport>.freeze, ["< 5.1", ">= 3.2.14"])
      s.add_dependency(%q<i18n>.freeze, [">= 0.6.9"])
      s.add_dependency(%q<builder>.freeze, ["< 4.0.0", ">= 2.1.2"])
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.4"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<test-unit>.freeze, ["~> 3"])
      s.add_dependency(%q<mocha>.freeze, ["~> 1"])
      s.add_dependency(%q<thor>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, ["< 5.1", ">= 3.2.14"])
    s.add_dependency(%q<i18n>.freeze, [">= 0.6.9"])
    s.add_dependency(%q<builder>.freeze, ["< 4.0.0", ">= 2.1.2"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.4"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3"])
    s.add_dependency(%q<mocha>.freeze, ["~> 1"])
    s.add_dependency(%q<thor>.freeze, [">= 0"])
  end
end
