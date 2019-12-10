require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING ID;"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def delete
      sql = "DELETE FROM customers WHERE id = $1;"
      values = [@id]
      SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    artists = SqlRunner.run(sql)
    return artists.map{ |customer| Customer.new(customer)}
  end

  def films
    sql = "SELECT films.* FROM films
            INNER JOIN tickets ON tickets.film_id = films.id
            WHERE tickets.film_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{ |film| Film.new(film) }
  end


end
