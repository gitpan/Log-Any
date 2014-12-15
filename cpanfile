requires "B" => "0";
requires "Carp" => "0";
requires "Data::Dumper" => "0";
requires "Exporter" => "0";
requires "Fcntl" => "0";
requires "IO::File" => "0";
requires "Test::Builder" => "0";
requires "base" => "0";
requires "constant" => "0";
requires "perl" => "5.008001";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "Test::More" => "0";
  requires "perl" => "5.008001";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.17";
  requires "perl" => "5.008001";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5";
  requires "Dist::Zilla::Plugin::OnlyCorePrereqs" => "0.003";
  requires "Dist::Zilla::Plugin::SurgicalPodWeaver" => "0.0021";
  requires "Dist::Zilla::PluginBundle::DAGOLDEN" => "0.072";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::More" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Spelling" => "0.12";
  requires "Test::Version" => "1";
};
