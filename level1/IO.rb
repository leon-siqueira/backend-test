require 'json'

# Read and write the files for
class IO
  def self.input(path)
    JSON.parse(File.read(relative_path(path)))
  end

  def self.output(path, data)
    File.write(relative_path(path), JSON.pretty_generate(data))
  end

  def self.relative_path(path)
    File.join(File.dirname(__FILE__), path)
  end
end
