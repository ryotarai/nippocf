require 'nippocf'
require 'keychain'
require 'io/console'
require 'confluence/confluence_connector'
require 'github/markdown'
require 'tmpdir'
require 'nokogiri'
require 'optparse'

if ENV['SOCKS_PROXY']
  require 'socksify'
  server, port = ENV['SOCKS_PROXY'].split(':')
  TCPSocket::socks_server = server
  TCPSocket::socks_port = port
end

module Nippocf
  class CLI
    KEYCHAIN_SERVICE_NAME = 'Nippocf'

    def initialize(argv)
      @argv = argv
      parse_options!
    end

    def run
      rpc = connect_to_confl

      blog_entries = rpc.getBlogEntries("~#{username}")
      title = time.strftime('%Y/%m/%d')
      entry_summary = blog_entries.find {|entry| entry['title'] == title }

      markdown_text = ""

      if entry_summary
        entry = rpc.getBlogEntry(entry_summary['id'])
        # entry contains markdown content
        doc = Nokogiri::HTML(entry['content'])
        elm = doc.css('div.markdown_source').first
        markdown_text = elm.text if elm
      else
        entry = {
          "content" => "",
          "title" => title,
          "space" => "~#{username}",
          "author" => username,
          "publishDate" => time,
          "permissions" => "0"
        }
      end

      Dir.mktmpdir do |dir|
        filename = File.join(dir, 'editing.md')
        open(filename, 'w') do |f|
          f.write markdown_text
        end
        editor = ENV['EDITOR'] || 'vim'
        system "#{editor} #{filename}"
        markdown_text = File.read(filename)
      end

      entry['content'] = GitHub::Markdown.render(markdown_text)
      entry['content'] << "<div class=\"markdown_source\" style=\"display:none\">#{markdown_text}</div>"
      rpc.storeBlogEntry(entry)
    end

    private
    def password_for_user(username)
      keychain = Keychain.generic_passwords.where(
        service: KEYCHAIN_SERVICE_NAME,
        account: username).first
      keychain && keychain.password
    end

    def set_password_for_user(username)
      print "Password for #{username}: "
      password = STDIN.noecho(&:gets).chomp
      puts
      Keychain.generic_passwords.create(
        service: KEYCHAIN_SERVICE_NAME, 
        password: password, 
        account: username)
      password
    end

    def connect_to_confl
      password = password_for_user(username)
      unless password
        password = set_password_for_user(username)
      end
      connector = Confluence::Connector.new(
        url: ENV['CONFL_URL'],
        username: username,
        password: password
      )
      connector.connect('confluence2').tap do |rpc|
        unless @debug
          rpc.log = Logger.new(StringIO.new)
        end
      end
    end

    def username
      ENV['CONFL_USERNAME']
    end

    def time
      now = Time.now
      year = now.year
      month = now.month
      day = now.day

      if @argv.size >= 1
        date_str = @argv.first
        elms = date_str.split('/')
        case elms.size
        when 1
          day, = elms
        when 2
          month, day = elms
        when 3
          year, month, day = elms
        else
          raise "Invalid arg"
        end
      end

      Time.local(year, month, day)
    end

    def parse_options!
      opt = OptionParser.new
      opt.on('--debug') { @debug = true }
      opt.parse!(@argv)
    end
  end
end

