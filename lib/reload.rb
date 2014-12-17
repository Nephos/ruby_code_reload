module Reloader
  @@files ||= {}

  def self.test_not_exists file
    raise StandardError, 'file already exists in the reload list' if @@files.keys.include? file
  end
  def self.test_exists file
    raise StandardError, 'file doesn\'t exists in the reload list' if not @@files.keys.include? file
  end

  def self._
    return @@files
  end
  def self.files
    @@files.keys
  end

  def self.consts
    @@files.values.map{|e|e[:consts]}
  end
  def self.mtimes
    @@files.values.map{|e|e[:mtime]}
  end

  # return file <file> or nil if not exists
  def self.[] file
    return @@files[file]
  end

  # set the file <file> with <consts> and <mtime> if not nil
  def self.[]= file, v={consts: nil, mtime: nil}
    raise ArgumentError, 'v must be a Hash' unless v.is_a? Hash
    raise ArgumentError, 'consts must be an array of Symbols' unless v[:consts].is_a? Array and v[:consts].all?{|e| e.is_a? Symbol}
    raise ArgumentError, 'mtime must be an nil or of a Fixnum' unless v[:mtime].nil? or v[:mtime].is_a? Fixnum
    @@files[file] = {}
    @@files[file][:consts] = v[:consts]
    @@files[file][:mtime] = v[:mtime] || 0
  end

  # create a <file> with all old constants (no module/class), load news, and then only keep news. it file not exists, delete it from the list
  def self.up! file
    if File.exists? file
      binding.pry
      Reloader[file] = {consts: Object.constants, mtime: File.mtime(file).to_i}
      load(file)
      Reloader[file] = {consts: Object.constants - Reloader[file][:consts]}
    else
      Reloader.delete file
    end
  end

  # remove all constants of <file> (only existing in this file) and then empty the <file>
  def self.down! file
    Reloader[file].each{|const| Object.send(remove_const, const) if consts.flatten.count(const) == 1}
    Reloader[file] = {consts: [], mtime: 0}
  end

  # if file exists and changed, then down it and then up, else raise error
  def self.reload! file
    test_exists file
    puts "reload #{file}"
    return if not File.exists? file or File.mtime(file).to_i <= Reloader[file][:mtime]
    puts "#{file} changed"
    Reloader.down! file
    Reloader.up! file
    return
  end

  # if file not exists, then up else raise error
  def self.load! file
    test_not_exists file
    Reloader.up! file
    return
  end

end

def reload file
  raise ArgumentError, 'String __FILE__ expected' unless file.is_a? String
  file += '.rb' if not file =~ /.\../
  Reloader.files.include?(file) ? Reloader.reload!(file) : Reloader.load!(file)
end
