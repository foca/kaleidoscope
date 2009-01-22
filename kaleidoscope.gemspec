Gem::Specification.new do |s|
  s.name = "kaleidoscope"
  s.version = "0.1.1"
 
  s.authors = ["Nicolás Sanguinetti"]
  s.date = "2009-01-22"
  s.description = "Easy and clean model factories for active record"
  s.email = "contacto@nicolassanguinetti.info"
  s.files = ["README.markdown", "lib/kaleidoscope.rb", "test/test_kaleidoscope.rb"]
  s.rubyforge_project = "kaleidoscope"
  s.summary = "Easy and clean model factories for active record"
 
  s.add_dependency "activerecord", ">= 2.2.2"
end
