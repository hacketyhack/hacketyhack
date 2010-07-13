class SpeechError < Exception
end

module Speech
  FW = "/System/Library/Frameworks/ApplicationServices.framework" +
    "/Frameworks/SpeechSynthesis.framework/SpeechSynthesis"
  def self.say_espeak phrase
    unless @chld
      trap("CHLD") {Process.wait(-1, Process::WNOHANG)}
      @chld = true
    end
    fork do
      IO.popen("espeak --stdin", "w") do |f|
        f.write phrase
      end
    end
    true
  rescue Errno::EPIPE => e
    raise SpeechError, "you must install Espeak to use the `speak` method."
  end
  def self.say_fest phrase
    unless @chld
      trap("CHLD") {Process.wait(-1, Process::WNOHANG)}
      @chld = true
    end
    fork do
      IO.popen("festival --tts", "w") do |f|
        f.write phrase
      end
    end
    true
  rescue Errno::EPIPE => e
    raise SpeechError, "you must install Festival to use the `speak` method."
  end
  def self.say_sapi phrase
    require 'win32ole'
    @sapi ||= WIN32OLE.new('sapi.spvoice')
    @sapi.Speak phrase
    true
  rescue LoadError
    false
  rescue => e
    error e
    true
  end
  def self.say_apple phrase
    if File.exists? FW
      @apple ||= Module.new do
        require 'dl/import'
        extend DL::Importable
        dlload FW
        %w[SpeechBusy() SpeakString(void*)].each do |function|
          extern "short #{function}"
        end
      end
      @apple.speakString [phrase.size, phrase].pack("Ca*")
      true
    else
      false
    end
  end
end

def speak phrase
  Speech.say_sapi(phrase) or
    Speech.say_apple(phrase) or
      Speech.say_espeak(phrase)
end
