class Student
  # Remember, you can access your database 
  # connection anywhere in this class
  # with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    create table if not exists students
    (id integer primary key,
    name text, 
    grade integer)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    drop table students
    SQL
    DB[:conn].execute(sql) 
  end

  def save 
    sql = <<-SQL #set up SQL query to pass in class object
    insert into 
    students (name, grade) 
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    
    @id = DB[:conn].execute("select 
    last_insert_rowid() from students")[0][0]
  end

  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end
  
end
