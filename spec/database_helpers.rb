require 'pg'
def persisted_data(id:, table: 'users')
	connection = PG.connect(dbname: 'chitter_test')
  	connection.query("SELECT * FROM #{table} WHERE id = '#{id}';")
end
