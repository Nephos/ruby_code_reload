require_relative 'code_reload/version'

module CodeReload
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
  def self.autofiles
    @@files.keep_if{|f,v| v[:auto] == true}.keys
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

  # set the file <file> with <consts>, <mtime>, and <auto> if not nil
  def self.[]= file, v={consts: []}
    raise ArgumentError, 'v must be a Hash' unless v.is_a? Hash
    raise ArgumentError, 'consts must be an array of Symbols' unless v[:consts].is_a? Array and v[:consts].all?{|e| e.is_a? Symbol}
    raise ArgumentError, 'mtime must be an nil or of a Fixnum' unless v[:mtime].nil? or v[:mtime].is_a? Fixnum
    @@files[file] ||= {}
    @@files[file][:consts] = v[:consts] || []
    @@files[file][:auto] = v[:auto] if not v[:auto].nil?
    @@files[file][:mtime] = v[:mtime] if not v[:mtime].nil?
  end

  # create a <file> with all old constants (no module/class), load news, and then only keep news. it file not exists, delete it from the list
  def self.up! file, auto=nil
    if File.exists? file
      CodeReload[file] = {consts: Object.constants, mtime: File.mtime(file).to_i, auto: auto}
      CodeReload.silence_warnings{load(file)}
      CodeReload[file] = {consts: Object.constants - CodeReload[file][:consts]}
    else
      CodeReload.delete file
    end
  end

  # remove all constants of <file> (only existing in this file) and then empty the <file>
  def self.down! file
    CodeReload[file][:consts].each{|const| Object.send(:remove_const, const) if defined? eval(const) == 'constant'}
    CodeReload[file] = {consts: [], mtime: 0}
  end

  # if file exists and changed, then down it and then up, else raise error
  def self.reload! file, auto=nil
    test_exists file
    return false if not File.exists? file or File.mtime(file).to_i <= CodeReload[file][:mtime]
    CodeReload.down! file
    CodeReload.up! file, auto
    return true
  end

  # if file not exists, then up else raise error
  def self.load! file, auto=nil
    test_not_exists file
    CodeReload.up! file, auto
    return true
  end

  def self.silence_warnings(&block)
    original_verbose, $VERBOSE = $VERBOSE, nil
    result = block.call
    $VERBOSE = original_verbose
    return result
  end

end

def reload file
  raise ArgumentError, 'String __FILE__ expected' unless file.is_a? String
  file += '.rb' if not file =~ /.\../
  CodeReload.files.include?(file) ? CodeReload.reload!(file) : CodeReload.load!(file)
end

def auto_reload file
  reload(file)
  CodeReload[file][:auto] = true
  #create a Thread
  loop do
    CodeReload.autofiles.each{|file| puts reload(file)}
    sleep 0.5
  end
end
