require 'rabl_to_jbuilder'
require 'active_support'
require 'fileutils'

Dir['app/views/**/*.v1.rabl'].each do |file|
  basename = File.basename(file, '.v1.rabl')
  is_partial = !%w[show index new mine receive handler].include?(basename)

  target =
    if is_partial
      File.join(
        File.dirname(file),
        "_#{basename}.json.jbuilder"
      )
    else
      file.gsub(/\.v1\.rabl$/, '.json.jbuilder')
    end

  content = File.read(file)

  object =
    if is_partial
      Sexp.s(:lvar, File.basename(File.dirname(file)).singularize)
    else
      nil
    end

  jbuilder = RablToJbuilder.convert(content, object: object)

  File.write(target, jbuilder)
  FileUtils.rm(file)
end

system("git add app/views")
system("git commit -am 'Convert to jbuilder'")
