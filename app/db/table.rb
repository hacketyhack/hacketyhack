class HH::Sequel::SQLite::Dataset
  def table_name
    @opts[:from]
  end
  def widget(slot)
    slot.stack(:margin => 18).tap do |s|
      s.title "The #{table_name} Table"
      set.each do |item|
        s.para s.link(item[:title], :size => 18, :stroke => "#777"),
          " Table::Item", :stroke => "#999"
        s.para "at #{item[:created]}"
        s.para item[:editbox]
      end
    end
  end
end

class HH::Sequel::Dataset
  def only(id)
    first(:where => ['id = ?', id])
  end
  def limit(num)
    dup_merge(:limit => num)
  end
  def recent(num)
    order("created DESC").limit(num)
  end
  def save(data)
    @db.save(@opts[:from], data)
  end
end

module HH::DbMixin
  SPECIAL_FIELDS = ['id', 'created', 'updated']
  def tables
    execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name").
      map { |name,| name if name !~ /^HETYH_/ }.compact
  end
  def save(table, obj)
    table = table.to_s
    fields = get_fields(table)
    if fields.empty?
      startup(table, obj.keys)
    else
      missing = obj.keys - fields
      unless missing.empty?
        missing.each do |name|
          add_column(table, name)
        end
      end
    end
    if obj['id']
      from(table).only(obj['id']).update(obj.merge(:updated => Time.now))
    else
      from(table).insert(obj.merge(:created => Time.now, :updated => Time.now))
    end
  end
  def init
    unless table_exists? "HETYH_PREFS"
      create_table "HETYH_PREFS" do
        primary_key :id, :integer
        column :name, :text
        column :value, :text
        index :name
      end
    end
    HH.load_prefs
    unless table_exists? "HETYH_SHARES"
      create_table "HETYH_SHARES" do
        primary_key :id, :integer
        column :title, :text
        column :klass, :text
        column :active, :integer
        index :title
      end
    end
    HH.load_shares
  end
  def startup(table, fields)
    SPECIAL_FIELDS.each do |x|
      fields.each do |y|
        raise ArgumentError, "Can't have a field called #{y}!" if y.downcase == x
      end
    end
    create_table table do
      primary_key :id, :integer
      column :created, :datetime
      column :updated, :datetime
      fields.each do |name|
        column name, :text
        if [:title, :name].include? name
          index name
        end
      end
    end
    true
  rescue SQLite3::SQLException
    false
  end
  def drop_table(table)
    raise ArgumentError, "Table name must be letters, numbers, underscores only." if table !~ /^\w+$/
    execute("DROP TABLE #{table}")
  end
  def get_fields(table)
    raise ArgumentError, "Table name must be letters, numbers, underscores only." if table !~ /^\w+$/
    execute("PRAGMA table_info(#{table})").map { |id, name,| name }
  end
  def add_column(table, column)
    raise ArgumentError, "Table name must be letters, numbers, underscores only." if table !~ /^\w+$/
    execute("ALTER TABLE #{table} ADD COLUMN #{HH::Sequel::Schema.column_definition(:name => column, :type => :text)}")
  end
end

def Table(t)
  raise ArgumentError, "Table name must be letters, numbers, underscores only.  No spaces!" if t !~ /^\w+$/
  if HH.check_share(t, 'Table')
    Web.table(t)
  else
    HH::DB[t]
  end
end

module HH
  PREFS = {}
  SHARES = {}

  class << self
    def tutor_on?
      PREFS['tutor'] == 'on'
    end

    def tutor=(state)
      PREFS['tutor'] = state
      save_prefs
    end

    def tutor_lesson
      (PREFS['tut_lesson'] || 0).to_i
    end

    def tutor_lesson=(n)
      PREFS['tut_lesson']=n
      save_prefs
    end

    def tutor_page
      PREFS['tut_page'] || '/start'
    end

    def tutor_page=(p)
      PREFS['tut_page']=p
      save_prefs
    end

    def save_prefs
      preft = HH::DB["HETYH_PREFS"]
      preft.delete
      PREFS.each do |k, v|
        preft.insert(:name => k, :value => v)
      end
      nil
    end

    def load_prefs
      HH::DB["HETYH_PREFS"].each do |row|
        PREFS[row[:name]] = row[:value] unless row[:value].strip.empty?
      end
      PREFS['tutor'] = 'off'
    end

    def load_shares
      SHARES.clear
      HH::DB["HETYH_SHARES"].each do |row|
        SHARES["#{row[:title]}:#{row[:klass]}"] = row[:active]
      end
    end

    def add_share(title, klass)
      share = {:title => title, :klass => klass, :active => 1}
      HH::DB["HETYH_SHARES"].insert(share)
      SHARES["#{title}:#{klass}"] = 1
    end

    def check_share(title, klass)
      SHARES["#{title}:#{klass}"]
    end

    def script_exists?(name)
      File.exists?(HH::USER + "/" + name + ".rb")
    end

    def save_script(name, code)
      APP.emit :save, :name => name, :code => code
      File.open(HH::USER + "/" + name + ".rb", "w") do |f|
        f << code
      end
      return if PREFS['username'].blank?
    end

    def get_script(path)
      app = {:name => File.basename(path, '.rb'), :script => File.read(path)}
      m, = *app[:script].match(/\A(([ \t]*#.+)(\r?\n|$))+/)
      app[:mtime] = File.mtime(path)
      app[:desc] = m.gsub(/^[ \t]*#+[ \t]*/, '').strip.gsub(/\n+/, ' ') if m
      app
    end

    def scripts
      Dir["#{HH::USER}/*.rb"].map { |path| get_script(path) }.
        sort_by { |script| Time.now - script[:mtime] }
    end

    def samples
      Dir["#{HH::HOME}/samples/*.rb"].map do |path|
        s = get_script(path)
        # set the creation time to nil
        s[:mtime] = nil
        s[:sample] = true
        s
      end. sort_by { |script| script[:name] }
    end

    def user
      return if PREFS['username'].blank?
      unless @user and @user.name == PREFS['username']
        @user = Hacker(PREFS)
      end
      @user
    end
  end
end
