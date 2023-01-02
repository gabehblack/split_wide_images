require "rmagick"
include Magick
require "fileutils"

IMAGE_EXTENSIONS = %w[jpg jpeg png]

if ARGV.empty?
  puts "Script cannot run without a directory argument."
  puts "Please add a directory like so:"
  puts "$ ruby #{__FILE__} C:\\Documents\\Images\\Issuu"
  return
end

read_folder = File.absolute_path ARGV[0]
puts "Reading files in #{read_folder}"

files = []
Dir.foreach(ARGV[0]) do |filename|
  next if ['.', '..'].include? filename
  files << filename if IMAGE_EXTENSIONS.include? filename.split('.').last
end

puts "\nThe following files will be copied:"
puts files
puts ""
puts "Proceed? [y/N]"
return unless $stdin.gets.chomp.downcase == "y"
FileUtils.cd read_folder

output_folder = FileUtils.mkdir_p("script_output").first
files.each do |filename|
  print "Processing #{filename} . . . "
  img = Image.read(filename).first
  if img.columns > img.rows
    left_img = img.crop(0, 0, (img.columns/2).ceil, img.rows)
    right_img = img.crop((img.columns/2).ceil, 0, img.columns, img.rows)

    base_filename = filename.split('.')[0...-1].join
    file_ext = "." + filename.split('.')[-1]
    left_img.write output_folder + "/" + base_filename + "_a" + file_ext
    right_img.write output_folder + "/" + base_filename + "_b" + file_ext
  else
    img.write output_folder + "/" + img.filename
  end
  puts "done"
end
